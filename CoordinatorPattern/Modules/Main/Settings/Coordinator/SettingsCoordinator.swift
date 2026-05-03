//
//  SettingsCoordinator.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 1/5/26.
//

import Combine

protocol SettingsCoordinatorOutput {
    var finishFlow: AnyPublisher<Void, Never> { get }
}

final class SettingsCoordinator: BaseCoordinator, SettingsCoordinatorOutput {
    
    private let finishFlowSubject = PassthroughSubject<Void, Never>()
    var finishFlow: AnyPublisher<Void, Never> {
        finishFlowSubject.eraseToAnyPublisher()
    }
    
    private let router: Routable
    private let factory: SettingsFactoryProtocol
    
    init(router: Routable, factory: SettingsFactoryProtocol) {
        self.router = router
        self.factory = factory
    }
    
    override func start() {
        let (viewModel, view) = factory.makeSettingsScene()
        
        bindFinish(from: viewModel) { [weak self] in
            self?.finishFlowSubject.send()
        }
        
        router.setRootModule(view, hideNavBar: false)
    }
    
}
