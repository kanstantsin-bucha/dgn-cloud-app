//
//  File.swift
//  
//
//  Created by Kanstantsin Bucha on 18/06/2022.
//

import Foundation

let log: Logging = Logger()

enum LogType {
    case error
    case warning
    case info
    
    // -/ here are user actions /-
    
    case userAction
    case event
    
    // -/ here are operations /-
    
    case operation
    case success
    case failure
    case cancel
}

protocol Logging {
    func printLog(_ statement: String, level: LogType, prefix: String)
    
    func error(_ error: Error, prefix: String)
    func error(_ message: String, prefix: String)
    func warning(_ message: String, prefix: String)
    func info(_ message: String, prefix: String)
    // MARK: - here are user actions
    
    func user(_ message: String, prefix: String)
    func event(_ message: String, prefix: String)
    
    // MARK: - here are operations
    
    func operation(_ message: String, prefix: String)
    func success(_ message: String, prefix: String)
    func failure(_ message: String, prefix: String)
    func cancel(_ message: String, prefix: String)
}

extension Logging {
    func error(_ error: Error, prefix: String = #fileID) {
//        SentryHelper.error("\(prefix) Error: \(error.localizedDescription)")
        printLog(error.localizedDescription, level: .error, prefix: prefix)
    }
    
    func error(_ message: String, prefix: String = #fileID) {
//        SentryHelper.error("\(prefix) Error: \(message)")
        printLog(message, level: .error, prefix: prefix)
    }
    
    func warning(_ message: String, prefix: String = #fileID) {
        printLog(message, level: .warning, prefix: prefix)
    }
    
    func info(_ message: String, prefix: String = #fileID) {
        printLog(message, level: .info, prefix: prefix)
    }
    
    // MARK: - here are user actions
    
    func user(_ message: String, prefix: String = #fileID) {
        printLog(message, level: .userAction, prefix: prefix)
    }
    
    func event(_ message: String, prefix: String = #fileID) {
        printLog(message, level: .event, prefix: prefix)
    }
    
    // MARK: - here are operations
    
    func operation(_ message: String, prefix: String = #fileID) {
        printLog(message, level: .operation, prefix: prefix)
    }
    
    func success(_ message: String, prefix: String = #fileID) {
        printLog(message, level: .success, prefix: prefix)
    }
    
    func failure(_ message: String, prefix: String = #fileID) {
        printLog(message, level: .failure, prefix: prefix)
    }
    
    func cancel(_ message: String, prefix: String = #fileID) {
        printLog(message, level: .cancel, prefix: prefix)
    }
}

struct Logger: Logging {
    
    // MARK: - Private methods
    
    func printLog(_ statement: String, level: LogType, prefix: String) {
        let message = truncated(prefix) + " " + statement
        switch level {
        case LogType.error:
            print("⛔️ \(message)")
            
        case LogType.warning:
            print("🔔 \(message)")
        
        case LogType.info:
            print("ℹ️ \(message)")
            
        // -/ here are user actions /-
        
        case LogType.userAction:
            print("😃 \(message)")
            
        case LogType.event:
            print("📢 \(message)")
            
        // -/ here are operations /-
            
        case LogType.operation:
            print("🔳 \(message)")
            
        case LogType.success:
            print("🟩 \(message)")
            
        case LogType.failure:
            print("🟥 \(message)")
            
        case LogType.cancel:
            print("⬜️ \(message)")
        }
    }
    
    // MARK: - Private methods
    
    private func truncated(_ prefix: String) -> String {
        guard var index = prefix.lastIndex(of: "/") else {
            return prefix
        }

        if index != prefix.endIndex {
            index =  prefix.index(after: index)
        }
        return String(prefix.suffix(from: index))
    }
}
