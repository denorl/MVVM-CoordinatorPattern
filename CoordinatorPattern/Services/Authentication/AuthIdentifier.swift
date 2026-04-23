//
//  AuthIdentifier.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 27/4/26.
//

enum AuthIdentifier {
    case phone(String)
    case document(String)
    
    var value: String {
        switch self {
        case .phone(let val), .document(let val): return val
        }
    }
}
