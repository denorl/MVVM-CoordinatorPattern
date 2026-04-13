//
//  MainCoordinator.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 12/4/26.
//

import Combine

protocol MainCoordinatorOutput {
    var finishFlow: AnyPublisher<Void, Never> { get }
}

final class MainCoordinator: BaseCoordinator, MainCoordinatorOutput {
    
    private let finishFlowSubject = PassthroughSubject<Void, Never>()
    var finishFlow: AnyPublisher<Void, Never> {
        finishFlowSubject.eraseToAnyPublisher()
    }
    
    private let router: Routable
    private let factory: MainFactoryProtocol
    
    init(router: Routable, factory: MainFactoryProtocol) {
        self.router = router
        self.factory = factory
    }
    
}

extension MainCoordinator: Coordinatable {
    func start() {
        let viewModel = factory.makeMainViewModel()
        let view = factory.makeMainView(with: viewModel)
        
        viewModel.onFinish
            .first()
            .sink { [weak self] in
                self?.finishFlowSubject.send()
            }
            .store(in: &cancellables
            )
        router.setRootModule(view, hideNavBar: false)
    }
}
