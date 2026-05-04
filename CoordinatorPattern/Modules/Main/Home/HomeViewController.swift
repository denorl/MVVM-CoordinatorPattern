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
    let balanceCardView = BalanceCardView()
    
    //MARK: - Overriden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureConstraints()
        bindViewModel()
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        navigationItem.title = "Home"
        balanceCardView.detailsButton.addTarget(self, action: #selector(detailsButtonTapped), for: .touchUpInside)
    }
    
    private func configureConstraints() {
        view.addSubview(balanceCardView)
        
        balanceCardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview().inset(5)
            make.height.equalTo(AppStyle.BalanceCard.cardHeight )
        }
    }
    
}

//MARK: - VM Binding
private extension HomeViewController {
    func bindViewModel() {
        
    }
}

//MARK: - Private Methods
private extension HomeViewController {
    @objc func detailsButtonTapped() {
        viewModel.accountDetailsTapped()
    }
}
