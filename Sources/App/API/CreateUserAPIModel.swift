//
//  UserAPIModel.swift
//  
//
//  Created by Kanstantsin Bucha on 21/11/2022.
//

import Foundation
import Vapor

public struct CreateUserAPIModel: Authenticatable, Content, CustomStringConvertible {
    public let userName: String
    public let password: String?
    
    public var description: String {
        """
        <CreateUserAPIModel userName: \(String(describing: userName))
        """
    }
}
