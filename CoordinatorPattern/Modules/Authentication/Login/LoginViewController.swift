//
//  ViewController.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//

import UIKit
import SnapKit
import Combine

#warning("не подписывать под базовый класс и вынести отдельно")
final class LoginViewController: AuthenticationViewController<LoginViewModel>, RouteIdentifiable {
    
    var route: Route.Authentication = .login
    
    //MARK: - UI Properties
    private let logoImageView = UIImageView()
    private let welcomeMessageLabel = UILabel()
    
    private let validatedLoginField = ValidatedInputField()
    private let validatedPasswordField = ValidatedInputField(fieldType: .password)
    
    private let registerButton = AttributedActionButton(
        prompt: "Don't have an account? ",
        actionText: "Register")
    
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
        stackView.spacing = 20
        stackView.addArrangedSubviews([
            logoImageView,
            welcomeMessageLabel,
            validatedLoginField,
            validatedPasswordField,
            continueButton,
            registerButton
        ])
        
        logoImageView.image = UIImage(named: ThemeImage.logo.imageName)
        logoImageView.contentMode = .scaleAspectFit
        
        welcomeMessageLabel.text = "Good Afternoon!"
        welcomeMessageLabel.font = .systemFont(ofSize: 30, weight: .bold)
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        continueButton.setTitle("Log In", for: .normal)
    }
    
    //MARK: - Constraints Configuration
    private func configureConstraints() {
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            
            self.keyboardAdaptiveConstraint = make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-20).priority(.medium).constraint
        }
        
        validatedLoginField.configureFieldHeight(relativeTo: view)
        
        validatedPasswordField.configureFieldHeight(relativeTo: view)
        
        continueButton.snp.makeConstraints { make in
            make.height.equalTo(view.snp.height).multipliedBy(0.065)
        }
    }
    
}

//MARK: - VM Binding
private extension LoginViewController {
    func bindViewModel() {
        viewModel.$selectedAuthMethod
            .sink { [weak self] authMethod in
                self?.validatedLoginField.setFieldType(authMethod.fieldInputType)
            }
            .store(in: &cancellables)
        
        bindText(from: validatedLoginField, to: \.loginInput)
        bindText(from: validatedPasswordField, to: \.passwordInput)
        
        bindInputField(
            validatedLoginField,
            toBorderState: viewModel.$loginBorderState,
            toError: viewModel.$loginError
        )
        
        bindInputField(
            validatedPasswordField,
            toBorderState: viewModel.$passwordBorderState,
            toError: viewModel.$passwordError
        )
    }
}

//MARK: - Private Methods
private extension LoginViewController {
    @objc func registerButtonTapped() {
        viewModel.registerTapped()
    }
}
