//
//  FileSystem.swift
//  
//
//  Created by Kanstantsin Bucha on 12/08/2022.
//

import Foundation
import Vapor

public final class FileSystem: Service {
    private var workingDirectory = ""
    public var serverFilesPath: String { workingDirectory + "/ServerFiles" }
    public var firmwareUpdatePath: String {
        print(Unmanaged.passUnretained(self).toOpaque())
        return serverFilesPath + "/DeviceFirmware"
    }
    
    public init() {}
    
    public func configureWith(_ app: Application) {
        switch app.environment {
        case .production:
            workingDirectory = "/var/www/dg-cloud"
            
        default:
            workingDirectory = FileManager.default.currentDirectoryPath
        }
        
        log.info("""
            Configuration completed for environment: \(app.environment.name),
            workingDirectory: \(workingDirectory)
            """
        )
        print(Unmanaged.passUnretained(self).toOpaque())
    }
}
