//
//  PinBaseViewController.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 11/4/26.
//

import UIKit
import SwiftUI
import Combine
import SnapKit

final class PinViewController: UIViewController {
    
    var cancellables = Set<AnyCancellable>()
    let viewModel: PinViewModel
    
    //MARK: - UI Properties
    private let headerStackView = UIStackView()
    private let pinPadStackView = UIStackView()
    
    private let instructionLabel = UILabel()
    private let pinDotsView = PinDotsView()
    private let pinPadView = PinPadView()
    private let errorLabel = UILabel()
    
    private let forgotPinButton = AttributedActionButton(
        prompt: "",
        actionText: "Forgot your PIN?"
    )
    
    private lazy var backButton: UIBarButtonItem = {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        return backButton
    }()
    
    //MARK: - Initializers
    init(viewModel: PinViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Overriden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureConstraints()
        bindViewModel()
    }
    
}

//MARK: - SetupUI
private extension PinViewController {
    func setupUI() {
        
        navigationItem.leftBarButtonItem = backButton
        view.backgroundColor = Theme.Color.themeBackground.color
        
        headerStackView.addArrangedSubviews([
            instructionLabel,
            forgotPinButton,
            pinDotsView,
            errorLabel
        ])
        headerStackView.axis = .vertical
        headerStackView.alignment = .center
        headerStackView.spacing = AppLayout.Spacing.large
        
        pinPadStackView.addArrangedSubviews([
            forgotPinButton,
            pinPadView
        ])
        pinPadStackView.axis = .vertical
        pinPadStackView.spacing = AppLayout.Spacing.medium
        
        instructionLabel.font = Theme.Font.title3
        
        forgotPinButton.addTarget(self, action: #selector(forgotPinButtonTapped), for: .touchUpInside)
        
        pinDotsView.numberOfDots = viewModel.maxDigits
        
        errorLabel.font = Theme.Font.subheadline
        errorLabel.textColor = Theme.Color.themeRed.color
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true
    }
    
    func configureConstraints() {
        view.addSubview(headerStackView)
        view.addSubview(pinPadStackView)
        
        headerStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(AppStyle.Pin.headerTopOffset)
            make.left.right.equalToSuperview().inset(AppLayout.horizontalInset)
        }
        
        headerStackView.setCustomSpacing(AppLayout.Spacing.extraLarge, after: instructionLabel)
        
        pinPadStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-AppStyle.Pin.pinPadbottomOffset)
        }
    }
    
}

// MARK: - VM Binding
private extension PinViewController {
    
    func bindViewModel() {
        bindNavigationAndState()
        bindUIContent()
        bindActions()
    }
    
    func bindNavigationAndState() {
        viewModel.$route
            .receive(on: DispatchQueue.main)
            .sink { [weak self] route in
                self?.animateTransition(for: route)
                self?.configureButtonsState(for: route)
            }
            .store(in: &cancellables)
    }
    
    func bindUIContent() {
        viewModel.$instructionText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.instructionLabel.text = text
            }
            .store(in: &cancellables)
        
        viewModel.$enteredDigits
            .receive(on: DispatchQueue.main)
            .sink { [weak self] digits in
                self?.pinDotsView.updateFilled(count: digits.count)
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.handleErrorState(message)
            }
            .store(in: &cancellables)
    }
    
    func bindActions() {
        pinPadView.digitTapped
            .sink { [weak self] digit in
                self?.viewModel.digitTapped(digit)
            }
            .store(in: &cancellables)
        
        pinPadView.backspaceTapped
            .sink { [weak self] in
                self?.viewModel.backspaceTapped()
            }
            .store(in: &cancellables)
    }
    
}

//MARK: - Button Actions
private extension PinViewController {
    @objc func backButtonTapped() {
        viewModel.backButtonTapped()
    }
    
    @objc func forgotPinButtonTapped() {
        viewModel.forgotPinButtonTapped()
    }
}

//MARK: - Private Helpers
private extension PinViewController {
    func animateTransition(for route: Route.Pin) {
        let direction: UIView.TransitionDirection = (route == .confirmPin) ? .forward : .backward
        instructionLabel.slideTransition(direction: direction)
    }
    
    func configureButtonsState(for route: Route.Pin) {
        forgotPinButton.isHidden = (route == .enterPin) ? false : true
        backButton.isHidden = (route == .confirmPin) ? false : true
    }
    
    func handleErrorState(_ message: String?) {
        errorLabel.text = message
        errorLabel.isHidden = (message == nil)
        
        if message != nil {
            pinDotsView.shake()
        }
    }
}

//MARK: - Preview
struct PinViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            PinViewController(viewModel: PinViewModel(route: .enterPin, pinManager: PinManager()))
        }
    }
}
