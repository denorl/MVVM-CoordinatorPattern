//
//  HomeCoordinator.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 1/5/26.
//

import UIKit
import Combine

protocol HomeCoordinatorOutput {
    var finishFlow: AnyPublisher<Void, Never> { get }
}

final class HomeCoordinator: BaseCoordinator, HomeCoordinatorOutput {
    
    private let finishFlowSubject = PassthroughSubject<Void, Never>()
    var finishFlow: AnyPublisher<Void, Never> {
        finishFlowSubject.eraseToAnyPublisher()
    }
    
    private let router: Routable
    private let factory: HomeFactoryProtocol
    
    init(router: Routable, factory: HomeFactoryProtocol) {
        self.router = router
        self.factory = factory
    }
    
    override func start() {
        let (viewModel, view) = factory.makeHomeScene()
        
        viewModel.showCurrencyRatesDetais
            .sink { [weak self] in
                self?.performCurrencyRatesDetailsFlow()
            }
            .store(in: &cancellables)
        
        bindFinish(from: viewModel) { [weak self] in
            self?.finishFlowSubject.send()
        }
        
        router.setRootModule(view, hideNavBar: false)
    }
    
}

//MARK: - Flows Assembly
private extension HomeCoordinator {
    func performCurrencyRatesDetailsFlow() {
        let (viewModel, view) = factory.makeCurrencyRatesDetailsScene()
        
        bindFinish(from: viewModel) { [weak self] in
            self?.router.popModule(animated: true)
        }
        
        router.push(view, animated: true, hideBackButton: false)
    }
}
