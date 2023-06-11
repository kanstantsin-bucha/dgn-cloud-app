import Fluent
import FluentMySQLDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    service(FileSystem.self).configureWith(app)
    try DB.connectDatabase(app)
    try JWT.attachSigners(app, keyName: "key")

    // Uncomment to serve requests from local network
    switch app.environment {
    case .development:
        app.http.server.configuration.address = .hostname("192.168.0.192", port: 4040)
    default:
        app.http.server.configuration.port = 4040
    }
    
    app.routes.defaultMaxBodySize = "500kb"
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
    try routes(app)
    print("The routes are: \(app.routes.all)")
}
