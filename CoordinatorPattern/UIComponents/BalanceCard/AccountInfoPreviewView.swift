//
//  BankInfoView.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/5/26.
//

import UIKit
import SnapKit

final class AccountInfoPreviewView: UIView {
    
    var config: Config? {
        didSet { applyConfig() }
    }
    
    //MARK: - UI Properties
    private let stackView = UIStackView()
    private let icon = BlurIconView(shape: .custom(cornerRadius: 8))
    private let infoTypeLabel = UILabel()
    private let infoDataLabel = UILabel()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configuration
    private func setupView() {
        stackView.addArrangedSubviews([
            icon,
            infoTypeLabel,
            infoDataLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = AppLayout.Spacing.quark
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        
        infoTypeLabel.font = Theme.Font.footnote
        infoDataLabel.font = Theme.Font.headline
    }
    
    private func applyConfig() {
        icon.image = config?.icon
        infoTypeLabel.text = config?.infoType
        infoDataLabel.text = config?.infoData

        infoTypeLabel.textColor = Theme.Color.themeLightGray.color
        infoTypeLabel.font = Theme.Font.headline
    }
    
    private func configureConstraints() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

//MARK: - Config
extension AccountInfoPreviewView {
    struct Config {
        let icon: UIImage?
        let infoType: String
        let infoData: String
        
        static func ibanData(number: String) -> Config {
            Config(
                icon: UIImage(systemName: "creditcard.fill"),
                infoType: "IBAN",
                infoData: number
            )
        }
    }
}
