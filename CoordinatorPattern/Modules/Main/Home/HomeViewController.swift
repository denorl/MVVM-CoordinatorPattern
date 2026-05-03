//
//  MainViewController.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 12/4/26.
//

import UIKit
import SnapKit
import Combine

final class HomeViewController: BaseViewController<HomeViewModel> {
    
    //MARK: - UI Properties
    
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
private extension HomeViewController {
    func bindViewModel() {
        
    }
}
