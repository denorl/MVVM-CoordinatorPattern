//
//  ModuleFactory.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//

import UIKit

final class ModulesFactory {
    private let mockAuthManager = MockAuthenticationManager()
}

// MARK:- AuthenticationFactoryProtocol
extension ModulesFactory: AuthenticationFactoryProtocol {
    
    func makeLoginScene() -> (vm: LoginViewModel, vc: UIViewController) {
        let viewModel = LoginViewModel(authManager: mockAuthManager)
        let view = LoginViewController(viewModel: viewModel)
        return (viewModel, view)
    }
    
    func makeRegistrationLoginScene() -> (vm: RegistrationLoginViewModel, vc: UIViewController) {
        let viewModel = RegistrationLoginViewModel()
        let view = RegistrationLoginViewController(viewModel: viewModel)
        return (viewModel, view)
    }
   
    func makeRegistrationPasswordScene(login: String) -> (vm: RegistrationPasswordViewModel, vc: UIViewController) {
        let viewModel = RegistrationPasswordViewModel(login: login, authManager: mockAuthManager)
        let view = RegistrationPasswordViewController(viewModel: viewModel)
        return (viewModel, view)
    }
    
}

//MARK: - PinFactoryProtocol
extension ModulesFactory: PinFactoryProtocol {
    
    func makeCreatePinScene() -> (vm: CreatePinViewModel, vc: UIViewController) {
        let viewModel = CreatePinViewModel()
        let view = CreatePinViewController(viewModel: viewModel)
        return (viewModel, view)
    }
    
    func makeConfirmPinScene(firstPin: [Int]) -> (vm: ConfirmPinViewModel, vc: UIViewController) {
        let viewModel = ConfirmPinViewModel(firstPin: firstPin)
        let view = ConfirmPinViewController(viewModel: viewModel)
        return (viewModel, view)
    }
    
    func makeEnterPinScene() -> (vm: EnterPinViewModel, vc: UIViewController) {
        let viewModel = EnterPinViewModel()
        let view = EnterPinViewController(viewModel: viewModel)
        return (viewModel, view)
    }
    
}

// MARK: - MainFactoryProtocol
extension ModulesFactory: MainFactoryProtocol {
    func makeMainModule() -> (vm: MainViewModel, vc: UIViewController) {
        let viewModel = MainViewModel(authManager: mockAuthManager)
        let view = MainViewController(viewModel: viewModel)
        return (viewModel, view)
    }
}
