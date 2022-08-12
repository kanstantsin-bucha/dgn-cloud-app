import Vapor

func routes(_ app: Application) throws {
    app.get { _ in return "Up and Running!" }
    app.get("firmware", "update", use: FirmwareUpdateController.getFirmwareUpdate)
    app.get("deviceReports", "create", use: DeviceReportsController.createDeviceReport)
    app.get("deviceReports", ":id", use: DeviceReportsController.getDeviceReport)
    app.get("deviceReports", "latestWithDevice", ":id", use: DeviceReportsController.getLatestDeviceReport)
}
