//
//  JWT.swift
//  
//
//  Created by Kanstantsin Bucha on 07/01/2023.
//

import Vapor
import JWT

extension JWKIdentifier {
    static let `public` = JWKIdentifier(string: "public")
    static let `private` = JWKIdentifier(string: "private")
}

enum JWT {
    static func attachSigners(_ app: Application, keyName: String) throws {
        let privateFilePath = service(FileSystem.self).filePath(
            fileName: keyName,
            inStorage: .certificates
        )
        let publicPem = try String(contentsOfFile: privateFilePath + ".pub")
        let privatePem = try String(contentsOfFile: privateFilePath)
        let publicSigner = try JWTSigner.rs256(key: .public(pem: publicPem))
        let privateSigner = try JWTSigner.rs256(key: .private(pem: privatePem))
        app.jwt.signers.use(publicSigner, kid: .public, isDefault:  true)
        app.jwt.signers.use(privateSigner, kid: .private)
    }
}

struct MyJwtPayload: Authenticatable, JWTPayload {
    var id: UUID?
    var userName: String
    var exp: ExpirationClaim
    
    func verify (using signer: JWTSigner) throws {
        try self.exp.verifyNotExpired()
    }
}

struct JWTBearerAuthenticator: JWTAuthenticator {
    typealias Payload = MyJwtPayload
    func authenticate (jwt: Payload, for request: Request) -> EventLoopFuture<Void> {
        do {
            try jwt.verify(using: request.application.jwt.signers.get()!)
            return UserDBModel
                .find(jwt.id, on: request.db)
                .unwrap(or: Abort (.notFound))
                .map { user in
                    request.auth.login(user)
                }
        }
        catch {
            return request.eventLoop.makeSucceededFuture(())
        }
    }
}

extension UserDBModel {
    func generateToken (_ app: Application) throws -> String {
        var expDate = Date()
        expDate.addTimeInterval(7 * 24 * 3600)
        let exp = ExpirationClaim(value: expDate)
        return try app.jwt.signers
            .get(kid: .private)!
            .sign(MyJwtPayload(
                id: self.id,
                userName: self.userName,
                exp: exp
            ))
    }
}
