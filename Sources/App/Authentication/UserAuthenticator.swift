//
//  UserAuthenticator.swift
//  
//
//  Created by Kanstantsin Bucha on 21/11/2022.
//

import Foundation
import Vapor

struct UserAuthenticator: AsyncBasicAuthenticator {
    typealias User = UserAPIModel

    func authenticate(
        basic: BasicAuthorization,
        for request: Request
    ) async throws {
        guard let id = (request.parameters.get("id").flatMap { UUID($0) }) else {
            log.event("authenticate User: Invalid parameter id: \(String(describing: request.parameters.get("id")))")
            throw Abort(.badRequest, reason: "Invalid parameter `id`")
        }
        log.event("authenticate User with \(id)")
        
        let model = UserDBModel
           .find(id, on: request.db)
           .unwrap(or: Abort(.notFound))
           .flatMapThrowing { try UserAPIModel($0) }
        
        if basic.username == "test" && basic.password == "secret" {
            request.auth.login(
                UserAPIModel(
                    id: id,
                    updatedAt: nil,
                    data: UserAccountData()
                )
            )
        }
    }
}
