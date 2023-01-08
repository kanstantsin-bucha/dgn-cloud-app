//
//  UpdateRequestQuery.swift
//  
//
//  Created by Kanstantsin Bucha on 14/08/2022.
//

import Foundation
import Vapor

public struct UpdateRequestQuery: Content {
    let deviceVersion: String
    let type: String
    let deviceId: String
}
