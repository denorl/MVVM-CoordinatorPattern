//
//  BadgeView.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/5/26.
//

import UIKit
import SnapKit

final class AccountStateBadgeView: UIView {
    
    var config: Config? {
        didSet { applyConfig() }
    }
    
    // MARK: - UI Properties
    private let stackView = UIStackView()
    private let dotView = UIView()
    private let titleLabel = UILabel()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    func applyConfig() {
        titleLabel.text = config?.text
        dotView.backgroundColor = config?.dotColor
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = UIColor.white.withAlphaComponent(0.15)
        layer.cornerRadius = 12
        clipsToBounds = true
        
        // Dot
        dotView.backgroundColor = Theme.Color.themeGreen.color
        dotView.layer.cornerRadius = 4
        
        // Label
        titleLabel.font = Theme.Font.headline
        titleLabel.textColor = .white
        
        // Stack
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = AppLayout.Spacing.quark
        
        stackView.addArrangedSubviews([
            dotView,
            titleLabel
        ])
    }
    
    private func configureConstraints() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        dotView.snp.makeConstraints { make in
            make.width.height.equalTo(8)
        }
    }
    
}

extension AccountStateBadgeView {
    
    enum Config {
        case active
        case inactive
        
        var text: String {
            switch self {
            case .active: "Account is active"
            case .inactive: "Account isn't active"
            }
        }
        
        var dotColor: UIColor {
            switch self {
            case .active: Theme.Color.themeGreen.color
            case .inactive: Theme.Color.themeRed.color
            }
        }
    }
}
