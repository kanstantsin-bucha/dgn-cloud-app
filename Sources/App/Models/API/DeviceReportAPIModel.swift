//
//  DeviceReportAPIModel.swift
//  
//
//  Created by Kanstantsin Bucha on 10/08/2022.
//

import Foundation
import Vapor

public final class DeviceReportAPIModel: Content, CustomStringConvertible {
    public let id: UUID? // It is optional when we process get request until we save DB instance in a database
    public let coValue: Float?
    public let createdAt: Date?
    
    public init(_ model: DeviceReportDBModel) throws {
        id = model.id
        coValue = model.coValue
        createdAt = model.createdAt
    }
    
    public var description: String {
        return """
            <DeviceReport id: \(String(describing: id)), coValue: \(String(describing: coValue))>
            """
    }
}
