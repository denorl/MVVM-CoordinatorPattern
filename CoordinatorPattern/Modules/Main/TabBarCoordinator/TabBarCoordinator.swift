//
//  TabBarCoordinator.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 12/4/26.
//

import UIKit
import Combine

protocol TabBarCoordinatorOutput {
    var finishFlow: AnyPublisher<TabFlowFinishReason, Never> { get }
}

enum TabFlowFinishReason {
    case signOut
}

final class TabBarCoordinator: BaseCoordinator, TabBarCoordinatorOutput {
    
    private let finishFlowSubject = PassthroughSubject<TabFlowFinishReason, Never>()
    var finishFlow: AnyPublisher<TabFlowFinishReason, Never> {
        finishFlowSubject.eraseToAnyPublisher()
    }
    
    private let router: Routable
    private let factory: TabBarFactoryProtocol
    
    init(router: Routable, factory: TabBarFactoryProtocol) {
        self.router = router
        self.factory = factory
    }
    
    override func start() {
        let tabBarController = UITabBarController()
        
        let tabs: [MainTab] = [.home, .profile, .settings]
        let controllers = tabs.map { prepareTabFlow(for: $0) }
        
        tabBarController.viewControllers = controllers
        
        router.setRootModule(tabBarController, hideNavBar: true)
    }
    
}

//MARK: - Private Methods
private extension TabBarCoordinator {
    func prepareTabFlow(for tab: MainTab) -> UIViewController {
        let tabRouter = Router()
        let coordinator: Coordinatable
        
        switch tab {
        case .home:
            let homeCoordinator = factory.makeHomeCoordinator(router: tabRouter)
            bindHomeFinish(homeCoordinator)
            coordinator = homeCoordinator
        case .profile:
            coordinator = factory.makeProfileCoordinator(router: tabRouter)
        case .settings:
            let settingsCoordinator = factory.makeSettingsCoordinator(router: tabRouter)
            bindSettingsFinish(settingsCoordinator)
            coordinator = settingsCoordinator
        }
        
        tabRouter.toPresent?.tabBarItem = tab.item
        
        addChildCoordinator(coordinator)
        coordinator.start()
        
        return tabRouter.toPresent ?? UIViewController()
        
    }
    
    func bindHomeFinish(_ coordinator: HomeCoordinatorOutput) {
        coordinator.finishFlow
            .first()
            .sink { [weak self] in

            }
            .store(in: &cancellables)
    }
    
    func bindSettingsFinish(_ coordinator: SettingsCoordinatorOutput) {
        coordinator.finishFlow
            .first()
            .sink { [weak self] in self?.finishFlowSubject.send(.signOut) }
            .store(in: &cancellables)
    }
}


