//
//  FirmwareUpdateController.swift
//  
//
//  Created by Kanstantsin Bucha on 18/06/2022.
//

import Foundation
import Vapor

public class FirmwareUpdateController: Service {
    private static let maxSimultaneousUpdatesCount = 20
    private static var runningUpdatesCount = 0
    public static func getFirmwareUpdate(req: Request) throws -> Response {
        let query = try req.query.decode(UpdateFirmware.self)
        let directory = service(FileSystem.self).firmwareUpdatePath
        let deviceVersion = try SemanticVersion(string: query.deviceVersion)
        guard let (latestVersion, path) = try searchFirmware(
            ofType: query.deviceType.lowercased(),
            at: directory
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
    
    // MARK: - Private Methods
    
    private static func searchFirmware(ofType type: String, at directory: String) throws -> (version: SemanticVersion, path: String)? {
        let manager = FileManager.default
        guard manager.fileExists(atPath: directory) else {
            log.failure("No firmware directory at path: \(directory)")
            throw Abort(.internalServerError)
        }
        return try manager.contentsOfDirectory(atPath: directory)
            .compactMap { itemPath in
                guard itemPath.starts(with: type, by: == ) else {
                    return nil
                }
                let fileName = (itemPath as NSString).deletingPathExtension
                let parts = fileName.split(separator: "_")
                log.info("Firmware file name splitted: \(parts)")
                guard parts.count == 2, let version = try? SemanticVersion(string: String(parts[1])) else {
                    log.failure("Found a firmware file with invalid format: \(itemPath)")
                    return nil
                }
                return (version, directory + "/" + itemPath)
            }
            .first
    }
}

fileprivate struct UpdateFirmware: Content {
    let deviceVersion: String
    let deviceType: String
    let deviceId: String
}
