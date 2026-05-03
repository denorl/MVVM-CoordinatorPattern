//
//  ProfileCoordinator.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 1/5/26.
//

import Combine

protocol ProfileCoordinatorOutput {
    var finishFlow: AnyPublisher<Void, Never> { get }
}

final class ProfileCoordinator: BaseCoordinator, ProfileCoordinatorOutput {
    
    private let finishFlowSubject = PassthroughSubject<Void, Never>()
    var finishFlow: AnyPublisher<Void, Never> {
        finishFlowSubject.eraseToAnyPublisher()
    }
    
    private let router: Routable
    private let factory: ProfileFactoryProtocol
    
    init(router: Routable, factory: ProfileFactoryProtocol) {
        self.router = router
        self.factory = factory
    }
    
    override func start() {
        let (viewModel, view) = factory.makeProfileScene()
        
        bindFinish(from: viewModel) { [weak self] in
            self?.finishFlowSubject.send()
        }
        
        router.setRootModule(view, hideNavBar: false)
    }
    
}
