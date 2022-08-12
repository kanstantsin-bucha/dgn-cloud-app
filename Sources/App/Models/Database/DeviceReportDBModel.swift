//
//  DeviceReport.swift
//  
//
//  Created by Kanstantsin Bucha on 09/08/2022.
//

import Foundation
import Fluent
import Vapor

fileprivate enum DeviceReportDBKeys: String {
    case millis
    case busVoltage
    case coZeroV
    case coV
    case coPpm
    case tempCelsius
    case pressureHPa
    case humidity
    case gasResistance
    case iaq
    case staticIaq
    case co2Equivalent
    case breathVocEquivalent
    case compGasValue
    case gasPercentage
    case deviceID
    case createdAt
    
    var key: FieldKey {
        return .string(self.rawValue)
    }
}

// {"coZeroV":0.392248,"coV":0.393188,"coPpm":0.234865,"tempCelsius":28.61,"pressureHPa":1005.05,"humidity":41.653,"gasResistance":739592,"iaq":86.50568,"staticIaq":51.86747,"co2Equivalent":607.4699,"breathVocEquivalent":0.750507,"compGasValue":0,"gasPercentage":0},"createdAt":1640236388,"_id":"0MLwpEtAKkTSU54f"}]}

public final class DeviceReportDBModel: Model, CustomStringConvertible {
    // Name of the table or collection.
    public static let schema = "device_reports"

    @ID(key: .id)
    public var id: UUID?
    
    @Field(key: DeviceReportDBKeys.deviceID.key)
    public var deviceID: String?
    
    @Field(key: DeviceReportDBKeys.millis.key)
    public var millis: UInt32?
    
    @Field(key: DeviceReportDBKeys.busVoltage.key)
    public var busVoltage: Float?
    
    @Field(key: DeviceReportDBKeys.coZeroV.key)
    public var coZeroV: Float?
    
    @Field(key: DeviceReportDBKeys.coV.key)
    public var coV: Float?
    
    @Field(key: DeviceReportDBKeys.coPpm.key)
    public var coPpm: Float?
    
    @Field(key: DeviceReportDBKeys.tempCelsius.key)
    public var tempCelsius: Float?
    
    @Field(key: DeviceReportDBKeys.pressureHPa.key)
    public var pressureHPa: Float?
    
    @Field(key: DeviceReportDBKeys.humidity.key)
    public var humidity: Float?
    
    @Field(key: DeviceReportDBKeys.gasResistance.key)
    public var gasResistance: Float?
    
    @Field(key: DeviceReportDBKeys.iaq.key)
    public var iaq: Float?
    
    @Field(key: DeviceReportDBKeys.staticIaq.key)
    public var staticIaq: Float?
    
    @Field(key: DeviceReportDBKeys.co2Equivalent.key)
    public var co2Equivalent: Float?
    
    @Field(key: DeviceReportDBKeys.breathVocEquivalent.key)
    public var breathVocEquivalent: Float?
    
    @Field(key: DeviceReportDBKeys.compGasValue.key)
    public var compGasValue: Float?
    
    @Field(key: DeviceReportDBKeys.coZeroV.key)
    public var gasPercentage: Float?
    
    @Field(key: DeviceReportDBKeys.createdAt.key)
    public var createdAt: Date?
    
    public var description: String {
        return """
            <DeviceReportDBModel id: \(String(describing: id)), deviceID: \(String(describing: deviceID)), \
            createdAt: \(String(describing: createdAt)), iaq: \(String(describing: createdAt)), \
            coPpm: \(String(describing: coPpm)),
            >
            """
    }

    public init() {
        #warning(" TODO: implement here")
        id = UUID()
        deviceID = "86E0C263-C55B-4511-8163-0D8D322273A3"
        createdAt = Date()
    }
}

struct CreateDeviceReportsTableMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        print("prepare CreateDeviceReportsTableMigration started")
        try await database.schema(DeviceReportDBModel.schema)
            .id()
            .field(DeviceReportDBKeys.coPpm.key, .float)
            .field(DeviceReportDBKeys.deviceID.key, .string)
            .field(DeviceReportDBKeys.createdAt.key, .datetime)
            .create()
        
        print("prepare CreateDeviceReportsTableMigration finished")
    }
    
    func revert(on database: Database) async throws {
        print("revert CreateDeviceReportsTableMigration")
    }
}
