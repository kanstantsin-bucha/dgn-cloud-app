import Foundation
import Vapor

struct MeAPIModel: Content {
    var id: UUID
    var userName: String
    var devicesAliases: [DeviceAliasAPIModel]
}
