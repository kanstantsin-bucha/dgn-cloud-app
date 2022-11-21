//
//  File.swift
//  
//
//  Created by Kanstantsin Bucha on 21/11/2022.
//

import Foundation

import Vapor
import Fluent

public struct UsersController {
    public static func createUser(req: Request) async throws -> UserAPIModel {
        let apiModel = try req.content.decode(UserAPIModel.self)
        let dbModel = UserDBModel(apiModel)
        try await dbModel.create(on: req.db)
        return UserAPIModel(dbModel)
    }
    
    public static func getUser(req: Request) async throws -> UserAPIModel {
//        let report = try req.content.decode(DeviceReportAPIModel.self)
//        log.event("createDeviceReport: \(report)")
//        let model = try UserDBModel(report)
//        return model
//            .create(on: req.db)
//            .flatMapThrowing { try DeviceReportAPIModel(modelWithoutData: model) }
        UserAPIModel(id: UUID(), updatedAt: Date(), data: UserAccountData())
    }
}
