//
//  AuthenticationFactoryProtocol.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//

import UIKit

protocol AuthenticationFactoryProtocol {
    func makeLoginScene() -> (vm: LoginViewModel, vc: UIViewController)
    func makeRegistrationLoginScene() -> (vm: RegistrationLoginViewModel, vc: UIViewController)
    func makeRegistrationPasswordScene(login: String) -> (vm: RegistrationPasswordViewModel, vc: UIViewController)
}

