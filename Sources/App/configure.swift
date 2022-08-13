import Fluent
import FluentMySQLDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    service(FileSystem.self).configureWith(app)
    try database(app)

    app.http.server.configuration.port = 4040
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
            hostname: "localhost",
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
