//
//  HomeFactoryProtocol.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 1/5/26.
//

import UIKit

protocol HomeFactoryProtocol {
    func makeHomeScene() -> (vm: HomeViewModel, vc: UIViewController)
    func makeAccountDetailsScene() -> (vm: AccountDetailsViewModel, vc: UIViewController)
}

extension ModulesFactory: HomeFactoryProtocol {
    func makeHomeScene() -> (vm: HomeViewModel, vc: UIViewController) {
        let viewModel = HomeViewModel()
        let view = HomeViewController(viewModel: viewModel)
        return (viewModel, view)
    }
    
    func makeAccountDetailsScene() -> (vm: AccountDetailsViewModel, vc: UIViewController) {
        let viewModel = AccountDetailsViewModel()
        let view = AccountDetailsViewController(viewModel: viewModel)
        view.hidesBottomBarWhenPushed = true
        return (viewModel, view)
    }
}
