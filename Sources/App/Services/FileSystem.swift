//
//  FileSystem.swift
//  
//
//  Created by Kanstantsin Bucha on 12/08/2022.
//

import Foundation
import Vapor

public enum FileSystemStorage: String {
    case firmware = "/firmware"
    case environmentConfig = "/environmentConfig"
    case certificates = "/certificates"
}

public final class FileSystem: Service {
    private var workingDirectory = ""
    public var serverFilesPath: String { workingDirectory + "/ServerFiles" }
    
    public init() {}
    
    public func configureWith(_ app: Application) {
        switch app.environment {
        case .production:
            workingDirectory = "/app"
            
        default:
            workingDirectory = URL(fileURLWithPath: String(#filePath))
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .relativePath
        }
        
        log.info("""
            Configuration completed for environment: \(app.environment.name),
            workingDirectory: \(workingDirectory)
            """
        )
    }
    
    public func filePath(
        fileName: String,
        inStorage storage: FileSystemStorage
    ) -> String {
        let directory = serverFilesPath + storage.rawValue
        return directory + "/" + fileName
    }
    
    public func searchVersionedFile(
        ofType type: String,
        inStorage storage: FileSystemStorage
    ) throws -> (version: SemanticVersion, path: String)? {
        let manager = FileManager.default
        let directory = serverFilesPath + storage.rawValue
        guard manager.fileExists(atPath: directory) else {
            log.failure("No VersionedFile in directory at path")
            throw Abort(.internalServerError, reason: "No VersionedFile in directory at path: \(directory)")
        }
        return try manager.contentsOfDirectory(atPath: directory)
            .compactMap { itemPath in
                guard itemPath.starts(with: type, by: == ) else {
                    return nil
                }
                let fileName = (itemPath as NSString).deletingPathExtension
                let parts = fileName.split(separator: "_")
                log.info("VersionedFile file name split: \(parts)")
                guard parts.count == 2, let version = try? SemanticVersion(string: String(parts[1])) else {
                    log.failure("Found a VersionedFile with invalid format: \(itemPath)")
                    return nil
                }
                return (version, directory + "/" + itemPath)
            }
            .first
    }
}
