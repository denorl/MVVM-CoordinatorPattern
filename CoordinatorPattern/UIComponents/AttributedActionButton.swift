//
//  AttributedActionButton.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 11/4/26.
//
import UIKit

final class AttributedActionButton: UIButton {
    
    // MARK: - Initializer
    init(prompt: String, actionText: String) {
        super.init(frame: .zero)
        configureButton(prompt: prompt, actionText: actionText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func configureButton(prompt: String, actionText: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: Theme.Font.body,
            .foregroundColor: Theme.Color.secondaryLabel.color
        ]
        
        let actionAttributes: [NSAttributedString.Key: Any] = [
            .font: Theme.Font.headline,
            .foregroundColor: Theme.Color.themeBlue().color,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let fullString = NSMutableAttributedString(string: prompt, attributes: attributes)
        let actionString = NSAttributedString(string: actionText, attributes: actionAttributes)
        
        fullString.append(actionString)
        
        setAttributedTitle(fullString, for: .normal)
    }
}
