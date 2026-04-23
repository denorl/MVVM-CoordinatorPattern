//
//  UserDefaultsKeys.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 11/4/26.
//

import Foundation

enum UserDefaultsKeys {
    case token, isFirstAccess, currentUserId
    
    var key: String {
        switch self {
        case .token: return "token"
        case .isFirstAccess: return "isFirstAccess"
        case .currentUserId: return "currentUserId"
        }
    }
}

enum UserDefaultsStorage {
    
    @UserDefault(key: UserDefaultsKeys.token.key, defaultValue: nil)
    static var token: String?
    
    @UserDefault(key: UserDefaultsKeys.currentUserId.key, defaultValue: nil)
    static var currentUserIdentifier: String?
    
    @UserDefault(key: UserDefaultsKeys.isFirstAccess.key, defaultValue: true)
    static var isFirstAccess: Bool
    
}
