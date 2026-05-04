//
//  BalanceInfoLabel.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 5/5/26.
//

import UIKit
import SnapKit

final class BalanceInfoLabel: UIView {
    
    var balanceString: String = "" {
        didSet {
            balanceLabel.setBalanceText(
                balanceString,
                largeFont: Theme.Font.largeTitle,
                smallFont: Theme.Font.headline
            )
        }
    }
    
    //MARK: - UI Properties
    private let stackView = UIStackView()
    private let infoLabel = UILabel()
    private let balanceLabel = UILabel()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configuration
    private func configureView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.addArrangedSubviews([
            infoLabel,
            balanceLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = AppLayout.Spacing.quark
        
        infoLabel.text = "Available Balance"
        infoLabel.textColor = .white
        infoLabel.font = Theme.Font.body
        
        balanceLabel.textColor = .white
    }
    
}
