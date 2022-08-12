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
        let report = DeviceReportDBModel()
        print("create before: \(report)")
        return report
            .create(on: req.db)
            .flatMapThrowing { try DeviceReportAPIModel(report) }
    }

    public static func getDeviceReport(req: Request) throws -> EventLoopFuture<DeviceReportAPIModel> {
        guard let id = (req.parameters.get("id").flatMap { UUID($0) }) else {
            throw Abort(.badRequest, reason: "Invalid parameter `id`")
        }
        print("getDeviceReport for \(id)")
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
