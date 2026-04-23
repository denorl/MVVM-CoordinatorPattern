//
//  RegistrationViewModel.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 20/4/26.
//

import Foundation
import Combine

final class RegistrationViewModel: CoordinatableViewModel {
    
    private let authManager: AuthenticationManagerProtocol
    
    //MARK: - Finish Registration Flow publisher
    private let finishRegistrationSubject = PassthroughSubject<Void, Never>()
    var onFinish: AnyPublisher<Void, Never> {
        finishRegistrationSubject.eraseToAnyPublisher()
    }
    
    //MARK: - Other Publishers
    private let backToLoginSubject = PassthroughSubject<Void, Never>()
    var backToLoginPubliher: AnyPublisher<Void, Never> {
        backToLoginSubject.eraseToAnyPublisher()
    }
    
    private let onErrorSubject = PassthroughSubject<(String, String), Never>()
    var onErrorPublisher: AnyPublisher<(String, String), Never> {
        onErrorSubject.eraseToAnyPublisher()
    }
    
    //MARK: - Published Properties
    @Published private(set) var route: Route.Authentication.Registration = .registrationLogin
    @Published var selectedAuthMethod: AuthMethod = .document
    
    @Published private(set) var loginValidationResult: ValidationResult = .neutral
    @Published private(set) var passwordValidationResult: ValidationResult = .neutral
    
    @Published private(set) var isButtonEnabled: Bool = false
    
    @Published var loginInput: String = ""
    @Published var passwordInput: String = ""
    
    //MARK: - Initializers
    init(authManager: AuthenticationManagerProtocol) {
        self.authManager = authManager
        setupLoginValidation()
        setupPasswordValidation()
        bindContinueButtonState()
    }
    
    //MARK: - Actions Methods
    func backButtonTapped() {
        switch route {
        case .registrationLogin:
            backToLoginSubject.send()
        case .registrationPassword:
            route = .registrationLogin
            passwordInput = ""
        }
    }
    
    func libertyButtonTapped() {
        switch route {
        case .registrationLogin:
            checkIfAlreadyRegistered()
        case .registrationPassword:
            performRegistration()
        }
    }
    
}

//MARK: - Login & Password Validation
extension RegistrationViewModel: LoginValidatable, PasswordValidatable {
    
    func setupLoginValidation() {
        let loginValidation = loginValidation(
            input: $loginInput.eraseToAnyPublisher(),
            method: $selectedAuthMethod.eraseToAnyPublisher()
        )
        
        loginValidation.assign(to: &$loginValidationResult)
    }
    
    func setupPasswordValidation() {
        let passwordValidation = passwordValidation(
            input: $passwordInput.eraseToAnyPublisher()
        )
        
        passwordValidation.assign(to: &$passwordValidationResult)
    }
}

//MARK: - Validation State handling
extension RegistrationViewModel {
    var validationStatePublisher: AnyPublisher<ValidationResult, Never> {
        Publishers.CombineLatest($route, Publishers.CombineLatest($loginValidationResult, $passwordValidationResult))
            .map { route, results in
                route == .registrationLogin ? results.0 : results.1
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

//MARK: - Input Fields configuration
extension RegistrationViewModel {
    
    struct InputFieldConfig {
        let inputType: ValidatedInputField.FieldInputType
        let instruction: String
    }
    
    var inputFieldTypePublisher: AnyPublisher<InputFieldConfig, Never> {
        Publishers.CombineLatest($route, $selectedAuthMethod)
            .map(mapRouteAndAuthMethodToState)
            .eraseToAnyPublisher()
    }
    
    func mapRouteAndAuthMethodToState(route: Route.Authentication.Registration, authMethod: AuthMethod) -> InputFieldConfig {
        switch route {
        case .registrationLogin:
            
            let type = inputFieldType(for: authMethod)
            let instruction = userInstrucion(for: authMethod)
            return InputFieldConfig(inputType: type, instruction: instruction)
            
        case .registrationPassword:
            return InputFieldConfig(inputType: .password, instruction: "Create your password")
        }
    }
    
    private func inputFieldType(for authMethod: AuthMethod) -> ValidatedInputField.FieldInputType {
        switch authMethod {
        case .phone: .phone
        case .document: .document
        }
    }
    
    private func userInstrucion(for authMethod: AuthMethod) -> String {
        switch authMethod {
        case .phone: "Enter your phone number."
        case .document: "Enter your ID number."
        }
    }
    
}

//MARK: - Button State Configuration
private extension RegistrationViewModel {
    func bindContinueButtonState() {
        Publishers.CombineLatest3($route, $loginValidationResult, $passwordValidationResult)
            .map { route, loginVal, passwordVal in
                switch route {
                case .registrationLogin:    return loginVal.state == .valid
                case .registrationPassword: return passwordVal.state == .valid
                }
            }
            .assign(to: &$isButtonEnabled)
    }
}

//MARK: - Private helpers
private extension RegistrationViewModel {
    func performRegistration() {
        
        Task {
            do {
                try await authManager.signUp(
                    identifier: selectedAuthMethod.createIdentifier(from: loginInput),
                    password: passwordInput
                )
                finishRegistrationSubject.send()
            } catch let error as AuthError {
                onErrorSubject.send((error.errorTitle,error.errorDescription))
            }
        }
        
    }
    
    func checkIfAlreadyRegistered() {
        
        Task {
            do {
                try await authManager.checkIfAlreadyRegistered(
                    with: selectedAuthMethod.createIdentifier(from: loginInput)
                )
                route = .registrationPassword
            } catch let error as AuthError {
                onErrorSubject.send((error.errorTitle, error.errorDescription))
            }
        }
        
    }
}
