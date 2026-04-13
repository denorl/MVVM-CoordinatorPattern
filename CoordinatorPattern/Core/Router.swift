//
//  Router.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//

import UIKit
import Combine

final class Router: NSObject {
    private weak var rootController: UINavigationController?
    
    private let popSubject = PassthroughSubject<UIViewController, Never>()
    var popPublisher: AnyPublisher<UIViewController, Never> {
        popSubject.eraseToAnyPublisher()
    }
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
        super.init()

        self.rootController?.delegate = self
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
    func present(_ module: (any Presentable)?, animated: Bool) {}
    
    func push(_ module: (any Presentable)?, animated: Bool) {
        guard let controller = module?.toPresent else { return }
        guard !(rootController?.viewControllers.contains(controller) ?? false) else { return }
        
        rootController?.pushViewController(controller, animated: animated)
    }
    
    func setRootModule(_ module: (any Presentable)?, hideNavBar: Bool) {
        guard let controller = module?.toPresent else { return }
        
        rootController?.setViewControllers([controller], animated: false)
        rootController?.isNavigationBarHidden = hideNavBar
        
        let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        
        if let window = window {
            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionFlipFromRight,
                              animations: nil)
        }
    }
    
    func popModule(animated: Bool) {
        rootController?.popViewController(animated: true)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {}
    
}
