//
//  File.swift
//  
//
//  Created by Kanstantsin Bucha on 18/06/2022.
//

import Vapor

public struct SemanticVersion: Comparable, CustomStringConvertible {
    public let major: UInt
    public let middle: UInt
    public let minor: UInt
    
    public var description: String {
        return "<\(major).\(middle).\(minor)>"
    }
    
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
    
    public static func < (lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        compare(lhs: lhs, rhs: rhs, < )
    }
    
    public static func <= (lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        compare(lhs: lhs, rhs: rhs, <= )
    }
    
    public static func >= (lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        compare(lhs: lhs, rhs: rhs, >= )
    }
    
    public static func > (lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        compare(lhs: lhs, rhs: rhs, > )
    }
    
    // MARK: - Private methods
    
    private static func compare(
        lhs: SemanticVersion,
        rhs: SemanticVersion,
        _ comparator: (UInt, UInt) -> Bool
    ) -> Bool {
        if comparator(lhs.major, rhs.major) { return true }
        if comparator(lhs.middle, rhs.middle) { return true }
        return comparator(lhs.minor, rhs.minor)
    }
}
