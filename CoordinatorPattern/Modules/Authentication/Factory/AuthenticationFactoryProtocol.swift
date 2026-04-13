//
//  AuthenticationFactoryProtocol.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//

import UIKit

protocol AuthenticationFactoryProtocol {
    func makeLoginView(for viewModel: LoginViewModel) -> UIViewController
    func makeLoginViewModel() -> LoginViewModel
    
    func makeRegistrationLoginView(for viewModel: RegistrationLoginViewModel) -> UIViewController
    func makeRegistrationLoginViewModel() -> RegistrationLoginViewModel
    
    func makeRegistrationPasswordView(for viewModel: RegistrationPasswordViewModel) -> UIViewController
    func makeRegistrationPasswordViewModel(login: String) -> RegistrationPasswordViewModel
}

