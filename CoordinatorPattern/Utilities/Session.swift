//
//  Session.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//

enum Session {
    static var isAuthorized: Bool {
        return UserDefaultsStorage.token != nil
    }
    
    static var isFirstAccess: Bool {
        return UserDefaultsStorage.isFirstAccess
    }
    
    static var hasPinCode: Bool {
        UserDefaultsStorage.pinCodeHash != nil
    }
    
    static var isPinValidated: Bool = false
    
    static var needsPinEntry: Bool {
        return isAuthorized && hasPinCode && !isPinValidated
    }
}


