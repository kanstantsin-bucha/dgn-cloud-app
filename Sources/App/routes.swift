import Vapor

func routes(_ app: Application) throws {
    app.get { _ in return "Up and Running!" }
    try app.register(collection: UserController())
    try app.register(collection: DeviceController())
    try app.register(collection: DeviceReportsController())
    app.get("firmware", "update", use: FirmwareUpdateController.getFirmwareUpdate)
    app.get("environmentConfig", "update", use: EnvironmentConfigController.getConfigUpdate)
}
