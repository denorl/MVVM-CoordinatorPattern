//
//  RegistrationViewModel.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 6/4/26.
//
import Combine


final class RegistrationLoginViewModel: AuthenticationViewModel {
    
    //MARK: - Finish Flow publishers
    private let showCreatePasswordSubject = PassthroughSubject<String, Never>()
    var showCreatePassword: AnyPublisher<String, Never> {
        showCreatePasswordSubject.eraseToAnyPublisher()
    }
    
    //MARK: - Published Properties
    @Published private(set) var loginFieldBorderState: AuthTextField.ValidationState = .neutral
    
    @Published var loginInput = ""
    
    @Published private(set) var loginError: String? = nil
    
    @Published private(set) var instructionText = ""
    
    override init() {
        super.init()
        bindContinueButtonState()
        setupLoginValidation()
        updateInstructionText()
    }
    
    //MARK: - Overriden Methods
    override func bindContinueButtonState() {
        Publishers.CombineLatest($loginError, $loginInput)
            .map { loginError, loginInput in
                return loginError == nil && !loginInput.isEmpty
            }
            .assign(to: &$isButtonEnabled)
    }
    
    override func continueButtonTapped() {
        showCreatePasswordSubject.send(loginInput)
    }
    
}

//MARK: - LoginValidatable
extension RegistrationLoginViewModel: LoginValidatable {
    func setupLoginValidation() {
        let loginValidation = loginValidation(
            input: $loginInput.eraseToAnyPublisher(),
            method: $selectedAuthMethod.eraseToAnyPublisher()
        )
        
        loginValidation.error.assign(to: &$loginError)
        loginValidation.state.assign(to: &$loginFieldBorderState)
    }
}

//MARK: - Private Methods
private extension RegistrationLoginViewModel {
    func updateInstructionText() {
        $selectedAuthMethod
            .map { authMethod in
                switch authMethod {
                case .document:
                    return "Please enter your ID number."
                case .phone:
                    return "Please enter your phone number."
                }
            }
            .assign(to: &$instructionText)
    }
}


