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
    var passwordError: String? { get }

    func setupPasswordValidation()
}

protocol PasswordValidationProvider {
    func passwordValidation(
        input: AnyPublisher<String, Never>
    ) -> (error: AnyPublisher<String?, Never>, state: AnyPublisher<AuthTextField.ValidationState, Never>)
}

extension PasswordValidationProvider {
    func passwordValidation(
        input: AnyPublisher<String, Never>
    ) -> (error: AnyPublisher<String?, Never>, state: AnyPublisher<AuthTextField.ValidationState, Never>) {
        
        let validation = input
            .map { Validator.validatePassword($0) }
            .share()

        let errorPublisher = validation
            .dropFirst()
            .combineLatest(input)
            .map { error, text in
                text.isEmpty ? nil : error?.message
            }
            .eraseToAnyPublisher()

        let statePublisher = Publishers.CombineLatest(validation, input)
            .map { error, text -> AuthTextField.ValidationState in
                if text.isEmpty { return .neutral }
                return (error == nil) ? .valid : .invalid
            }
            .eraseToAnyPublisher()

        return (errorPublisher, statePublisher)
    }
}
