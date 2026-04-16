//
//  RegistrationPasswordViewModel.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 10/4/26.
//
import Foundation
import Combine

final class RegistrationPasswordViewModel: AuthenticationViewModel {
    
    private let showCreatePinSubject = PassthroughSubject<Void, Never>()
    var showCreatePin: AnyPublisher<Void, Never> {
        showCreatePinSubject.eraseToAnyPublisher()
    }
    
    //MARK: - Dependencies
    private let login: String
    private let authManager: AuthenticationManagerProtocol
    
    //MARK: - Published Properties
    @Published var passwordInput = ""
    @Published private(set) var passwordError: String? = nil
    @Published var passwordFieldBorderState: AuthTextField.ValidationState = .neutral
    
    init(login: String, authManager: AuthenticationManagerProtocol) {
        self.login = login
        self.authManager = authManager
        super.init()
        
        bindContinueButtonState()
        setupPasswordValidation()
    }
    
    //MARK: - Overriden Methods
    override func bindContinueButtonState() {
        Publishers.CombineLatest($passwordError, $passwordInput)
            .map { passwordError, passwordInput in
                return passwordError == nil && !passwordInput.isEmpty
            }
            .assign(to: &$isButtonEnabled)
    }
    
    override func continueButtonTapped() {
        Task {
            do {
                let identifier = selectedAuthMethod.createIdentifier(from: login)
                try await authManager.signUp(identifier: identifier, password: passwordInput)
                onFinishSubject.send()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}

extension RegistrationPasswordViewModel: PasswordValidatable {
    func setupPasswordValidation() {
        let passwordValidation = passwordValidation(input: $passwordInput.eraseToAnyPublisher())
        
        passwordValidation.error.assign(to: &$passwordError)
        passwordValidation.state.assign(to: &$passwordFieldBorderState)
    }
}
