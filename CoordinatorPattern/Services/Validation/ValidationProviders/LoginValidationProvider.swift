//
//  LoginValidationProvider.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 8/4/26.
//
import Foundation
import Combine

protocol LoginValidatable: LoginValidationProvider {
    var loginInput: String { get }

    func setupLoginValidation()
}

protocol LoginValidationProvider {
    func loginValidation(
        input: AnyPublisher<String, Never>,
        method: AnyPublisher<AuthMethod, Never>
    ) -> (AnyPublisher<ValidationResult, Never>)
}

extension LoginValidationProvider {
    
    func loginValidation(
        input: AnyPublisher<String, Never>,
        method: AnyPublisher<AuthMethod, Never>
    ) -> AnyPublisher<ValidationResult, Never> {
        
        return Publishers.CombineLatest(input, method)
            .map { text, method -> ValidationResult in
                if text.isEmpty { return .neutral }
                
                let error = Validator.validateLogin(text, for: method)
                return ValidationResult(
                    state: error == nil ? .valid : .invalid,
                    error: error
                )
            }
            .eraseToAnyPublisher()
        
    }
    
}
