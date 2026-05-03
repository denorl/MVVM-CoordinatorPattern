//
//  CurrencyRatesViewController.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 2/5/26.
//

import UIKit
import SnapKit
import Combine

final class CurrencyRatesViewController: BaseViewController<CurrencyRatesViewModel> {
    
    //MARK: - UI Properties
    
    //MARK: - Overriden Methods
    override func viewDidLoad() {
        setupUI()
        configureConstraints()
        bindViewModel()
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        navigationItem.title = "Currency Rates"
        
    }
    
    private func configureConstraints() {

    }
    
}

//MARK: - VM Binding
private extension CurrencyRatesViewController {
    func bindViewModel() {
        
    }
}
