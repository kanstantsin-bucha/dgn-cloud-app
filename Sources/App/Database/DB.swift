//
//  DB.swift
//  
//
//  Created by Kanstantsin Bucha on 07/01/2023.
//

import Vapor

enum DB {
    static func connectDatabase(_ app: Application) throws {
        var tls = TLSConfiguration.makeClientConfiguration()
        tls.certificateVerification = .none
        
        let hostname: String
        switch app.environment {
        case .production:
            hostname = "host.docker.internal"
            
        default:
            hostname = "127.0.0.1"
        }
            
        app.databases.use(
            .mysql(
                hostname: hostname,
                username: "dg_cloud_user",
                password: "openWorld$3ToOpportunity#2",
                database: "dg_cloud_database",
                tlsConfiguration: tls
            ),
            as: .mysql
        )
        
        app.migrations.add(CreateDeviceReportsTableMigration(), to: .mysql)
        app.migrations.add(CreateUsersTableMigration(), to: .mysql)
        app.migrations.add(CreateDevicesTableMigration(), to: .mysql)
        
        try app.autoMigrate().wait()
    }
}
