//
//  Session.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//

protocol SessionProvider {
    var isAuthorized: Bool { get }
    var hasPinCode: Bool { get }
    var isPinCodeOwnedByCurrentUser: Bool { get }
    var isFullAccessGranted: Bool { get set }
    
    func end()
}

final class Session: SessionProvider {
    
    private let pinManager: PinManagerProtocol
    
    init(pinManager: PinManagerProtocol = PinManager()) {
        self.pinManager = pinManager
        performFirstLaunchCleanup()
    }
    
    private var isUnlocked: Bool = false
    
    var isAuthorized: Bool { UserDefaultsStorage.token != nil }
    
    var hasPinCode: Bool { pinManager.isPinSet }
    
    var isPinCodeOwnedByCurrentUser: Bool {
        guard let userId = UserDefaultsStorage.currentUserIdentifier else { return false }
        let isOwner = pinManager.isPinOwned(by: userId)
        
        if !isOwner && pinManager.isPinSet {
            try? pinManager.removePin()
        }
        
        return isOwner
    }
    
    var isFullAccessGranted: Bool {
        get { isAuthorized && hasPinCode && isUnlocked }
        set { isUnlocked = newValue }
    }
    
    func end() {
        isUnlocked = false
        UserDefaultsStorage.token = nil
        UserDefaultsStorage.currentUserIdentifier = nil
    }
    
    private func performFirstLaunchCleanup() {
        guard UserDefaultsStorage.isFirstAccess else { return }
        try? pinManager.removePin()
        UserDefaultsStorage.isFirstAccess = false
    }
    
}


