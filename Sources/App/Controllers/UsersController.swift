//
//  File.swift
//  
//
//  Created by Kanstantsin Bucha on 21/11/2022.
//

import Foundation

import Vapor
import Fluent

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.post(use: create)
        users.group("login") { usr in
            usr.post(use: login)
        }
        let protected = users.grouped(JWTBearerAuthenticator())
        protected.group("me") { usr in
            usr.get(use: me)
        }
    }
    
    func me(req: Request) throws -> EventLoopFuture<MeAPIModel> {
        let user = try req.auth.require(UserDBModel.self)
        let userName = user.userName
        return UserDBModel.query(on: req.db)
            .filter(\.$userName == userName)
            .first()
            .unwrap(or: Abort(.notFound))
            .map { usr in
                return MeAPIModel(id: usr.id!, userName: usr.userName)
            }
    }
    
    func login(req: Request) throws -> EventLoopFuture<String> {
        let userToLogin = try req.content.decode(UserLoginAPIModel.self)
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
