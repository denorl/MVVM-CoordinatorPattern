//
//  AuthMethod.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 24/4/26.
//


enum AuthMethod {
    case phone
    case document
    
    var fieldInputType: ValidatedInputField.FieldInputType {
        switch self {
        case .phone: .phone
        case .document: .document
        }
    }
    
    func createIdentifier(from input: String) -> AuthIdentifier {
        switch self {
        case .phone: return .phone(input)
        case .document: return .document(input)
        }
    }
}
