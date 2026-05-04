//
//  AccountNameLabel.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 5/5/26.
//

import UIKit
import SnapKit

final class AccountNameLabel: UIView {
    
    var text: String? {
        didSet { label.text = text }
    }
    
    var image: UIImage? {
        didSet { imageView.image = image }
    }
    
    //MARK: - UI Properties
    private let stackView = UIStackView()
    
    private let imageView = BlurIconView(
        shape: .custom(cornerRadius: 8)
    )
    private let label = UILabel()
    
    //MARK: - Initializers
    init() {
        super.init(frame: .zero)
        configureView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configuration
    private func configureView() {
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        
        label.textColor = .white
        label.font = Theme.Font.headline
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = AppLayout.Spacing.tiny
        
        stackView.addArrangedSubviews([imageView, label])
    }
    
    private func configureConstraints() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
