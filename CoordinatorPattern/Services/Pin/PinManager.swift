//
//  PinManager.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 11/4/26.
//

import Foundation
import CryptoKit

enum PinValidationError: Error {
    case incorrectPin
    case notSet
    case hardwareLocked
    case systemError
    
    var errorDescription: String? {
        switch self {
        case .incorrectPin:
            return "The PIN you entered is incorrect. Please try again."
        case .notSet:
            return "No PIN was found for this account. Please sign in to create one."
        case .hardwareLocked:
            return "Secure storage is currently unavailable. Please ensure your device is unlocked."
        case .systemError:
            return "An unexpected error occurred while accessing the security module."
        }
    }
    
}

protocol PinManagerProtocol {
    /// Checks if a PIN currently exists in secure storage
    var isPinSet: Bool { get }
    
    /// Hashes and persists a new PIN
    func savePin(_ digits: [Int], for userId: String) throws
    
    /// Checks if the PIN is owned by current user
    func isPinOwned(by userId: String) -> Bool
    
    /// Validates entered digits against the stored hash
    func validatePin(_ digits: [Int]) throws
    
    /// Wipes PIN data
    func removePin() throws
}

final class PinManager: PinManagerProtocol {
    
    private let storage: KeychainProvider
    
    init(storage: KeychainProvider = KeychainManager.shared) {
        self.storage = storage
    }

    var isPinSet: Bool {
        do {
            _ = try storage.load(for: .userPinHash)
            return true
        } catch {
            return false
        }
    }
    
    func isPinOwned(by userId: String) -> Bool {
        guard let storedOwnerId = try? storage.load(for: .pinOwnerId) else { return false }
        return storedOwnerId == userId
    }
    
    func savePin(_ digits: [Int], for userId: String) throws {
        let hash = hashPin(digits)
        try storage.save(hash, for: .userPinHash)
        try storage.save(userId, for: .pinOwnerId)
    }
    
    func validatePin(_ digits: [Int]) throws {
        do {
            let savedHash = try storage.load(for: .userPinHash)
            if hashPin(digits) != savedHash {
                throw PinValidationError.incorrectPin
            }
        } catch let error as KeychainError {
            try mapKeychainErrorToPinValidationError(error)
        }
    }
    
    func removePin() throws {
        try storage.delete(for: .userPinHash)
        try storage.delete(for: .pinOwnerId)
    }
    
    // MARK: - Private Logic
    private func hashPin(_ digits: [Int]) -> String {
        let pinString = digits.map(String.init).joined()
        let data = Data(pinString.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    private func mapKeychainErrorToPinValidationError(_ error: KeychainError) throws {
        switch error {
        case .itemNotFound:
            print("PinManager: No PIN found in storage.")
            throw PinValidationError.notSet
        case .unhandledError(let status):
            print("Pin Manager: Unexpected Keychain error with status: \(status)")
            throw PinValidationError.systemError
        case .invalidData:
            print("Pin Manager: Keychain responded with invalid data error.")
            throw PinValidationError.systemError
        case .accessDenied:
            print("PinManager: Device is locked, cannot access PIN.")
            throw PinValidationError.hardwareLocked
        }
    }
    
}
