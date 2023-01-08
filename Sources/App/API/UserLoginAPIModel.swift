//
//  UserLoginAPIModel.swift
//  
//
//  Created by Kanstantsin Bucha on 08/01/2023.
//

import Foundation
import Vapor

struct UserLoginAPIModel: Content {
    var userName: String
    var password: String
}
