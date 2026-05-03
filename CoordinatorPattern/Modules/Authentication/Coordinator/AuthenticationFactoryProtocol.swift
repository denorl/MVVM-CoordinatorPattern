//
//  AuthenticationFactoryProtocol.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//

import UIKit

protocol AuthenticationFactoryProtocol {
    func makeLoginScene() -> (vm: LoginViewModel, vc: UIViewController)
    func makeRegistrationScene() -> (vm: RegistrationViewModel, vc: UIViewController)
}

