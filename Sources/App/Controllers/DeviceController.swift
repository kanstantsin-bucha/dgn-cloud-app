//
//  DeviceController.swift
//  
//
//  Created by Kanstantsin Bucha on 08/01/2023.
//

import Foundation
import Fluent
import Vapor

struct DeviceController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let protected = routes.grouped("devices")
            .grouped(JWTBearerAuthenticator())
        protected.post(use: addDevice)
        protected.delete(":id", use: deleteDevice)
    }
    
    func deleteDevice(req: Request) throws -> EventLoopFuture<UserAPIModel> {
        let user = try req.auth.require(UserDBModel.self)
        guard let deviceID = (req.parameters.get("id").flatMap { UUID($0) }) else {
            log.event("deleteDevice: Invalid parameter id: \(String(describing: req.parameters.get("id")))")
            throw Abort(.badRequest, reason: "Invalid parameter `id`")
        }
        user.devicesIDs = (user.devicesIDs ?? []).filter { $0 != deviceID }
        return user
            .save(on: req.db)
            .flatMapThrowing {
                return UserAPIModel(user)
            }
    }
    
    func addDevice(req: Request) throws -> EventLoopFuture<DeviceAPIModel> {
        let user = try req.auth.require(UserDBModel.self)
        let device = try req.content.decode(DeviceAPIModel.self)
        let model = DeviceDBModel(device)
        guard let deviceID = model.id else { throw Abort(.internalServerError) }
        let result = model.create(on: req.db).flatMap { _ in
            var ids = user.devicesIDs ?? []
            ids.append(deviceID)
            user.devicesIDs = ids
            return user.save(on: req.db).transform(to: DeviceAPIModel(model))
        }
        return result
    }
}
