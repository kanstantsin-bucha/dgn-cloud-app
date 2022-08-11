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
    case co
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
    public var deviceID: UUID?

    @Field(key: DeviceReportDBKeys.co.key)
    public var coValue: Float?
    
    @Field(key: DeviceReportDBKeys.createdAt.key)
    public var createdAt: Date?
    
    public var description: String {
        return """
            <DeviceReportDBModel id: \(String(describing: id)), coValue: \(String(describing: coValue))
            createdAt: \(String(describing: createdAt)),
            >
            """
    }

    public init() {
        id = UUID()
        deviceID = UUID(uuidString: "86E0C263-C55B-4511-8163-0D8D322273A3")
        coValue = 12
        createdAt = Date()
    }
}

struct CreateDeviceReportsTableMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        print("prepare CreateDeviceReportsTableMigration started")
        try await database.schema(DeviceReportDBModel.schema)
            .id()
            .field(DeviceReportDBKeys.co.key, .float)
            .field(DeviceReportDBKeys.deviceID.key, .uuid)
            .field(DeviceReportDBKeys.createdAt.key, .datetime)
            .create()
        
        print("prepare CreateDeviceReportsTableMigration finished")
    }
    
    func revert(on database: Database) async throws {
        print("revert CreateDeviceReportsTableMigration")
    }
}
