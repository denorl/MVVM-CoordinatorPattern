//
//  AuthTextFieldInputType.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 7/4/26.
//
import UIKit

enum AuthTextFieldInputType {
    case email
    case password
    case phone
    case document
    
    var isSecure: Bool {
        return self == .password
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .email: return .emailAddress
        case .password: return .default
        case .phone: return .phonePad
        case .document: return .numberPad
        }
    }
    
    var placeholder: String {
        switch self {
        case .email: "Enter your email"
        case .password: "Enter your password"
        case .phone: "+1 (555) 000-0000"
        case .document: "Enter your ID number"
        }
    }
}
