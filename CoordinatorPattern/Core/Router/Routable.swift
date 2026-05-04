//
//  Routable.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//
import Combine
import UIKit

typealias FullRoutable = NavigationRoutable & WindowRoutable

protocol WindowRoutable {
    func assignRootController(_ controller: UIViewController)
}

protocol NavigationRoutable: Presentable {
    var popPublisher: AnyPublisher<UIViewController, Never> { get }
    
    func present(_ module: Presentable?, animated: Bool)
    func presentAlert(config: AlertConfiguration, animated: Bool)
    
    func push(_ module: (any Presentable)?, animated: Bool, hideBackButton: Bool)
    func setRootModule(_ module: Presentable?, hideNavBar: Bool)
    
    func popModule(animated: Bool)
    func dismissModule(animated: Bool, completion: (() -> Void)?)
}

extension NavigationRoutable {
    func push(_ module: (any Presentable)?, animated: Bool, hideBackButton: Bool = false) {
        self.push(module, animated: animated, hideBackButton: hideBackButton)
    }
    
    func presentAlert(config: AlertConfiguration, animated: Bool = true) {
        self.presentAlert(config: config, animated: animated)
    }
}
