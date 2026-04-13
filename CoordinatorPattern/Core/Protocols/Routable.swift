//
//  Routable.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//
import Combine
import UIKit

protocol Routable: Presentable {
    var popPublisher: AnyPublisher<UIViewController, Never> { get }
    
    func present(_ module: Presentable?, animated: Bool)
    func push(_ module: Presentable?, animated: Bool)
    func setRootModule(_ module: Presentable?, hideNavBar: Bool)
    
    func popModule(animated: Bool)
    func dismissModule(animated: Bool, completion: (() -> Void)?)
}
