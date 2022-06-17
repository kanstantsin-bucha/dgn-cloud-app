//
//  File.swift
//  
//
//  Created by Kanstantsin Bucha on 18/06/2022.
//

import Vapor

public struct SemanticVersion {
    public let major: UInt
    public let middle: UInt
    public let minor: UInt
    
    init(string: String) throws {
        let parts = string.split(separator: ".")
        guard parts.count == 3 else {
            throw Abort(.badRequest)
        }
        guard let major = UInt(parts[0]),
              let middle = UInt(parts[1]),
              let minor = UInt(parts[2])
        else {
            throw Abort(.badRequest)
        }
        self.major = major
        self.middle = middle
        self.minor = minor
    }
}
