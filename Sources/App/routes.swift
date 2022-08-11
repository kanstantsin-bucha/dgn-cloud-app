import Vapor

struct UpdateFirmware: Content {
    let currentVersion: String
}

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("update", "firmware") { req -> String in
        print("update firmware raw: \(req.content)")
        let query = try req.query.decode(UpdateFirmware.self)
        let version = try SemanticVersion(string: query.currentVersion)
        let firmware = try service(FirmwareUpdateController.self)
            .updateFirmware(currentVersion: version)
        return String(data: firmware, encoding: .utf8) ?? "No firmware"
    }.description("provides firmware updates")
    
    app.get("deviceReports", "create", use: DeviceReportsController.createDeviceReport)
    app.get("deviceReports", ":id", use: DeviceReportsController.getDeviceReport)
    app.get("deviceReports", "latestWithDevice", ":id", use: DeviceReportsController.getLatestDeviceReport)
}
