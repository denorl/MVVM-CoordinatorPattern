//
//  RegistrationViewController.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 20/4/26.
//

import UIKit
import SnapKit
import Combine

final class RegistrationViewController: BaseViewController<RegistrationViewModel> {
    
    //MARK: - UI Properties
    private let backButton = UIButton()
    private lazy var stackView = UIStackView()
    private let instructionLabel = UILabel()
    private let validatedInputField = ValidatedInputField()
    private let libertyButton = LibertyButton()

    //MARK: - Overriden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureConstraints()
        bindViewModel()
    }

    //MARK: - SetupUI
    private func setupUI() {        
        configureNavBar()
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = AppLayout.Spacing.medium
        stackView.addArrangedSubviews([
            instructionLabel,
            validatedInputField,
            libertyButton
        ])
        
        instructionLabel.font = Theme.Font.title2
        
        libertyButton.title = "Continue"
        libertyButton.addTarget(self, action: #selector(libertyButtonTapped), for: .touchUpInside)
    }
    
    private func configureNavBar() {
        navigationItem.title = "Registration"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    private func configureConstraints() {
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(AppLayout.safeAreaTopOffset)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(AppLayout.horizontalInset)
        }
        
        view.keyboardLayoutGuide.topAnchor.constraint(
            greaterThanOrEqualToSystemSpacingBelow: stackView.bottomAnchor,
            multiplier: 1.0).isActive = true
    }
    
}

// MARK: - VM Binding
private extension RegistrationViewController {
    
    func bindViewModel() {
        bindNavigationAndState()
        bindUIContent()
        bindInputs()
    }
    
    func bindNavigationAndState() {
        viewModel.$route
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] route in
                self?.animateTransition(for: route)
            }
            .store(in: &cancellables)
            
        viewModel.$isButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.libertyButton.isEnabled = isEnabled
            }
            .store(in: &cancellables)
    }
    
    func bindUIContent() {
        viewModel.inputFieldTypePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.validatedInputField.setFieldType(state.inputType)
                self?.instructionLabel.text = state.instruction
            }
            .store(in: &cancellables)
            
        viewModel.validationStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] validation in
                self?.validatedInputField.updateFieldState(
                    for: validation.state,
                    errorMessage: validation.error?.message
                )
            }
            .store(in: &cancellables)
    }
    
    func bindInputs() {
        bindText(from: validatedInputField, to: \.loginInput) { [weak self] in
            self?.viewModel.route == .registrationLogin
        }
        
        bindText(from: validatedInputField, to: \.passwordInput) { [weak self] in
            self?.viewModel.route == .registrationPassword
        }
    }
    
}

// MARK: - Navigation Logic
private extension RegistrationViewController {
    func animateTransition(for route: Route.Authentication.Registration) {
        validatedInputField.text = nil
        let direction: UIView.TransitionDirection = (route == .registrationLogin) ? .backward : .forward
        
        switch route {
        case .registrationLogin:
            validatedInputField.text = viewModel.loginInput
        default: break
        }
        
        stackView.slideTransition(direction: direction)
    }
}

//MARK: - Button Actions
private extension RegistrationViewController {
    @objc func backButtonTapped() {
        viewModel.backButtonTapped()
    }
    
    @objc func libertyButtonTapped() {
        viewModel.libertyButtonTapped()
    }
}
