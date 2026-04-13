//
//  PinManager.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 11/4/26.
//

import Foundation
import CryptoKit

enum PinManager {
    private static let pinHashKey = UserDefaultsKeys.pinCodeHash.key
    
    static func savePin(_ digits: [Int]) {
        let hash = hashPin(digits)
        UserDefaults.standard.set(hash, forKey: pinHashKey)
    }
    
    static func validatePin(_ digits: [Int]) -> Bool {
        guard let savedHash = UserDefaults.standard.string(forKey: pinHashKey) else {
            return false
        }
        return hashPin(digits) == savedHash
    }
    
    private static func hashPin(_ digits: [Int]) -> String {
        let pinString = digits.map(String.init).joined()
        let data = Data(pinString.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}
