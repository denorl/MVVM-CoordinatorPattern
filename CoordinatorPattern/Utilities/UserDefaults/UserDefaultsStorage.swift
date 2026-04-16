//
//  UserDefaultsKeys.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 11/4/26.
//

import Foundation

enum UserDefaultsKeys {
    case token, isFirstAccess, hasPinCode, currentUserId
    
    static func pinCodeKey(for userId: String) -> String {
        return "pinCodeHash.\(userId)"
    }
    
    var key: String {
        switch self {
        case .token: return "token"
        case .isFirstAccess: return "isFirstAccess"
        case .hasPinCode: return "hasPinCode"
        case .currentUserId: return "currentUserId"
        }
    }
}
enum UserDefaultsStorage {
    
    @UserDefault(key: UserDefaultsKeys.token.key, defaultValue: nil)
    static var token: String?
    
    @UserDefault(key: UserDefaultsKeys.currentUserId.key, defaultValue: nil)
    static var currentUserIdentifier: String?
    
    static var pinCodeHash: String? {
        get {
            guard let id = currentUserIdentifier else { return nil }
            return UserDefaults.standard.string(forKey: UserDefaultsKeys.pinCodeKey(for: id))
        }
        set {
            guard let id = currentUserIdentifier else { return }
            if let newValue = newValue {
                UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.pinCodeKey(for: id))
            } else {
                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.pinCodeKey(for: id))
            }
        }
    }
    
}
