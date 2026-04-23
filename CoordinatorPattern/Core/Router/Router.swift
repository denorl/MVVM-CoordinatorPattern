//
//  Router.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//

import UIKit
import Combine

struct AlertConfiguration {
    let title: String
    let message: String
    let style: UIAlertController.Style
    let actions: [AlertAction]
    
    struct AlertAction {
        let title: String
        let style: UIAlertAction.Style
        let completion: (() -> Void)?
    }
}

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
    
    func presentAlert(config: AlertConfiguration, animated: Bool) {
        let alert = UIAlertController(
            title: config.title,
            message: config.message,
            preferredStyle: config.style
        )
        
        config.actions.forEach { actionConfig in
            let action = UIAlertAction(
                title: actionConfig.title,
                style: actionConfig.style) { _ in
                    actionConfig.completion?()
                }
            alert.addAction(action)
        }
        
        rootController.present(alert, animated: animated)
    }
    
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
