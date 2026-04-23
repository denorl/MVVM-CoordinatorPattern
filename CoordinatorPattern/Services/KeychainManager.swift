//
//  KeychainManager.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 25/4/26.
//

import Foundation

enum KeychainKey: String {
    case userPinHash = "com.liberty.app.userPinHash"
    case pinOwnerId = "com.liberty.app.pinOwnerId"
}

enum KeychainError: Error {
    case itemNotFound
    case unhandledError(status: OSStatus)
    case invalidData
    case accessDenied
}

protocol KeychainProvider {
    func save(_ value: String, for key: KeychainKey) throws
    func load(for key: KeychainKey) throws -> String
    func delete(for key: KeychainKey) throws
}

final class KeychainManager: KeychainProvider {
    
    static let shared = KeychainManager()
    private let service = Bundle.main.bundleIdentifier ?? "com.denisorlov.CoordinatorPattern"
    
    private init() {}
    
    func save(_ value: String, for key: KeychainKey) throws {
        let data = Data(value.utf8)
        let query: [String : Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        print(status)
        if status == errSecDuplicateItem {
              let updateQuery: [String: Any] = [kSecValueData as String: data]
              let deleteQuery: [String: Any] = [
                  kSecClass as String: kSecClassGenericPassword,
                  kSecAttrService as String: service,
                  kSecAttrAccount as String: key.rawValue
              ]
              let updateStatus = SecItemUpdate(deleteQuery as CFDictionary, updateQuery as CFDictionary)
              if updateStatus != errSecSuccess { throw KeychainError.unhandledError(status: updateStatus) }
          } else if status != errSecSuccess {
              throw KeychainError.unhandledError(status: status)
          }
    }
    
    func load(for key: KeychainKey) throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        switch status {
        case errSecSuccess:
            guard let data = dataTypeRef as? Data, let result = String(data: data, encoding: .utf8) else {
                throw KeychainError.invalidData
            }
            return result
        case errSecItemNotFound:
            throw KeychainError.itemNotFound
        case errSecInteractionNotAllowed:
            throw KeychainError.accessDenied
        default:
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    func delete(for key: KeychainKey) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
}
