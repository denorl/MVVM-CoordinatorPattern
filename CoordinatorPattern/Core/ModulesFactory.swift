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
    
    func makeLoginView(for viewModel: LoginViewModel) -> UIViewController {
        return LoginViewController(viewModel: viewModel)
    }
    
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(authManager: mockAuthManager)
    }
    
    func makeRegistrationLoginView(for viewModel: RegistrationLoginViewModel) -> UIViewController {
        return RegistrationLoginViewController(viewModel: viewModel)
    }
    
    func makeRegistrationLoginViewModel() -> RegistrationLoginViewModel {
        return RegistrationLoginViewModel()
    }
    
    func makeRegistrationPasswordView(for viewModel: RegistrationPasswordViewModel) -> UIViewController {
        return RegistrationPasswordViewController(viewModel: viewModel)
    }
    
    func makeRegistrationPasswordViewModel(login: String) -> RegistrationPasswordViewModel {
        return RegistrationPasswordViewModel(login: login, authManager: mockAuthManager)
    }
    
}

//MARK: - PinFactoryProtocol
extension ModulesFactory: PinFactoryProtocol {
    
    func makeCreatePinViewModel() -> CreatePinViewModel {
        return CreatePinViewModel()
    }
    
    func makeCreatePinView(for viewModel: CreatePinViewModel) -> UIViewController {
        return CreatePinViewController(viewModel: viewModel)
    }
    
    func makeConfirmPinViewModel(firstPin: [Int]) -> ConfirmPinViewModel {
        return ConfirmPinViewModel(firstPin: firstPin)
    }
    
    func makeConfirmPinView(for viewModel: ConfirmPinViewModel) -> UIViewController {
        return ConfirmPinViewController(viewModel: viewModel)
    }
    
    func makeEnterPinViewModel() -> EnterPinViewModel {
        return EnterPinViewModel()
    }
    
    func makeEnterPinView(for viewModel: EnterPinViewModel) -> UIViewController {
        return EnterPinViewController(viewModel: viewModel)
    }
    
}

extension ModulesFactory: MainFactoryProtocol {
    func makeMainViewModel() -> MainViewModel {
        return MainViewModel(authManager: mockAuthManager)
    }
    
    func makeMainView(with viewModel: MainViewModel) -> UIViewController {
        return MainViewController(viewModel: viewModel)
    }
}

