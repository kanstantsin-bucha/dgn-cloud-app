import Vapor

func routes(_ app: Application) throws {
    app.get { _ in return "Up and Running!" }
    app.get("firmware", "update", use: FirmwareUpdateController.getFirmwareUpdate)
    app.get("environmentConfig", "update", use: EnvironmentConfigController.getConfigUpdate)
    app.post("deviceReports", use: DeviceReportsController.createDeviceReport)
    app.get("deviceReports", ":id", use: DeviceReportsController.getDeviceReport)
    app.get("deviceReports", "latestWithDevice", ":id", use: DeviceReportsController.getLatestDeviceReport)
}
