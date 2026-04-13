//
//  RegistrationPasswordViewController.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 10/4/26.
//

import UIKit
import SnapKit
import Combine

final class RegistrationPasswordViewController: AuthenticationViewController<RegistrationPasswordViewModel> {
    
    //MARK: - UI Properties
    private let instructionLabel = UILabel()
    private let validatedPasswordField = ValidatedInputField(fieldType: .password)

    //MARK: - Overriden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureConstraints()
        
        bindViewModel()
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.addArrangedSubviews([
            instructionLabel,
            validatedPasswordField
        ])
        
        instructionLabel.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    //MARK: - Constraints Configuration
    private func configureConstraints() {
        view.addSubview(stackView)
        view.addSubview(continueButton)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        
        validatedPasswordField.configureFieldHeight(relativeTo: view)
        
        continueButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(view.snp.height).multipliedBy(0.065)
            self.keyboardAdaptiveConstraint = make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-20).priority(.medium).constraint
        }
    }

}

//MARK: - VM Binding
private extension RegistrationPasswordViewController {
    func bindViewModel() {
        viewModel.$instructionText
            .sink { [weak self] instrutionText in
                self?.instructionLabel.text = instrutionText
            }
            .store(in: &cancellables)

        
        bindText(from: validatedPasswordField, to: \.passwordInput)
        
        bindInputField(
            validatedPasswordField,
            toBorderState: viewModel.$passwordFieldBorderState,
            toError: viewModel.$passwordError)
    }
}
