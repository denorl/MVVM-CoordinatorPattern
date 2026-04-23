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
    
    // MARK: - Public Properties
    var textPublisher: AnyPublisher<String, Never> {
        return textField.textPublisher
    }
    
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    // MARK: - UI Properties
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [textField, errorLabel])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 5
        return stack
    }()
    
    private let textField = PaddedTextField()
    private let errorLabel = UILabel()
    
    private let animationKeyPath = "borderColor"
    
    // MARK: - Initializers
    init(fieldType: FieldInputType = .document) {
        super.init(frame: .zero)
        configureView()
        configureConstraints()
        setFieldType(fieldType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overriden Methods
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    override var isFirstResponder: Bool {
        return textField.isFirstResponder
    }
    
    // MARK: - Public API
    func setFieldType(_ inputType: FieldInputType) {
        textField.keyboardType = inputType.keyboardType
        textField.placeholder = inputType.placeholder
        textField.isSecureTextEntry = inputType.isSecure
        
        if textField.isFirstResponder {
            textField.reloadInputViews()
        }
    }
    
    func updateFieldState(for validationState: ValidationState, errorMessage: String? = nil) {
        textField.layer.borderWidth = (validationState == .neutral) ? 0 : 1.5
        
        switch validationState {
        case .neutral:
            textField.layer.borderColor = UIColor.clear.cgColor
        case .valid:
            textField.layer.borderColor = Theme.Color.themeGreen.cgColor
        case .invalid:
            textField.layer.borderColor = Theme.Color.themeRed.cgColor
        }
        
        let animation = CABasicAnimation(keyPath: animationKeyPath)
        animation.duration = 0.2
        
        textField.layer.add(animation, forKey: animationKeyPath)
        
        errorLabel.text = errorMessage
        UIView.animate(withDuration: 0.25) {
            self.errorLabel.isHidden = (errorMessage == nil)
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Private Configuration
    private func configureView() {
        addSubview(stackView)
        
        textField.layer.cornerRadius = AppStyle.AuthTextField.cornerRadius
        textField.backgroundColor = AppStyle.AuthTextField.backgroundColor
        textField.font = AppStyle.AuthTextField.font
        
        errorLabel.textColor = Theme.Color.themeRed.color
        errorLabel.font = Theme.Font.caption
        errorLabel.isHidden = true
        errorLabel.numberOfLines = 0
    }
    
    private func configureConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.height.equalTo(AppStyle.AuthTextField.height)
        }
    }
}

// MARK: - Private Helper Class

/// A private text field subclass strictly to handle internal text padding.
private final class PaddedTextField: UITextField {
    private let padding = AppStyle.AuthTextField.elementsPadding
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

extension ValidatedInputField {
    
    enum FieldInputType {
        case email
        case password
        case phone
        case document
        
        var isSecure: Bool {
            return self == .password
        }
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .email: return .emailAddress
            case .password: return .default
            case .phone: return .phonePad
            case .document: return .numberPad
            }
        }
        
        var placeholder: String {
            switch self {
            case .email: "Enter your email"
            case .password: "Enter your password"
            case .phone: "+1 (555) 000-0000"
            case .document: "Enter your ID number"
            }
        }
        
    }
    
}
