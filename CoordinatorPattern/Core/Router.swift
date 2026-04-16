//
//  Router.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//

import UIKit
import Combine

#warning("все для рутов в одну папку")
final class Router: NSObject {
    private var rootController = UINavigationController()
    
    private let window: UIWindow
    private let popSubject = PassthroughSubject<UIViewController, Never>()
    var popPublisher: AnyPublisher<UIViewController, Never> {
        popSubject.eraseToAnyPublisher()
    }
    
    init(window: UIWindow) {
        self.window = window
        super.init()
        assignRootController()
        self.rootController.delegate = self
    }
    
    var toPresent: UIViewController? {
        return rootController
    }
}

// MARK: - UINavigationControllerDelegate
extension Router: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        
        guard let poppedController = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(poppedController) else {
            return
        }
        
        popSubject.send(poppedController)
    }
}

//MARK: - Routable
extension Router: Routable {
    func assignRootController() {
        window.rootViewController = rootController
        window.makeKeyAndVisible()
    }
    
    func present(_ module: (any Presentable)?, animated: Bool) {}
    
    func push(_ module: (any Presentable)?, animated: Bool, hideBackButton: Bool) {
        guard let controller = module?.toPresent else { return }
        guard !(rootController.viewControllers.contains(controller)) else { return }
        
        rootController.pushViewController(controller, animated: animated)
        controller.navigationItem.hidesBackButton = hideBackButton
    }
    
    func setRootModule(_ module: (any Presentable)?, hideNavBar: Bool) {
        guard let controller = module?.toPresent else { return }
        
        rootController.setViewControllers([controller], animated: false)
        rootController.isNavigationBarHidden = hideNavBar
        
        UIView.transition(with: window,
                          duration: 0.5,
                          options: .transitionFlipFromRight,
                          animations: nil)
    }
    
    func popModule(animated: Bool) {
        rootController.popViewController(animated: true)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {}
    
}
