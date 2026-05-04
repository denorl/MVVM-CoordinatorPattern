//
//  TabBarCoordinator.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 12/4/26.
//

import UIKit
import Combine

protocol TabBarCoordinatorOutput {
    var finishFlow: AnyPublisher<TabFlow.TabFlowFinishReason, Never> { get }
}

final class TabBarCoordinator: BaseCoordinator, TabBarCoordinatorOutput {
    
    private let finishFlowSubject = PassthroughSubject<TabFlow.TabFlowFinishReason, Never>()
    var finishFlow: AnyPublisher<TabFlow.TabFlowFinishReason, Never> {
        finishFlowSubject.eraseToAnyPublisher()
    }
    
    private let router: Routable
    private let factory: TabBarFactoryProtocol
    
    init(router: Routable, factory: TabBarFactoryProtocol) {
        self.router = router
        self.factory = factory
    }
    
    override func start() {        
        let tabBarController = MainTabBarController()
        
        let flows = MainTab.allCases.map { factory.makeTabFlow(for: $0) }
        flows.forEach { performTabFlow($0) }
        tabBarController.configure(with: flows)
        
        router.setRootModule(tabBarController, hideNavBar: true)
    }
    
}

//MARK: - Private Methods
private extension TabBarCoordinator {
    
    func performTabFlow(_ flow: TabFlow) {
        addChildCoordinator(flow.coordinator)
        flow.coordinator.start()
        bindIfNeeded(flow.coordinator)
    }
    
    func bindIfNeeded(_ coordinator: Coordinatable) {
        
        if let settings = coordinator as? SettingsCoordinatorOutput {
            settings.finishFlow
                .first()
                .sink { [weak self] in self?.finishFlowSubject.send(.signOut) }
                .store(in: &cancellables)
        }
        
    }
    
}


