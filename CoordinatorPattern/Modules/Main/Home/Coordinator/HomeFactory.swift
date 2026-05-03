//
//  HomeFactoryProtocol.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 1/5/26.
//

import UIKit

protocol HomeFactoryProtocol {
    func makeHomeScene() -> (vm: HomeViewModel, vc: UIViewController)
    func makeCurrencyRatesDetailsScene() -> (vm: CurrencyRatesViewModel, vc: UIViewController)
}

extension ModulesFactory: HomeFactoryProtocol {
    func makeHomeScene() -> (vm: HomeViewModel, vc: UIViewController) {
        let viewModel = HomeViewModel()
        let view = HomeViewController(viewModel: viewModel)
        return (viewModel, view)
    }
    
    func makeCurrencyRatesDetailsScene() -> (vm: CurrencyRatesViewModel, vc: UIViewController) {
        let viewModel = CurrencyRatesViewModel()
        let view = CurrencyRatesViewController(viewModel: viewModel)
        view.hidesBottomBarWhenPushed = true
        return (viewModel, view)
    }
}
