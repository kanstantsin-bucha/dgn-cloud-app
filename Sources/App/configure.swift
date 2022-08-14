import Fluent
import FluentMySQLDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    service(FileSystem.self).configureWith(app)
    try database(app)

    app.http.server.configuration.port = 4040
    // Uncomment to serve requests from local network
    app.http.server.configuration.address = .hostname("192.168.0.193", port: 4040)
    app.routes.defaultMaxBodySize = "500kb"
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
    try routes(app)
    print("The routes are: \(app.routes.all)")
}

fileprivate func database(_ app: Application) throws {
    var tls = TLSConfiguration.makeClientConfiguration()
    tls.certificateVerification = .none
    app.databases.use(
        .mysql(
            hostname: "127.0.0.1",
            username: "dg_cloud_user",
            password: "openWorld$3ToOpportunity#2",
            database: "dg_cloud_database",
            tlsConfiguration: tls
        ),
        as: .mysql
    )
    
    app.migrations.add(CreateDeviceReportsTableMigration(), to: .mysql)
    
    try app.autoMigrate().wait()
}
