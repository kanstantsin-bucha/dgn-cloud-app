//
//  UserAPIModel.swift
//  
//
//  Created by Kanstantsin Bucha on 21/11/2022.
//

import Foundation
import Vapor

public struct UserAPIModel: Authenticatable, Content, CustomStringConvertible {
    public let id: UUID? // Id under that report was stored on the server
    public let updatedAt: Date? // Date when User record was stored on the server (rewrited)
    public let data: UserAccountData // Data of the represented User account
    public let userName: String
    public let password: String?
    
    #warning("Temporary")
    // TODO: - remove after implementation
//    init(id: UUID? = nil, updatedAt: Date? = nil, data: UserAccountData) {
//        self.id = id
//        self.updatedAt = updatedAt
//        self.data = data
//    }
    
    public init(_ model: UserDBModel) {
        id = model.id
        updatedAt = model.updatedAt
        userName = model.userName
        password = nil
        data = UserAccountData(model)
    }
    
    public var description: String {
        """
        <UserAPIModel id: \(String(describing: id)), updatedAt: \(String(describing: updatedAt)), \
        data: \(data)
        """
    }
}

public struct UserAccountData: Codable {
    public let loggedInAt: Date? // Date when User last log in was occured on the server
    public let devicesIDs: [UUID] // IDs of all devices user connected to the User account
    
    #warning("Temporary")
    // TODO: - remove after implementation
    init() {
        loggedInAt = nil
        devicesIDs = []
    }
    
    public init(_ model: UserDBModel) {
        loggedInAt = model.loggedInAt
        devicesIDs = model.devicesIDs ?? []
    }
}
