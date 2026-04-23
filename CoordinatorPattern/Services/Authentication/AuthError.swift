//
//  AuthError.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 27/4/26.
//

import Foundation

enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case alreadyRegistered
    
    var errorTitle: String {
        switch self {
        case .invalidCredentials: "Login failed"
        case .alreadyRegistered: "Registration failed"
        }
    }
    
    var errorDescription: String {
        switch self {
        case .invalidCredentials: "The credentials provided are incorrect. Try again."
        case .alreadyRegistered: "This account already exists."
        }
    }
}
