//
//  AuthenticationViewController.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 7/4/26.
//
import UIKit
import SnapKit
import Combine

protocol RouteIdentifiable {
    var route: Route.Authentication { get }
}

class AuthenticationViewController<ViewModel: AuthenticationViewModel>: UIViewController, UIGestureRecognizerDelegate {
    
    var cancellables = Set<AnyCancellable>()
    let viewModel: ViewModel
    
    //MARK: - UI Properties
    let stackView = UIStackView()
    let continueButton = UIButton()
    
    var keyboardAdaptiveConstraint: Constraint?
    var defaultKeyboardOffset: CGFloat = -20
    
    //MARK: - Initializers
    init(viewModel: ViewModel) {
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
        bindViewModel()
        
        setupKeyboardObservers()
        hideKeyboardWhenTappedAround()
    }
    
    //MARK: - Binding Methods
    func bindInputField(
        _ field: ValidatedInputField,
        toBorderState borderPublisher: Published<AuthTextField.ValidationState>.Publisher,
        toError errorPublisher: Published<String?>.Publisher
    ) {
        Publishers.CombineLatest(borderPublisher, errorPublisher)
            .receive(on: DispatchQueue.main)
            .sink { fieldBorderState, errorMessage in
                field.updateFieldState(for: fieldBorderState, errorMessage: errorMessage)
            }
            .store(in: &cancellables)
    }
    
    func bindText(from field: ValidatedInputField, to keyPath: ReferenceWritableKeyPath<ViewModel, String>) {
        field.textPublisher
            .assign(to: keyPath, on: viewModel)
            .store(in: &cancellables)
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.setTitleColor(.white.withAlphaComponent(0.6), for: .disabled)
        continueButton.layer.cornerRadius = 15
        
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    @objc private func continueButtonTapped() {
        dismissKeyboard()
        viewModel.continueButtonTapped()
    }
    
    @objc func handleKeyboard(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        
        let isShowing = notification.name == UIResponder.keyboardWillShowNotification
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        let targetOffset = isShowing ? -(keyboardHeight + 10) : defaultKeyboardOffset
        
        keyboardAdaptiveConstraint?.update(offset: targetOffset)
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIControl {
            return false
        }
        return true
    }
    
    //MARK: - VM Binding
    private func bindViewModel() {
        viewModel.$isButtonEnabled
            .sink { [weak self] isEnabled in
                self?.continueButton.isEnabled = isEnabled
                self?.continueButton.backgroundColor = isEnabled ?
                AppColor.themeBlue.color :
                AppColor.themeBlue.color.withAlphaComponent(0.7)
            }
            .store(in: &cancellables)
    }
}


//MARK: - Private Methods
private extension AuthenticationViewController {
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Adds a tap gesture to the root view to dismiss the keyboard.
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
}

