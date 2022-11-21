import Vapor

func routes(_ app: Application) throws {
    app.get { _ in return "Up and Running!" }
    app.get("firmware", "update", use: FirmwareUpdateController.getFirmwareUpdate)
    app.get("environmentConfig", "update", use: EnvironmentConfigController.getConfigUpdate)
    app.post("deviceReports", use: DeviceReportsController.createDeviceReport)
    app.get("deviceReports", ":id", use: DeviceReportsController.getDeviceReport)
    app.get("deviceReports", "latestWithDevice", ":id", use: DeviceReportsController.getLatestDeviceReport)
    app.get("deviceReports", "interval", ":id", use: DeviceReportsController.getIntervalReports)
    
    // MARK: - USERS
    app.post("users", use: UsersController.createUser)
    
//    let userAuthGroup = app.grouped(UserAuthenticator())
//    userAuthGroup.post("users", ":id", "logIn", use: UsersController.logInUser)
//
//
//    let userGuardeGroup = app.grouped(User.guardMiddleware())
//    userGuardeGroup.get("users", ":id", use: UsersController.getUser)
//    userGuardeGroup.patch("users", ":id", "addDevice", use: UsersController.addDevice)
//    userGuardeGroup.patch("users", ":id", "removeDevice", use: UsersController.removeDevice)
//    userGuardeGroup.delete("users", use: UsersController.deleteUser)
}
