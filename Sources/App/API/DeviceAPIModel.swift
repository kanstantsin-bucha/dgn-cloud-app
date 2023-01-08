//
//  File.swift
//  
//
//  Created by Kanstantsin Bucha on 08/01/2023.
//

import Foundation
import Vapor

public struct DeviceAPIModel: Content {
    public var id: UUID?
    public var name: String
    public var type: String
    public var token: String
    
    init(_ dbModel: DeviceDBModel) {
        id = dbModel.id
        name = dbModel.name
        type = dbModel.type
        token = dbModel.token
    }
}
