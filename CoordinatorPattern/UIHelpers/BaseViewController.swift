//
//  LibertyBaseViewController.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 24/4/26.
//

import UIKit
import Combine

class BaseViewController<ViewModel>: UIViewController, UIGestureRecognizerDelegate {
    
    let viewModel: ViewModel
    var cancellables = Set<AnyCancellable>()
    
    //MARK: - Initializers
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Color.themeBackground.color

        hideKeyboardWhenTappedAround()
    }
    
    //MARK: - TextField input binding
    func bindText(
        from field: ValidatedInputField,
        to keyPath: ReferenceWritableKeyPath<ViewModel, String>,
        where shouldBind: @escaping () -> Bool = { true }
    ) {
        field.textPublisher
            .filter { _ in shouldBind() }
            .sink { [weak self] text in
                self?.viewModel[keyPath: keyPath] = text
            }
            .store(in: &cancellables)
    }
    
    //MARK: - UIGestureRecognizerDelega
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is UIControl)
    }
    
}
