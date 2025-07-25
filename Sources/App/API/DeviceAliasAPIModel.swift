import Foundation
import Vapor

public struct DeviceAliasAPIModel: Content {
    public var id: UUID?
    public var name: String
    public var type: String
    
    init(_ dbModel: DeviceAliasDBModel) {
        id = dbModel.id
        name = dbModel.name
        type = dbModel.type
    }
}
