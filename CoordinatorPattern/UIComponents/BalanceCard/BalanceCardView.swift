//
//  BalanceCardView.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/5/26.
//

import UIKit
import SnapKit

final class BalanceCardView: UIView {

    //MARK: - UI Properties
    private let backgroundImageView = UIImageView()
    private let maskLayer = CAShapeLayer()
    
    private let balanceStackView = UIStackView()
    private let accountNameLabel = AccountNameLabel()
    private let balanceInfoLabel = BalanceInfoLabel()
    private let accountStateView = AccountStateBadgeView()
    
    private let ibanInfoView = AccountInfoPreviewView()
    let detailsButton = UIButton(type: .roundedRect)
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Overriden Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        configureMask()
    }
    
    
    //MARK: - Configuration
    private func configureView() {
        backgroundColor = Theme.Color.surface.color
        layer.cornerRadius = AppStyle.BalanceCard.cardCornerRadius
        configureImage()
        
        accountNameLabel.image = UIImage(systemName: "eurosign.bank.building.fill")
        accountNameLabel.text = "EUR Account"
        
        balanceInfoLabel.balanceString = "12.257,75 EUR"
        
        balanceStackView.axis = .vertical
        balanceStackView.alignment = .leading
        balanceStackView.spacing = AppLayout.Spacing.tiny
        balanceStackView.addArrangedSubviews([
            accountNameLabel,
            balanceInfoLabel,
            accountStateView
        ])
        
        accountStateView.config = .active
        ibanInfoView.config = .ibanData(number: "ES91 2100 0418 4502 0005 1332")
        
        detailsButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        detailsButton.backgroundColor = Theme.Color.themeLightGray.color.withAlphaComponent(0.45)
        detailsButton.layer.cornerRadius = AppStyle.BalanceCard.detailsButtonSize / 2
    }
    
    private func configureImage() {
        backgroundImageView.image = UIImage(resource: .balanceBackground)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.layer.cornerRadius = AppStyle.BalanceCard.cardCornerRadius
        
        backgroundImageView.layer.mask = maskLayer
    }
    
    private func configureMask() {
        let width = backgroundImageView.bounds.width
        let height = backgroundImageView.bounds.height
        
        guard width > 0, height > 0 else { return }
        
        let maskPath = UIBezierPath()
        
        maskPath.move(to: .zero)
        maskPath.addLine(to: CGPoint(x: width, y: 0))
        maskPath.addLine(to: CGPoint(x: width, y: height - 40))
        
        maskPath.addQuadCurve(
            to: CGPoint(x: 0, y: height ),
            controlPoint: CGPoint(x: width / 1.5, y: height + 15)
        )
        
        maskPath.close()
        
        maskLayer.frame = backgroundImageView.bounds
        maskLayer.path = maskPath.cgPath
    }
    
    private func configureConstraints() {
        
        addSubview(backgroundImageView)
        backgroundImageView.addSubview(accountNameLabel)
        backgroundImageView.addSubview(balanceStackView)
        
        addSubview(ibanInfoView)
        addSubview(detailsButton)
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(AppStyle.BalanceCard.backgroudImageHeight)
        }
        
        accountNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(AppStyle.BalanceCard.accountLabelTopOffset)
            make.leading.equalToSuperview().inset(AppLayout.horizontalInset)
        }
        
        balanceStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(AppStyle.BalanceCard.balanceLabelBottomOffset)
            make.leading.equalToSuperview().inset(AppLayout.horizontalInset)
        }
        
        ibanInfoView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(AppLayout.horizontalInset)
            make.top.equalTo(backgroundImageView.snp.bottom).offset(AppStyle.BalanceCard.bottomPartOffset)
        }
        
        detailsButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(AppStyle.BalanceCard.balanceLabelBottomOffset)
            make.trailing.equalToSuperview().inset(AppLayout.horizontalInset)
            make.width.height.equalTo(AppStyle.BalanceCard.detailsButtonSize)
        }

    }
    
}
