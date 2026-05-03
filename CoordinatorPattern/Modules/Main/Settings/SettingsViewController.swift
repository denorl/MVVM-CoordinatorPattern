//
//  SettingsViewController.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 1/5/26.
//

import UIKit
import SnapKit
import Combine

final class SettingsViewController: BaseViewController<SettingsViewModel> {
    
    //MARK: - UI Properties
    private let signOutButton = LibertyButton()
    
    //MARK: - Overriden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureConstraints()
        bindViewModel()
    }

    //MARK: - SetupUI
    private func setupUI() {        
        signOutButton.config = .destructive(title: "Sign Out")
        signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
    }
    
    private func configureConstraints() {
        view.addSubview(signOutButton)
        
        signOutButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(AppLayout.buttonHeight)
            make.width.equalToSuperview().inset(AppLayout.horizontalInset)
        }
    }
    
}

//MARK: - VM Binding
private extension SettingsViewController {
    func bindViewModel() {
        viewModel.$isSignOutButtonEnabled
            .sink { [weak self] isEnabled in
                self?.signOutButton.isEnabled = isEnabled
            }
            .store(in: &cancellables)
    }
}

//MARK: - Private Methods
private extension SettingsViewController {
    @objc func signOutButtonTapped() {
        viewModel.signOutTapped()
    }
}
