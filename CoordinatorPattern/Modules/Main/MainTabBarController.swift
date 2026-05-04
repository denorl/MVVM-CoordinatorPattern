//
//  MainTabBarController.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/5/26.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        tabBar.tintColor = Theme.Color.themeBlue().color
    }

    func configure(with flows: [TabFlow]) {
        let controllers = flows.map { flow in
            return flow.rootVC ?? UIViewController()
        }
        self.viewControllers = controllers
    }
    
}
