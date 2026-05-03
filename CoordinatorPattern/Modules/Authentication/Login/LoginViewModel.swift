//
//  AuthenticationViewModel.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 6/4/26.
//
import Foundation
import Combine

final class LoginViewModel: CoordinatableViewModel {
    
    private let authManager: AuthenticationManagerProtocol
    
    //MARK: - Finish Login Flow publisher
    private let finishLoginSubject = PassthroughSubject<Void, Never>()
    var onFinish: AnyPublisher<Void, Never> {
        finishLoginSubject.eraseToAnyPublisher()
    }
    
    //MARK: - Other Publishers
    private let showRegistrationSubject = PassthroughSubject<Void, Never>()
    var showRegistration: AnyPublisher<Void, Never> {
        showRegistrationSubject.eraseToAnyPublisher()
    }
    
    private let showEnterPinSubject = PassthroughSubject<Void, Never>()
    var showEnterPin: AnyPublisher<Void, Never> {
        showEnterPinSubject.eraseToAnyPublisher()
    }
    
    private let onErrorSubject = PassthroughSubject<(String, String), Never>()
    var onErrorPublisher: AnyPublisher<(String, String), Never> {
        onErrorSubject.eraseToAnyPublisher()
    }
    
    //MARK: - Published Properties
    @Published var selectedAuthMethod: AuthMethod = .document
    
    @Published private(set) var loginValidationResult: ValidationResult = .neutral
    @Published private(set) var passwordValidationResult: ValidationResult = .neutral
    
    @Published var isButtonEnabled: Bool = false
    
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
    func continueButtonTapped() {
        Task {
            do {
                let identifier = selectedAuthMethod.createIdentifier(from: loginInput)
                try await authManager.signIn(
                    identifier: identifier,
                    password: passwordInput
                )
                finishLoginSubject.send()
            } catch let error as AuthError {
                onErrorSubject.send((error.errorTitle,error.errorDescription))
            }
        }
    }
    
    func registerTapped() {
        showRegistrationSubject.send()
    }
    
}

//MARK: - Login & Password Validation
extension LoginViewModel: LoginValidatable, PasswordValidatable {
    
    func setupLoginValidation() {
        let loginValidationResult = loginValidation(
            input: $loginInput.eraseToAnyPublisher(),
            method: $selectedAuthMethod.eraseToAnyPublisher()
        )
        
        loginValidationResult.assign(to: &$loginValidationResult)
    }
    
    func setupPasswordValidation() {
        let passwordValidationResult = passwordValidation(
            input: $passwordInput.eraseToAnyPublisher()
        )
        
        passwordValidationResult.assign(to: &$passwordValidationResult)
    }
    
}

//MARK: - Button State Configuration
private extension LoginViewModel {
    func bindContinueButtonState() {
        Publishers.CombineLatest($loginValidationResult, $passwordValidationResult)
            .map { loginVal, passwordVal in
                return loginVal.state == .valid && passwordVal.state == .valid
            }
            .assign(to: &$isButtonEnabled)
    }
}
