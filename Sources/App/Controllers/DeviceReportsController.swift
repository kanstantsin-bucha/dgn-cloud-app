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
    
    public static func getIntervalReports(req: Request) throws -> EventLoopFuture<[DeviceReportAPIModel]> {
        let maxReportsCount = 50
        guard let deviceId = req.parameters.get("id") else {
            throw Abort(.badRequest, reason: "Invalid parameter `id`")
        }
        let lastHoursCount = try req.query.decode(IntervalChatQuery.self).lastHoursCount
        guard lastHoursCount > 0 && lastHoursCount < 25 else {
            throw Abort(.expectationFailed, reason: "lastHoursCount is not in range 1...24")
        }
        let intervalStartDate = try calculateStartDate(lastHoursCount: lastHoursCount)
        log.event("getIntervalChartReports with deviceId:\(deviceId) for \(lastHoursCount) last hours")
        var dbModels: [Result<DeviceReportDBModel, Error>] = []
        return DeviceReportDBModel
            .query(on: req.db)
            .filter(\.$deviceID == deviceId)
            .filter(\.$createdAt >= intervalStartDate)
            .sort(\.$createdAt, .ascending)
            .limit(2000)
            .all { model in
                dbModels.append(model)
            }.flatMapThrowing {
                let apiModels = try dbModels.map { try DeviceReportAPIModel($0.get()) }
                return deflateArray(apiModels, maxElements: maxReportsCount)
            }
    }
    
    // MARK: - Private methods
    
    private static func deflateArray<Element>(_ incoming: [Element], maxElements: Int) ->  [Element] {
        #warning("This method login should be improved - array elements count always bigger than of maxElements")
        guard incoming.count > maxElements else { return incoming }
        let divider = (incoming.count / (maxElements - 2))
        var result: [Element] = []
        incoming.enumerated().forEach { element in
            let index = element.offset
            if (index == 0 || index == incoming.count - 1 || index % divider == 0) {
                result.append(element.element)
            }
        }
        return result
    }
    
    private static func calculateStartDate(lastHoursCount: UInt) throws -> Date {
        let calendar = Calendar.current
        let start = Date(timeIntervalSinceNow: TimeInterval(lastHoursCount) * -3600)
        var components = calendar.dateComponents([.era, .year, .month, .day, .hour], from: start)
        components.hour = 1 + (components.hour ?? 0)
        guard let date = calendar.date(from: components) else {
            throw Abort(.internalServerError, reason: "Failed start date calculation for \(lastHoursCount) last hours")
        }
        return date
    }
}

fileprivate struct IntervalChatQuery: Content {
    let lastHoursCount: UInt
}
