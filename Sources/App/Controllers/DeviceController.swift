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
        protected.post() { try await addDevice(req: $0) }
        protected.delete(":aliasID", use: deleteDevice)
    }
    
    func deleteDevice(req: Request) throws -> EventLoopFuture<UserAPIModel> {
        let user = try req.auth.require(UserDBModel.self)
        guard let deviceAliasID = req.parameters.get("aliasID").flatMap(UUID.init(uuidString:)) else {
            log.event("deleteDevice: Invalid parameter deviceAliasID: \(String(describing: req.parameters.get("deviceAliasID")))")
            throw Abort(.badRequest, reason: "Invalid parameter `deviceAliasID`")
        }
        user.deviceAliasIDs = (user.deviceAliasIDs ?? []).filter { $0 != deviceAliasID }
        return user
            .save(on: req.db)
            .flatMapThrowing {
                return UserAPIModel(user)
            }
    }
    
    func addDevice(req: Request) async throws -> DeviceAliasAPIModel {
        let user = try req.auth.require(UserDBModel.self)
        let deviceAliasAPIModel = try req.content.decode(DeviceAliasAPIModel.self)
        try await verifyThatCanAdd(
            deviceID: deviceAliasAPIModel.deviceID,
            user: user,
            db: req.db
        )
        
        let model = DeviceAliasDBModel(deviceAliasAPIModel)
        guard let deviceAliasID = model.id else { throw Abort(.internalServerError) }
        try await model.create(on: req.db)
    
        var ids = user.deviceAliasIDs ?? []
        ids.append(deviceAliasID)
        user.deviceAliasIDs = ids
        try await user.save(on: req.db)
        return DeviceAliasAPIModel(model)
    }
    
    private func verifyThatCanAdd(deviceID: String, user: UserDBModel, db: Database) async throws {
        guard let aliasesIDs = user.deviceAliasIDs, !aliasesIDs.isEmpty else {
            return
        }
        let deviceIDs = try await DeviceAliasDBModel.query(on: db)
            .filter(\.$id ~~ aliasesIDs)
            .all()
            .map { $0.deviceID }
        guard !deviceIDs.contains(deviceID) else {
            throw Abort(.conflict)
        }
    }
}
