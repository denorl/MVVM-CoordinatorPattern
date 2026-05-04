//
//  CurrencyRatesViewController.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 2/5/26.
//

import UIKit
import SnapKit
import Combine

final class AccountDetailsViewController: BaseViewController<AccountDetailsViewModel> {
    
    //MARK: - UI Properties
    private let tableView = UITableView()
    
    //MARK: - Overriden Methods
    override func viewDidLoad() {
        setupUI()
        configureConstraints()
        bindViewModel()
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        navigationItem.title = "Account Details"
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configureConstraints() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension AccountDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
}

extension AccountDetailsViewController: UITableViewDelegate {
    
}

//MARK: - VM Binding
private extension AccountDetailsViewController {
    func bindViewModel() {
        
    }
}
