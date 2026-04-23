//
//  AuthenticationManager.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 8/4/26.
//

import Foundation

protocol AuthenticationManagerProtocol {
    func signIn(identifier: AuthIdentifier, password: String) async throws
    func checkIfAlreadyRegistered(with identifier: AuthIdentifier) async throws
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
    
    func checkIfAlreadyRegistered(with identifier: AuthIdentifier) async throws {
        let storageKey = generateStorageKey(for: identifier)
        guard UserDefaults.standard.string(forKey: storageKey) == nil else {
            throw AuthError.alreadyRegistered
        }
    }
    
    func signUp(identifier: AuthIdentifier, password: String) async throws {
        try await simulateNetworkDelay()
        let storageKey = generateStorageKey(for: identifier)
        
        UserDefaults.standard.set(password, forKey: storageKey)
        
        let token = "mock_jwt_\(UUID().uuidString)"
        createSession(
            token: token,
            identifier: identifier
        )
    }
    
    func signOut() async throws {
        try await simulateNetworkDelay()
    }
    
    //MARK: - Helper methods
    private func createSession(token: String, identifier: AuthIdentifier) {
        UserDefaultsStorage.currentUserIdentifier = identifier.value
        UserDefaultsStorage.token = token
        print("Session created with \(token) and \(identifier)")
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

