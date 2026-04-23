//
//  Validator.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 7/4/26.
//
import Foundation

enum ValidationError: Error {
    case empty
    case invalidPhone
    case invalidDocument
    case invalidPassword
    
    var message: String {
        switch self {
        case .empty: return "This field is required"
        case .invalidPhone: return "Enter a valid 10-digit phone number"
        case .invalidDocument: return "Document ID must be 8-12 characters and only contain numbers"
        case .invalidPassword: return "Password must be at least 8 characters with one number"
        }
    }
}

enum ValidationState {
    case neutral
    case valid
    case invalid
}

struct ValidationResult {
    let state: ValidationState
    let error: ValidationError?
    
    static var neutral: ValidationResult {
        .init(state: .neutral, error: nil)
    }
    
}

enum Validator {
    static func validateLogin(_ text: String, for method: AuthMethod) -> ValidationError? {
        if text.isEmpty { return nil }
        
        switch method {
        case .phone:
            let phoneRegex = "^\\d{10}$"
            let isPhoneValid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: text)
            return isPhoneValid ? nil : .invalidPhone
            
        case .document:
            let isNumeric = text.allSatisfy { $0.isNumber }
            let isLengthValid = text.count >= 8 && text.count <= 12
            let isDocValid = isNumeric && isLengthValid
            return isDocValid ? nil : .invalidDocument
        }
    }

    static func validatePassword(_ text: String) -> ValidationError? {
        if text.isEmpty { return nil }
        let passRegex = "^(?=.*[0-9]).{8,}$"
        let isPassValid = NSPredicate(format: "SELF MATCHES %@", passRegex).evaluate(with: text)
        return isPassValid ? nil : .invalidPassword
    }
}
