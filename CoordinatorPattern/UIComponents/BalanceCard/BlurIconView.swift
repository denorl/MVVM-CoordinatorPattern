//
//  BlurIconView.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/5/26.
//

import UIKit
import SnapKit

final class BlurIconView: UIView {
    
    //MARK: - UI Properties
    private let imageView = UIImageView()
    private let shape: Shape
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    //MARK: - Initializers
    init(shape: Shape) {
        self.shape = shape
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Overriden Methods
    override func layoutSubviews() {
        switch shape {
        case .circle:
            layer.cornerRadius = bounds.width / 2
        case .custom(let cornerRadius):
            layer.cornerRadius = cornerRadius
        }
    }
    
    
    private func configureView() {
        backgroundColor = Theme.Color.themeLightGray.color.withAlphaComponent(0.45)
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(8)
            make.bottom.trailing.equalToSuperview().offset(-8)
        }
    }
    
    enum Shape {
        case circle
        case custom(cornerRadius: CGFloat)
    }
}

