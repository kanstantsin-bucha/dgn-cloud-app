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
        users.post() { try await create(req: $0) }
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
        let deviceAliasIDs = user.deviceAliasIDs ?? []
        return DeviceAliasDBModel.query(on: req.db)
            .filter(\.$id ~~ deviceAliasIDs)
            .all()
            .map { devicesAliasesDB in
                return MeAPIModel(
                    id: user.id!,
                    userName: user.userName,
                    devicesAliases: devicesAliasesDB.map { DeviceAliasAPIModel($0) }
                )
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
    
    func create(req: Request) async throws -> MeAPIModel {
        let createUserAPI = try req.content.decode(CreateUserAPIModel.self)
        let user = try UserDBModel(createUserAPI)
        try await user.create(on: req.db)
        return MeAPIModel(
            id: user.id!,
            userName: user.userName,
            devicesAliases: []
        )
    }
}
