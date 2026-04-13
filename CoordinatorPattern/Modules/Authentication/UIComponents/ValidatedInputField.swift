//
//  AuthenticationFieldGroupView.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 10/4/26.
//
import UIKit
import SnapKit
import Combine

final class ValidatedInputField: UIView {
    
    var textPublisher: AnyPublisher<String, Never> {
        return textField.textPublisher
    }
    
    //MARK: - UI Properties
    private lazy var stackView = UIStackView(arrangedSubviews: [
        textField,
        errorLabel
    ])
    private let textField: AuthTextField
    private let errorLabel = UILabel()
    
    //MARK: - Initializers
    init(fieldType: AuthTextFieldInputType = .document) {
        self.textField = AuthTextField(fieldType: fieldType)
        super.init(frame: .zero)
        configureView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Methods
    func setFieldType(_ inputType: AuthTextFieldInputType) {
        textField.updateType(to: inputType)
    }
    
    func updateFieldState(
        for validationState: AuthTextField.ValidationState,
        errorMessage: String?
    ) {
        textField.updateBorderStyle(for: validationState)
        errorLabel.text = errorMessage
        UIView.animate(withDuration: 0.25) {
            self.errorLabel.isHidden = (errorMessage == nil)
            self.layoutIfNeeded()
        }
    }
    
    func configureFieldHeight(relativeTo view: UIView) {
        textField.snp.makeConstraints { make in
            make.height.equalTo(view).multipliedBy(0.065)
        }
    }
    
    //MARK: - View Configuration
    private func configureView() {
        configureStackView()
        
        errorLabel.textColor = .red
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
    }
    
    //MARK: - Constraints Configuration
    private func configureConstraints() {
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
