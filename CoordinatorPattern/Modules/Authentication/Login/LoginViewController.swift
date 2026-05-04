//
//  ViewController.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//

import UIKit
import SwiftUI
import SnapKit
import Combine

final class LoginViewController: BaseViewController<LoginViewModel> {
    
    //MARK: - UI Properties
    private let stackView = UIStackView()
    
    private let logoImageView = UIImageView()
    private let welcomeMessageLabel = UILabel()
    
    private let authMethodSegmentedControl = UISegmentedControl()
    private let validatedLoginField = ValidatedInputField()
    private let validatedPasswordField = ValidatedInputField(fieldType: .password)
    private let libertyButton = LibertyButton()
    
    private let registerButton = AttributedActionButton(
        prompt: "Don't have an account? ",
        actionText: "Register"
    )
    
    //MARK: - Overriden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureConstraints()
        bindViewModel()
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = AppLayout.Spacing.medium
        stackView.addArrangedSubviews([
            logoImageView,
            welcomeMessageLabel,
            validatedLoginField,
            validatedPasswordField,
            libertyButton,
            registerButton
        ])
        
        logoImageView.image = UIImage(named: Theme.Image.logo.imageName)
        logoImageView.contentMode = .scaleAspectFit
        
        welcomeMessageLabel.text = "Good Afternoon!"
        welcomeMessageLabel.font = Theme.Font.title
        
        libertyButton.title = "Log In"
        libertyButton.addTarget(self, action: #selector(libertyButtonTapped), for: .touchUpInside)
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Constraints Configuration
    private func configureConstraints() {
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(AppLayout.topScreenOffset).priority(.low)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(AppLayout.horizontalInset)
        }
        
        view.keyboardLayoutGuide.topAnchor.constraint(
            greaterThanOrEqualToSystemSpacingBelow: stackView.bottomAnchor,
            multiplier: 1.0).isActive = true
    }
    
}

//MARK: - VM Binding
private extension LoginViewController {
    
    func bindViewModel() {
        bindState()
        bindUIContent()
        bindInputs()
    }
    
    func bindState() {
        viewModel.$isButtonEnabled
            .sink { [weak self] isEnabled in
                self?.libertyButton.isEnabled = isEnabled
            }
            .store(in: &cancellables)
        
        viewModel.$selectedAuthMethod
            .sink { [weak self] authMethod in
                self?.validatedLoginField.setFieldType(authMethod.fieldInputType)
            }
            .store(in: &cancellables)
    }
    
    func bindUIContent() {
        Publishers.CombineLatest(viewModel.$loginValidationResult, viewModel.$passwordValidationResult)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loginVal, passwordVal in
                self?.validatedLoginField.updateFieldState(
                    for: loginVal.state,
                    errorMessage: loginVal.error?.message
                )
                
                self?.validatedPasswordField.updateFieldState(
                    for: passwordVal.state,
                    errorMessage: passwordVal.error?.message
                )
            }
            .store(in: &cancellables)
    }
    
    func bindInputs() {
        bindText(from: validatedLoginField, to: \.loginInput)
        bindText(from: validatedPasswordField, to: \.passwordInput)
    }
    
}

//MARK: - Button Actions
private extension LoginViewController {
    @objc func registerButtonTapped() {
        viewModel.registerTapped()
    }
    
    @objc func libertyButtonTapped() {
        dismissKeyboard()
        viewModel.continueButtonTapped()
    }
}

struct LoginViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            LoginViewController(viewModel: LoginViewModel(authManager: MockAuthenticationManager()))
        }
    }
}


