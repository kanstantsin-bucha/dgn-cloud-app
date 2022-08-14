//
//  EnvironmentConfigController.swift
//  
//
//  Created by Kanstantsin Bucha on 14/08/2022.
//

import Foundation
import Vapor
import Fluent

public struct EnvironmentConfigController {
    private static let maxSimultaneousUpdatesCount = 20
    private static var runningUpdatesCount = 0
    
    public static func getConfigUpdate(req: Request) throws -> Response {
        let query = try req.query.decode(UpdateRequestQuery.self)
        let deviceVersion = try SemanticVersion(string: query.deviceVersion)
        guard let (latestVersion, path) = try service(FileSystem.self).searchVersionedFile(
            ofType: query.deviceType.lowercased(),
            inStorage: .environmentConfig
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
        let response = req.fileio.streamFile(at: path) { result in
            runningUpdatesCount -= 1
            log.event("Finished Update \(id) with result: \(result)")
        }
        return response
    }
}


