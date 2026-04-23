//
//  PasswordValidationProvider.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 8/4/26.
//
import Foundation
import Combine

protocol PasswordValidatable: PasswordValidationProvider {
    var passwordInput: String { get }

    func setupPasswordValidation()
}

protocol PasswordValidationProvider {
    func passwordValidation(
        input: AnyPublisher<String, Never>
    ) -> (AnyPublisher<ValidationResult, Never>)
}

extension PasswordValidationProvider {
    
    func passwordValidation(
        input: AnyPublisher<String, Never>
    ) -> (AnyPublisher<ValidationResult, Never>) {
        
        return input
            .map { text -> ValidationResult in
                guard !text.isEmpty else { return .neutral }
                
                let error = Validator.validatePassword(text)
                return ValidationResult(
                    state: error == nil ? .valid : .invalid,
                    error: error
                )
            }
            .eraseToAnyPublisher()
        
    }
    
}
