//
//  PinManager.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 11/4/26.
//

import Foundation
import CryptoKit

enum PinManager {
    
    /// Checks if the current user has a PIN set up
    static var isPinSet: Bool {
        return UserDefaultsStorage.pinCodeHash != nil
    }
    
    /// Hashes the digits and saves them to the storage layer
    static func savePin(_ digits: [Int]) {
        let hash = hashPin(digits)
        UserDefaultsStorage.pinCodeHash = hash
    }
    
    /// Validates entered digits against the stored hash
    static func validatePin(_ digits: [Int]) -> Bool {
        guard let savedHash = UserDefaultsStorage.pinCodeHash else {
            return false
        }
        return hashPin(digits) == savedHash
    }
    
    /// Completely removes PIN data for the current user
    static func removePin() {
        UserDefaultsStorage.pinCodeHash = nil
    }
    
    // MARK: - Private Logic
    private static func hashPin(_ digits: [Int]) -> String {
        let pinString = digits.map(String.init).joined()
        let data = Data(pinString.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
    
}
