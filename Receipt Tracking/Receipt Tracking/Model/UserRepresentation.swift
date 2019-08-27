//
//  UserRepresentation.swift
//  Receipt Tracking
//
//  Created by Jake Connerly on 8/26/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation

struct UserResult: Codable {
    var token: String
}

struct UserRepresentation: Codable {
    var username: String?
    var password: String?
    var email: String?
    var identifier: Int?
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
        case email
        case identifier = "id"
    }
}

extension UserRepresentation: Equatable {
    static func == (lhs: UserRepresentation, rhs: User) -> Bool {
        return lhs.identifier == Int(rhs.identifier)
    }
    
    static func == (lhs: User, rhs: UserRepresentation) -> Bool {
        return rhs == lhs
    }
    
    static func != (lhs: User, rhs: UserRepresentation) -> Bool {
        return rhs != lhs
    }
    
    static func != (lhs: UserRepresentation, rhs: User) -> Bool {
        return !(rhs == lhs)
    }
}

