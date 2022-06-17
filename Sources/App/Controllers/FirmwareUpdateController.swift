//
//  FirmwareUpdateController.swift
//  
//
//  Created by Kanstantsin Bucha on 18/06/2022.
//

import Foundation
import Vapor

public class FirmwareUpdateController: Service {
    public func updateFirmware(currentVersion: SemanticVersion) throws -> Data {
        log.event("update requested, current version: \(currentVersion)")
        log.info("current firmware version is the latest one")
        throw Abort(.noContent)
    }
}
