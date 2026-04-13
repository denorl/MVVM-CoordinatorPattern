//
//  MainViewController.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 12/4/26.
//

import UIKit
import SnapKit
import Combine

final class MainViewController: UIViewController {
    
    private let viewModel: MainViewModel
    
    //MARK: - UI Properties
    private let signOutButton = UIButton(type: .system)
    
    //MARK: - Initializers
    init(viewModel: MainViewModel) {
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
    }

    //MARK: - SetupUI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        signOutButton.backgroundColor = .red
        signOutButton.layer.cornerRadius = 15
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        signOutButton.setTitleColor(.white, for: .normal)
        signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
    }
    
    private func configureConstraints() {
        view.addSubview(signOutButton)
        
        signOutButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.065)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
    }
    
}

//MARK: - Private Methods
private extension MainViewController {
    @objc func signOutButtonTapped() {
        viewModel.signOutTapped()
    }
}
