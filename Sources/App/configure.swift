import Vapor

// configures your application
public func configure(_ app: Application) throws {
    app.http.server.configuration.port = 4040
    setupServices()
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
    try routes(app)
    print("The routes are: \(app.routes.all)")
}
