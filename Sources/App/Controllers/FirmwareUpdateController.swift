//
//  FirmwareUpdateController.swift
//  
//
//  Created by Kanstantsin Bucha on 18/06/2022.
//

import Foundation
import Vapor

public class FirmwareUpdateController: RouteCollection {
    private let maxSimultaneousUpdatesCount = 20
    private var runningUpdatesCount = 0
    
    public func boot(routes: RoutesBuilder) throws {
        routes.group("firmware") { routes in
            routes.get("update", use: getFirmwareUpdate)
        }
    }
    
    public func getFirmwareUpdate(req: Request) throws -> Response {
        let query = try req.query.decode(UpdateRequestQuery.self)
        let deviceVersion = try SemanticVersion(string: query.deviceVersion)
        guard let (latestVersion, path) = try service(FileSystem.self).searchVersionedFile(
            ofType: query.type.lowercased(),
            inStorage: .firmware
        ) else {
            throw Abort(.serviceUnavailable)
        }
        guard deviceVersion < latestVersion else {
            throw Abort(.noContent)
        }
        guard runningUpdatesCount < maxSimultaneousUpdatesCount else {
            throw Abort(.tooManyRequests)
        }
        runningUpdatesCount += 1
        let id = UUID()
        log.event("""
            Requested Update: \(id), simultaneous: \(runningUpdatesCount), deviceId: \(query.deviceId) \
            deviceVersion: \(deviceVersion), latestVersion: \(latestVersion) at file: \(path)
            """
        )
        let response = req.fileio.streamFile(at: path) { [weak self] result in
            self?.runningUpdatesCount -= 1
            log.event("Finished Update \(id) with result: \(result)")
        }
        return response
    }
}
