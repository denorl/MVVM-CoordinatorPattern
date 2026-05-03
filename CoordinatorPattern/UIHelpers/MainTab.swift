//
//  MainTab.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 1/5/26.
//

import UIKit

enum MainTab {
    case home, profile, settings

    var item: UITabBarItem {
        switch self {
        case .home:     return UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        case .profile:  return UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 1)
        case .settings: return UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
        }
    }
}
