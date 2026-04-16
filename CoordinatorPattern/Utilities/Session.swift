//
//  Session.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//

protocol SessionProvider {
    var isAuthorized: Bool { get }
    var hasPinCode: Bool { get }
    var isFullAccessGranted: Bool { get }
}

final class Session: SessionProvider {
    
    private init() {}
    
    static let shared = Session()
    
    private var isUnlocked: Bool = false
    
    var isAuthorized: Bool {
        return UserDefaultsStorage.token != nil
    }
    
    var hasPinCode: Bool {
        UserDefaultsStorage.pinCodeHash != nil
    }
    
    var isFullAccessGranted: Bool {
        get {
            return isAuthorized && hasPinCode && isUnlocked
        }
        set {
            isUnlocked = newValue
        }
    }
    
    func signOut() {
        isUnlocked = false
        UserDefaultsStorage.token = nil
        UserDefaultsStorage.currentUserIdentifier = nil
    }
    
}


