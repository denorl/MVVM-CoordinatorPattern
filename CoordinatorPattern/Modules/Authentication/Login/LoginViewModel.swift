//
//  AuthenticationViewModel.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 6/4/26.
//
import Foundation
import Combine

final class LoginViewModel: AuthenticationViewModel {
    
    private let authManager: AuthenticationManagerProtocol
    
    //MARK: - Publishers
    private let showRegistrationSubject = PassthroughSubject<Void, Never>()
    var showRegistration: AnyPublisher<Void, Never> {
        showRegistrationSubject.eraseToAnyPublisher()
    }
    
    private let showEnterPinSubject = PassthroughSubject<Void, Never>()
    var showEnterPin: AnyPublisher<Void, Never> {
        showEnterPinSubject.eraseToAnyPublisher()
    }
    
    //MARK: - Published Properties
    @Published private(set) var loginBorderState: AuthTextField.ValidationState = .neutral
    @Published private(set) var passwordBorderState: AuthTextField.ValidationState = .neutral
    
    @Published var loginInput: String = ""
    @Published var passwordInput: String = ""
    
    @Published private(set) var loginError: String? = nil
    @Published private(set) var passwordError: String? = nil
    
    //MARK: - Initializers
    init(authManager: AuthenticationManagerProtocol) {
        self.authManager = authManager
        super.init()
        bindContinueButtonState()
        setupLoginValidation()
        setupPasswordValidation()
    }
    
    override func bindContinueButtonState() {
        Publishers.CombineLatest3($loginError, $passwordError, $loginInput)
            .map { loginError, passError, loginInput in
                return loginError == nil && passError == nil && !loginInput.isEmpty
            }
            .assign(to: &$isButtonEnabled)
    }
    
    override func continueButtonTapped() {
        Task {
            do {
                let identifier = selectedAuthMethod.createIdentifier(from: loginInput)
                try await authManager.signIn(
                    identifier: identifier,
                    password: passwordInput
                )
                onFinishSubject.send()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func registerTapped() {
        showRegistrationSubject.send()
    }
    
}

//MARK: - LoginValidatable
extension LoginViewModel: LoginValidatable {
    func setupLoginValidation() {
        let loginValidation = loginValidation(
            input: $loginInput.eraseToAnyPublisher(),
            method: $selectedAuthMethod.eraseToAnyPublisher()
        )
        
        loginValidation.error.assign(to: &$loginError)
        loginValidation.state.assign(to: &$loginBorderState)
    }
}

//MARK: - PasswordValidationProvider
extension LoginViewModel: PasswordValidatable {
    func setupPasswordValidation() {
        let passwordValidation = passwordValidation(
            input: $passwordInput.eraseToAnyPublisher()
        )
        
        passwordValidation.error.assign(to: &$passwordError)
        passwordValidation.state.assign(to: &$passwordBorderState)
    }
}
