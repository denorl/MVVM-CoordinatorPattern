//
//  Untitled.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 1/5/26.
//

import UIKit

protocol ProfileFactoryProtocol {
    func makeProfileScene() -> (vm: ProfileViewModel, vc: UIViewController)
}

extension ModulesFactory: ProfileFactoryProtocol {
    func makeProfileScene() -> (vm: ProfileViewModel, vc: UIViewController) {
        let viewModel = ProfileViewModel()
        let view = ProfileViewController(viewModel: viewModel)
        return (viewModel, view)
    }
}
