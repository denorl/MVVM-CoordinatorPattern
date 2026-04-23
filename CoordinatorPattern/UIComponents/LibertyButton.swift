//
//  LibBlueButton.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 20/4/26.
//

import UIKit
import SnapKit

final class LibertyButton: UIButton {
    
    // MARK: - Properties
    private var currentConfig: Config = .primary()
    
    var config: Config? {
        get { currentConfig }
        set {
            currentConfig = newValue ?? .primary()
            apply(currentConfig)
        }
    }

    var title: String? {
        get { title(for: .normal) }
        set { setTitle(newValue, for: .normal) }
    }
    
    override var isEnabled: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    // MARK: - Initializers
    init(config: Config = .primary()) {
        self.currentConfig = config
        super.init(frame: .zero)
        setupBaseStyle()
        apply(currentConfig)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupBaseStyle() {
        snp.makeConstraints { make in
            make.height.equalTo(AppStyle.PrimaryButton.height)
        }
    }
    
    private func apply(_ config: Config) {
        layer.cornerRadius = config.cornerRadius
        titleLabel?.font = config.font
        setTitle(config.title, for: .normal)
        setTitleColor(config.titleColor, for: .normal)
        backgroundColor = config.backgroundColor

        updateAppearance()
    }
}

// MARK: - Appearance Logic
private extension LibertyButton {
    func updateAppearance() {
        alpha = isEnabled ? 1 : 0.5
    }
}

// MARK: - Config Definition
extension LibertyButton {
    
    struct Config {
        let title: String
        let font: UIFont
        let titleColor: UIColor
        let backgroundColor: UIColor
        let cornerRadius: CGFloat
        let isLoading: Bool
        
        init(
            title: String = "",
            font: UIFont = Theme.Font.headline,
            titleColor: UIColor = Theme.Color.primaryButtonText().color,
            backgroundColor: UIColor = Theme.Color.themeBlue().color,
            cornerRadius: CGFloat = AppStyle.PrimaryButton.cornerRadius,
            isLoading: Bool = false
        ) {
            self.title = title
            self.font = font
            self.titleColor = titleColor
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.isLoading = isLoading
        }
        
        static func primary(title: String = "") -> Config {
            return Config(title: title)
        }
        
        static func destructive(title: String = "") -> Config {
            return Config(
                title: title,
                backgroundColor: Theme.Color.themeRed.color
            )
        }
    }
    
}
