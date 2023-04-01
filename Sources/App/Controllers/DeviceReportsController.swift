//
//  DeviceReportsController.swift
//  
//
//  Created by Kanstantsin Bucha on 11/08/2022.
//

import Foundation
import Vapor
import Fluent

public struct DeviceReportsController: RouteCollection {
    public func boot(routes: RoutesBuilder) throws {
        routes.group("deviceReports") { routes in
            routes.post(use: createDeviceReport)
            let protected = routes.grouped(JWTBearerAuthenticator())
            protected.get(":id", use: getDeviceReport)
            protected.get("latestWithDevice", ":aliasID") { try await getLatestDeviceReport(req: $0) }
            protected.get("interval", ":aliasID") { try await getIntervalReports(req: $0) }
        }
    }
    
    public func createDeviceReport(req: Request) throws -> EventLoopFuture<DeviceReportAPIModel> {
        let report = try req.content.decode(DeviceReportAPIModel.self)
        log.event("createDeviceReport: \(report)")
        let model = try DeviceReportDBModel(report)
        return model
            .create(on: req.db)
            .flatMapThrowing { try DeviceReportAPIModel(modelWithoutData: model) }
    }

    public func getDeviceReport(req: Request) throws -> EventLoopFuture<DeviceReportAPIModel> {
        guard req.auth.has(UserDBModel.self) else { throw Abort(.unauthorized) }
        guard let uuid = req.parameters.get("id").flatMap(UUID.init(uuidString:)) else {
            log.event("getDeviceReport: Invalid parameter aliasID: \(String(describing: req.parameters.get("aliasID")))")
            throw Abort(.badRequest, reason: "Invalid parameter `id`")
        }
        log.event("getDeviceReport for \(uuid)")
        #warning("We are loosing Float pointing precision when passing DeviceReportAPIModel here")
        // like 3.7 -> 3.7000000476837158
        return DeviceReportDBModel
            .find(uuid, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { try DeviceReportAPIModel($0) }
    }
    
    public func getLatestDeviceReport(req: Request) async throws -> DeviceReportAPIModel {
        guard req.auth.has(UserDBModel.self) else { throw Abort(.unauthorized) }
        guard let aliasID = req.parameters.get("aliasID").flatMap(UUID.init(uuidString:)) else {
            throw Abort(.badRequest, reason: "Invalid parameter `aliasID`")
        }
        log.event("getLatestDeviceReport with aliasID:\(aliasID)")
        guard let aliasDBModel = try await DeviceAliasDBModel.find(aliasID, on: req.db) else {
            throw Abort(.notFound)
        }
        log.event("getLatestDeviceReport with deviceID:\(aliasDBModel.deviceID)")
        guard let deviceReportDBModel = try await DeviceReportDBModel
            .query(on: req.db)
            .filter(\.$deviceID == aliasDBModel.deviceID)
            .sort(\.$createdAt, .descending)
            .first()
        else {
            throw Abort(.notFound)
        }
        return DeviceReportAPIModel(deviceReportDBModel)
    }
    
    public func getIntervalReports(req: Request) async throws -> [DeviceReportAPIModel] {
        guard req.auth.has(UserDBModel.self) else { throw Abort(.unauthorized) }
        let maxReportsCount = 50
        guard let aliasID = req.parameters.get("aliasID").flatMap(UUID.init(uuidString:)) else {
            throw Abort(.badRequest, reason: "Invalid parameter `aliasID`")
        }
        let lastHoursCount = try req.query.decode(IntervalChatQuery.self).lastHoursCount
        guard lastHoursCount > 0 && lastHoursCount < 25 else {
            throw Abort(.expectationFailed, reason: "lastHoursCount is not in range 1...24")
        }
        let intervalStartDate = try calculateStartDate(lastHoursCount: lastHoursCount)
        log.event("getIntervalChartReports with aliasID:\(aliasID) for \(lastHoursCount) last hours")
        guard let aliasDBModel = try await DeviceAliasDBModel.find(aliasID, on: req.db) else {
            throw Abort(.notFound)
        }
        log.event("getIntervalChartReports with deviceID:\(aliasDBModel.deviceID)")
        let dbModels = try await DeviceReportDBModel
            .query(on: req.db)
            .filter(\.$deviceID == aliasDBModel.deviceID)
            .filter(\.$createdAt >= intervalStartDate)
            .limit(1500)
            .all()
        let deflated = deflateArray(dbModels, maxElements: maxReportsCount)
        return try deflated.map { try DeviceReportAPIModel($0) }
    }
    
    // MARK: - Private methods
    
    private func deflateArray<Element>(_ incoming: [Element], maxElements: Int) ->  [Element] {
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
    
    private func calculateStartDate(lastHoursCount: UInt) throws -> Date {
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
