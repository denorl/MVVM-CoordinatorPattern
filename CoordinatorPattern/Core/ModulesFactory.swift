//
//  ModuleFactory.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//

import UIKit

final class ModulesFactory {
    private let mockAuthManager = MockAuthenticationManager()
    private let pinManager = PinManager()
}

//MARK: - AuthenticationFactoryProtocol
extension ModulesFactory: AuthenticationFactoryProtocol {
    
    func makeLoginScene() -> (vm: LoginViewModel, vc: UIViewController) {
        let viewModel = LoginViewModel(authManager: mockAuthManager)
        let view = LoginViewController(viewModel: viewModel)
        return (viewModel, view)
    }
    
    func makeRegistrationScene() -> (vm: RegistrationViewModel, vc: UIViewController) {
        let viewModel = RegistrationViewModel(authManager: mockAuthManager)
        let view = RegistrationViewController(viewModel: viewModel)
        return (viewModel, view)
    }
    
}

//MARK: - PinFactoryProtocol
extension ModulesFactory: PinFactoryProtocol {
    func makePinScene(for route: Route.Pin) -> (vm: PinViewModel, vc: PinViewController) {
        let viewModel = PinViewModel(route: route, pinManager: pinManager)
        let view = PinViewController(viewModel: viewModel)
        return (viewModel, view)
    }
}

//MARK: - SettingsFactoryProtocol
extension ModulesFactory: SettingsFactoryProtocol {
    func makeSettingsScene() -> (vm: SettingsViewModel, vc: UIViewController) {
        let viewModel = SettingsViewModel(authManager: mockAuthManager)
        let view = SettingsViewController(viewModel: viewModel)
        return (viewModel, view)
    }
}

