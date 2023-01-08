//
//  MeAPIModel.swift
//  
//
//  Created by Kanstantsin Bucha on 08/01/2023.
//

import Foundation
import Vapor

struct MeAPIModel: Content {
    var id: UUID
    var userName: String
}
