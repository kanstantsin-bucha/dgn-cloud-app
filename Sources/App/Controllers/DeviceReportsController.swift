//
//  DeviceReportsController.swift
//  
//
//  Created by Kanstantsin Bucha on 11/08/2022.
//

import Foundation
import Vapor
import Fluent

public struct DeviceReportsController {
    public static func createDeviceReport(req: Request) throws -> EventLoopFuture<DeviceReportAPIModel> {
        let report = try req.content.decode(DeviceReportAPIModel.self)
        log.event("createDeviceReport: \(report)")
        let model = try DeviceReportDBModel(report)
        return model
            .create(on: req.db)
            .flatMapThrowing { try DeviceReportAPIModel(modelWithoutData: model) }
    }

    public static func getDeviceReport(req: Request) throws -> EventLoopFuture<DeviceReportAPIModel> {
        guard let id = (req.parameters.get("id").flatMap { UUID($0) }) else {
            log.event("getDeviceReport: Invalid parameter id: \(String(describing: req.parameters.get("id")))")
            throw Abort(.badRequest, reason: "Invalid parameter `id`")
        }
        log.event("getDeviceReport for \(id)")
        #warning("We are loosing Float pointing precision when passing DeviceReportAPIModel here")
        // like 3.7 -> 3.7000000476837158
        return DeviceReportDBModel
            .find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { try DeviceReportAPIModel($0) }
    }
    
    public static func getLatestDeviceReport(req: Request) throws -> EventLoopFuture<DeviceReportAPIModel> {
        guard let deviceId = req.parameters.get("id") else {
            throw Abort(.badRequest, reason: "Invalid parameter `id`")
        }
        print("getLatestDeviceReport with deviceId:\(deviceId)")
        return DeviceReportDBModel
            .query(on: req.db)
            .filter(\.$deviceID == deviceId)
            .sort(\.$createdAt, .descending)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { try DeviceReportAPIModel($0) }
    }
}
