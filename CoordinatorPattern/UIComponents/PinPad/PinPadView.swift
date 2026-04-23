//
//  PinPadView.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 11/4/26.
//

import UIKit
import Combine
import SnapKit

final class PinPadView: UIView {
    
    //MARK: - Publishers
    private let digitTappedSubject = PassthroughSubject<Int, Never>()
    var digitTapped: AnyPublisher<Int, Never> {
        digitTappedSubject.eraseToAnyPublisher()
    }
    
    private let backspaceTappedSubject = PassthroughSubject<Void, Never>()
    var backspaceTapped: AnyPublisher<Void, Never> {
        backspaceTappedSubject.eraseToAnyPublisher()
    }
    
    //MARK: - UI Properties
    private let mainStackView = UIStackView()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - SetupUI
private extension PinPadView {
    func setupUI() {
        mainStackView.axis = .vertical
        mainStackView.spacing = AppLayout.Spacing.small
        mainStackView.distribution = .equalSpacing
        
        let rows: [[PadItem]] = [
            [.digit(1), .digit(2), .digit(3)],
            [.digit(4), .digit(5), .digit(6)],
            [.digit(7), .digit(8), .digit(9)],
            [.empty,    .digit(0), .backspace]
        ]
        
        for row in rows {
            let rowStack = makeRowStack(items: row)
            mainStackView.addArrangedSubview(rowStack)
        }
        
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func makeRowStack(items: [PadItem]) -> UIStackView {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.spacing = AppLayout.Spacing.medium
        rowStack.distribution = .equalSpacing
        rowStack.alignment = .center
        
        for item in items {
            let button = makeButton(for: item)
            rowStack.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.width.height.equalTo(AppStyle.Pin.pinPadButtonHeight)
            }
        }
        
        return rowStack
    }
    
    func makeButton(for item: PadItem) -> UIView {
        switch item {
        case .digit(let value):
            let button = UIButton(type: .system)
            button.setTitle("\(value)", for: .normal)
            button.titleLabel?.font = Theme.Font.system(size: 28, weight: .medium)
            button.setTitleColor(Theme.Color.label.color, for: .normal)
            button.tag = value
            button.addTarget(self, action: #selector(digitButtonTapped(_:)), for: .touchUpInside)
            return button
            
        case .backspace:
            let button = UIButton(type: .system)
            let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
            let image = UIImage(systemName: "delete.left.fill", withConfiguration: config)
            button.setImage(image, for: .normal)
            button.tintColor = Theme.Color.secondaryLabel.color
            button.addTarget(self, action: #selector(backspaceButtonTapped), for: .touchUpInside)
            return button
            
        case .empty:
            let spacer = UIView()
            spacer.isUserInteractionEnabled = false
            return spacer
        }
    }
    
    //MARK: - Actions
    @objc func digitButtonTapped(_ sender: UIButton) {
        digitTappedSubject.send(sender.tag)
    }
    
    @objc func backspaceButtonTapped() {
        backspaceTappedSubject.send()
    }
}

//MARK: - PadItem
private extension PinPadView {
    enum PadItem {
        case digit(Int)
        case backspace
        case empty
    }
}
