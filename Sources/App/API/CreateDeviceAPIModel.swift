import Foundation
import Vapor

public struct CreateDeviceAPIModel: Content {
    public var id: UUID?
    public var name: String
    public var type: String
    public var deviceID: String
}
