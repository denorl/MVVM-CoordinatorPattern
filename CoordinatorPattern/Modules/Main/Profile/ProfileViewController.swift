//
//  ProfileViewController.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 1/5/26.
//

import UIKit

final class ProfileViewController: BaseViewController<ProfileViewModel> {
    
    //MARK: - UI properties
    
    //MARK: - Overriden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureConstraints()
        bindViewModel()
    }

    //MARK: - SetupUI
    private func setupUI() {
        
    }
    
    private func configureConstraints() {
      
    }
    
}

//MARK: - VM Binding
private extension ProfileViewController {
    func bindViewModel() {
        
    }
}

//MARK: - Private Methods
private extension ProfileViewController {
    
}
