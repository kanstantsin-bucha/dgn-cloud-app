//
//  DeviceReportAPIModel.swift
//  
//
//  Created by Kanstantsin Bucha on 10/08/2022.
//

import Foundation
import Vapor

public struct DeviceReportContext: Codable {
    public let busVoltage: Float?
    public let coZeroV: Float?
    public let coV: Float?
    public let coPpm: Float?
    public let tempCelsius: Float?
    public let pressureHPa: Float?
    public let humidity: Float?
    public let gasResistance: Float?
    public let iaq: Float?
    public let staticIaq: Float?
    public let co2Equivalent: Float?
    public let breathVocEquivalent: Float?
    public let compGasValue: Float?
    public let gasPercentage: Float?
    
    public init(_ model: DeviceReportDBModel) {
        busVoltage = model.busVoltage
        coZeroV = model.coZeroV
        coV = model.coV
        coPpm = model.coPpm
        tempCelsius = model.tempCelsius
        pressureHPa = model.pressureHPa
        humidity = model.humidity
        gasResistance = model.gasResistance
        iaq = model.iaq
        staticIaq = model.staticIaq
        co2Equivalent = model.co2Equivalent
        breathVocEquivalent = model.breathVocEquivalent
        compGasValue = model.compGasValue
        gasPercentage = model.gasPercentage
    }
}

public struct DeviceReportAPIModel: Content, CustomStringConvertible {
    public let id: UUID? // Id under that report was stored on the server
    public let deviceId: String? // ID of device that we have
    public let millis: UInt32? // Device time in millis
    public let context: DeviceReportContext? // Measured values
    public let createdAt: Date? // Date when report record was stored on the server
    
    public init(_ model: DeviceReportDBModel) throws {
        id = model.id
        deviceId = model.deviceID
        millis = model.millis
        context = DeviceReportContext(model)
        createdAt = model.createdAt
    }
    
    public var description: String {
        return """
            <DeviceReport id: \(String(describing: id)), deviceId: \(String(describing: deviceId)), \
            millis: \(String(describing: millis)), createdAt: \(String(describing: createdAt)), \
            context: \(String(describing: context)) >
            """
    }
}
