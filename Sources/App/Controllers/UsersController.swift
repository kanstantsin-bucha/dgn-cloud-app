//
//  File.swift
//  
//
//  Created by Kanstantsin Bucha on 21/11/2022.
//

import Foundation

import Vapor
import Fluent

final class UserLogin: Content {
    var userName: String
    var password: String
}

struct Me: Content {
    var id: UUID
    var userName: String
}

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.group("login") { usr in
            usr.post(use: login)
        }
        
        users
            .grouped(JWTBearerAuthenticator())
            .group("me") { usr in
                usr.get(use: me)
            }
        users.group("create") { usr in
            usr.post(use: create)
        }
    }
     
    func me(req: Request) throws -> EventLoopFuture<Me> {
        let user = try req.auth.require(UserDBModel.self)
        let userName = user.userName
        return UserDBModel.query(on: req.db)
            .filter(\.$userName == userName)
            .first()
            .unwrap(or: Abort(.notFound))
            .map { usr in
                return Me(id: usr.id!, userName: usr.userName)
            }
    }
    
    func login(req: Request) throws -> EventLoopFuture<String> {
        let userToLogin = try req.content.decode(UserLogin.self)
        return UserDBModel.query(on: req.db)
            .filter(\.$userName == userToLogin.userName)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { dbUser in
                let verified = try dbUser.verify(password: userToLogin.password)
                if verified == false {
                    throw Abort(.unauthorized)
                }
                req.auth.login(dbUser)
                let user = try req.auth.require(UserDBModel.self)
                return try user.generateToken(req.application)
            }
    }
    
    func get(req: Request) throws -> EventLoopFuture<UserDBModel> {
        print ("entered users get")
        return UserDBModel.query(on: req.db)
            .filter(\.$userName == req.parameters.get ("userName") ?? "NA")
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    func create(req: Request) throws -> EventLoopFuture<UserAPIModel> {
        let user = try req.content.decode(UserAPIModel.self)
        let model = try UserDBModel(user)
        return model
            .create(on: req.db)
            .flatMapThrowing {
                return UserAPIModel(model)
            }
    }
}
//public struct UsersController {
    
//    public static func createUser(req: Request) async throws -> UserAPIModel {
//        let apiModel = try req.content.decode(UserAPIModel.self)
//        let dbModel = UserDBModel(apiModel)
//        try await dbModel.create(on: req.db)
//        return UserAPIModel(dbModel)
//    }
//
//    public static func getUser(req: Request) async throws -> UserAPIModel {
////        let report = try req.content.decode(DeviceReportAPIModel.self)
////        log.event("createDeviceReport: \(report)")
////        let model = try UserDBModel(report)
////        return model
////            .create(on: req.db)
////            .flatMapThrowing { try DeviceReportAPIModel(modelWithoutData: model) }
//        UserAPIModel(id: UUID(), updatedAt: Date(), data: UserAccountData())
//    }
//}
