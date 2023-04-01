//
//  DeviceReportAPIModel.swift
//  
//
//  Created by Kanstantsin Bucha on 10/08/2022.
//

import Foundation
import Vapor

public struct DeviceReportAPIModel: Content, CustomStringConvertible {
    public let id: UUID? // Id under that report was stored on the server
    public let deviceId: String? // ID of device that we have
    public let data: DeviceReportData? // Measured values
    public let createdAt: Date? // Date when report record was stored on the server
    
    public init(_ model: DeviceReportDBModel) {
        id = model.id
        deviceId = model.deviceID
        data = DeviceReportData(model)
        createdAt = model.createdAt
    }
    
    /// We use it to send response on POST request - to not pass device data back to device
    /// - Parameter modelWithId: A database model that represents the source
    public init(modelWithoutData model: DeviceReportDBModel) {
        id = model.id
        deviceId = model.deviceID
        data = nil
        createdAt = model.createdAt
    }
    
    public var description: String {
        return """
            <DeviceReport id: \(String(describing: id)), deviceId: \(String(describing: deviceId)), \
            createdAt: \(String(describing: createdAt)), \
            data: \(String(describing: data)) >
            """
    }
}

public struct DeviceReportData: Codable {
    public let millis: UInt32? // Device time in millis
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
        millis = model.millis
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
