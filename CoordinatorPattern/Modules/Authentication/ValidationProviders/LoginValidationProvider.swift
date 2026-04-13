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
    var loginError: String? { get }

    func setupLoginValidation()
}

protocol LoginValidationProvider {
    func loginValidation(
        input: AnyPublisher<String, Never>,
        method: AnyPublisher<AuthMethod, Never>
    ) -> (error: AnyPublisher<String?, Never>, state: AnyPublisher<AuthTextField.ValidationState, Never>)
}

extension LoginValidationProvider {
    func loginValidation(
        input: AnyPublisher<String, Never>,
        method: AnyPublisher<AuthMethod, Never>
    ) -> (error: AnyPublisher<String?, Never>, state: AnyPublisher<AuthTextField.ValidationState, Never>) {
        
        let validation = Publishers.CombineLatest(input, method)
            .map { Validator.validateLogin($0, for: $1) }
            .share()

        let errorPublisher = validation
            .dropFirst()
            .combineLatest(input)
            .map { error, text in text.isEmpty ? nil : error?.message }
            .eraseToAnyPublisher()

        let statePublisher = Publishers.CombineLatest(validation, input)
            .map { error, text -> AuthTextField.ValidationState in
                text.isEmpty ? .neutral : (error == nil ? .valid : .invalid)
            }
            .eraseToAnyPublisher()

        return (errorPublisher, statePublisher)
    }
}
