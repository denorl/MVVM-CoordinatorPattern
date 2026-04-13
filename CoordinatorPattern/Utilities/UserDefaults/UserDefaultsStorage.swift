//
//  UserDefaultsKeys.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 11/4/26.
//

enum UserDefaultsKeys {
    case token
    case isFirstAccess
    case hasPinCode
    case currentUserId
    case pinCodeHash
    
    var key: String {
        switch self {
        case .token: "token"
        case .isFirstAccess: "isFirstAccess"
        case .hasPinCode: "hasPinCode"
        case .currentUserId: "currentUserId"
        case .pinCodeHash: "pinCodeHash"
        }
    }
}

enum UserDefaultsStorage {
    @UserDefault(key: UserDefaultsKeys.token.key, defaultValue: nil)
    static var token: String?
    
    @UserDefault(key: UserDefaultsKeys.isFirstAccess.key, defaultValue: true)
    static var isFirstAccess: Bool
    
    @UserDefault(key: UserDefaultsKeys.hasPinCode.key, defaultValue: false)
    static var hasPinCode: Bool
    
    @UserDefault(key: UserDefaultsKeys.currentUserId.key, defaultValue: nil)
    static var currentUserIdentifier: String?
    
    @UserDefault(key: UserDefaultsKeys.pinCodeHash.key, defaultValue: nil)
    static var pinCodeHash: String?
}
