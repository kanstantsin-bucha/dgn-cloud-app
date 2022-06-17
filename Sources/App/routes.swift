import Vapor


//struct Pet: ResponseEncodable {
//    let name: String
//    let age: Int
//
//    func encodeResponse(for request: Request) -> EventLoopFuture<Response> {
//        return EventLoopFuture(eventLoop: , value: <#T##Value#>)
//
//    }
//}
//

struct HelloQuery: Content {
    let currentVersion: String
}



func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("update", "firmware") { req -> String in
        print("Hello raw: \(req.content)")
        let query = try req.query.decode(HelloQuery.self)
        let version = try SemanticVersion(string: query.currentVersion)
        let firmware = try service(FirmwareUpdateController.self)
            .updateFirmware(currentVersion: version)
        return String(data: firmware, encoding: .utf8) ?? "No firmware"
    }.description("provides firmware updates")
}
