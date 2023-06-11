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
        protected.delete(":aliasID") { try await deleteDevice(req: $0) }
    }
    
    func deleteDevice(req: Request) async throws -> MeAPIModel  {
        let user = try req.auth.require(UserDBModel.self)
        guard let deviceAliasID = req.parameters.get("aliasID").flatMap(UUID.init(uuidString:)) else {
            log.event("deleteDevice: Invalid parameter aliasID: \(String(describing: req.parameters.get("aliasID")))")
            throw Abort(.badRequest, reason: "Invalid parameter `aliasID`")
        }
        let deviceAliasIDs = (user.deviceAliasIDs ?? []).filter { $0 != deviceAliasID }
        user.deviceAliasIDs = deviceAliasIDs
        try await user.save(on: req.db)
        // TODO: delete device if there are 0 aliases to it
        let deviceAliasesDB = try await DeviceAliasDBModel.query(on: req.db)
            .filter(\.$id ~~ deviceAliasIDs)
            .all()
        return MeAPIModel(
            id: user.id!,
            userName: user.userName,
            devicesAliases: deviceAliasesDB.map { DeviceAliasAPIModel($0) }
        )
    }
    
    func addDevice(req: Request) async throws -> MeAPIModel {
        let user = try req.auth.require(UserDBModel.self)
        let createDeviceAPIModel = try req.content.decode(CreateDeviceAPIModel.self)
        
        try await verifyThatNotDuplicate(
            deviceID: createDeviceAPIModel.deviceID,
            user: user,
            db: req.db
        )

        let model = DeviceAliasDBModel(createDeviceAPIModel)
        guard let deviceAliasID = model.id else { throw Abort(.internalServerError) }
        try await model.create(on: req.db)
    
        var deviceAliasIDs = user.deviceAliasIDs ?? []
        deviceAliasIDs.append(deviceAliasID)
        user.deviceAliasIDs = deviceAliasIDs
        try await user.save(on: req.db)
        let deviceAliasesDB = try await DeviceAliasDBModel.query(on: req.db)
            .filter(\.$id ~~ deviceAliasIDs)
            .all()
        return MeAPIModel(
            id: user.id!,
            userName: user.userName,
            devicesAliases: deviceAliasesDB.map { DeviceAliasAPIModel($0) }
        )
    }
    
    private func verifyThatNotDuplicate(
        deviceID: String, user: UserDBModel,
        db: Database
    ) async throws {
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
