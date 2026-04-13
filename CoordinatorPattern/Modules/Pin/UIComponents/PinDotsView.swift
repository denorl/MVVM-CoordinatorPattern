//
//  PinDotsView.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 11/4/26.
//

import UIKit
import SnapKit

final class PinDotsView: UIView {
    
    //MARK: - Constants
    private let dotCount = 6
    private let dotSize: CGFloat = 14
    private let dotSpacing: CGFloat = 16
    
    //MARK: - UI Properties
    private let stackView = UIStackView()
    private var dots: [UIView] = []
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    func updateFilled(count: Int) {
        for (index, dot) in dots.enumerated() {
            dot.backgroundColor = index < count ?
                AppColor.themeBlue.color :
                AppColor.lightGray.color
        }
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.4
        animation.values = [-10, 10, -8, 8, -5, 5, -2, 2, 0]
        layer.add(animation, forKey: "shake")
    }
    
}

//MARK: - SetupUI
private extension PinDotsView {
    func setupUI() {
        stackView.axis = .horizontal
        stackView.spacing = dotSpacing
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        for _ in 0..<dotCount {
            let dot = makeDot()
            dots.append(dot)
            stackView.addArrangedSubview(dot)
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func makeDot() -> UIView {
        let dot = UIView()
        dot.backgroundColor = AppColor.lightGray.color
        dot.layer.cornerRadius = dotSize / 2
        dot.snp.makeConstraints { make in
            make.width.height.equalTo(dotSize)
        }
        return dot
    }
}
