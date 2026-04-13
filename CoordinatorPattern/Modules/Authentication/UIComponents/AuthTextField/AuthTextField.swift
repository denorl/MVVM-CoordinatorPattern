//
//  AuthTextField.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 7/4/26.
//

import UIKit

final class AuthTextField: UITextField {
    private var textPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    private var fieldType: AuthTextFieldInputType
    
    private let animationKeyPath = "borderColor"
    
    //MARK: - Initializers
    init(fieldType: AuthTextFieldInputType = .document) {
        self.fieldType = fieldType
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Overriden Methods
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    //MARK: - Configuration
    func updateType(to newType: AuthTextFieldInputType) {
        configure()
    }
    
    func updateBorderStyle(for state: AuthTextField.ValidationState) {
        layer.borderWidth = (state == .neutral) ? 0 : 1.5
        
        switch state {
        case .neutral:
            layer.borderColor = UIColor.clear.cgColor
        case .valid:
            layer.borderColor = UIColor.systemGreen.cgColor
        case .invalid:
            layer.borderColor = UIColor.systemRed.cgColor
        }
        
        let animation = CABasicAnimation(keyPath: animationKeyPath)
        animation.duration = 0.2
        layer.add(animation, forKey: animationKeyPath)
    }
    
    private func configure() {
        layer.cornerRadius = 15
        backgroundColor = AppColor.lightGray.color
        keyboardType = fieldType.keyboardType
        font = .systemFont(ofSize: 16)
        tintColor = .blue
        placeholder = fieldType.placeholder        
        isSecureTextEntry = fieldType.isSecure
    }
}

extension AuthTextField {
    enum ValidationState {
        case neutral
        case valid
        case invalid
    }
}
