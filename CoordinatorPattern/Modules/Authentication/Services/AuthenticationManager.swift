//
//  AuthenticationManager.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 8/4/26.
//

import Foundation

enum AuthIdentifier {
    case phone(String)
    case document(String)
    
    var value: String {
        switch self {
        case .phone(let val), .document(let val): return val
        }
    }
}

enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case alreadyRegistered
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials: return "The credentials provided are incorrect."
        case .alreadyRegistered: return "This account already exists."
        }
    }
}

protocol AuthenticationManagerProtocol {
    func signIn(identifier: AuthIdentifier, password: String) async throws
    func signUp(identifier: AuthIdentifier, password: String) async throws
    func signOut() async throws
}

final class MockAuthenticationManager: AuthenticationManagerProtocol {
    
    func signIn(identifier: AuthIdentifier, password: String) async throws {
        try await simulateNetworkDelay()
        
        let storageKey = generateStorageKey(for: identifier)
        let savedPassword = UserDefaults.standard.string(forKey: storageKey)
        
        guard savedPassword == password else {
            throw AuthError.invalidCredentials
        }
        let token = "mock_jwt_\(UUID().uuidString)"
        createSession(
            token: token,
            identifier: identifier
        )
    }
    
    func signUp(identifier: AuthIdentifier, password: String) async throws {
        try await simulateNetworkDelay()
        let storageKey = generateStorageKey(for: identifier)
        
        guard UserDefaults.standard.string(forKey: storageKey) == nil else {
            throw AuthError.alreadyRegistered
        }
        
        UserDefaults.standard.set(password, forKey: storageKey)
        
        let token = "mock_jwt_\(UUID().uuidString)"
        createSession(
            token: token,
            identifier: identifier
        )
    }
    
    #warning("disable button to prevent it being tappe")
    func signOut() async throws {
        try await simulateNetworkDelay()
        Session.shared.signOut()
    }
    
    //MARK: - Helper methods
    private func createSession(token: String, identifier: AuthIdentifier) {
        UserDefaultsStorage.currentUserIdentifier = identifier.value
        UserDefaultsStorage.token = token
    }
    
    private func generateStorageKey(for identifier: AuthIdentifier) -> String {
        switch identifier {
        case .phone(let value): return "auth_phone_\(value)"
        case .document(let value): return "auth_doc_\(value)"
        }
    }
    
    private func simulateNetworkDelay() async throws {
        try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
    }
}

