//
//  TabBarCoordinatorFactory.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 1/5/26.
//

import UIKit

struct TabFlow {
    let coordinator: Coordinatable
    let rootVC: UIViewController?
    
    enum TabFlowFinishReason {
        case signOut
    }
}

protocol TabBarFactoryProtocol {
    func makeTabFlow(for tab: MainTab) -> TabFlow
}

final class TabBarCoordinatorFactory: TabBarFactoryProtocol {
    
    private let modulesFactory: ModulesFactory
    
    init(modulesFactory: ModulesFactory) {
        self.modulesFactory = modulesFactory
    }
    
    func makeTabFlow(for tab: MainTab) -> TabFlow {
        let router: NavigationRoutable = Router()
        let coordinator: Coordinatable
        
        switch tab {
        case .home:
            coordinator = makeHomeCoordinator(router: router)
        case .profile:
            coordinator = makeProfileCoordinator(router: router)
        case .settings:
            coordinator = makeSettingsCoordinator(router: router)
        }
        router.toPresent?.tabBarItem = tab.item
        
        return TabFlow(coordinator: coordinator, rootVC: router.toPresent)
    }
    
    private func makeHomeCoordinator(router: NavigationRoutable) -> Coordinatable & HomeCoordinatorOutput {
        HomeCoordinator(router: router, factory: modulesFactory)
    }
    
    private func makeProfileCoordinator(router: NavigationRoutable) -> Coordinatable & ProfileCoordinatorOutput {
        ProfileCoordinator(router: router, factory: modulesFactory)
    }
    
    private func makeSettingsCoordinator(router: NavigationRoutable) -> Coordinatable & SettingsCoordinatorOutput {
        SettingsCoordinator(router: router, factory: modulesFactory)
    }
}
