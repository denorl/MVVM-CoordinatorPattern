//
//  PinCoordinator.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 22/4/26.
//

import Foundation
import Combine

protocol PinCoordinatorOutput {
    var finishPinFlow: AnyPublisher<Void, Never> { get }
}

final class PinCoordinator: BaseCoordinator, PinCoordinatorOutput {
    
    //MARK: - Finish Pin Flow Publisher
    private let finishPinFlowSubject = PassthroughSubject<Void, Never>()
    var finishPinFlow: AnyPublisher<Void, Never> {
        finishPinFlowSubject.eraseToAnyPublisher()
    }
    
    private let router: Routable
    private let route: Route.Pin
    private let factory: PinFactoryProtocol
    
    init(router: Routable, route: Route.Pin, factory: PinFactoryProtocol) {
        self.router = router
        self.route = route
        self.factory = factory
    }
    
    override func start() {
        perfromPinFlow(for: route)
    }
    
}

//MARK: - Flows Assembly
private extension PinCoordinator {
    func perfromPinFlow(for route: Route.Pin) {
        let (viewModel, view) = factory.makePinScene(for: route)
        
        bindFinish(from: viewModel) { [weak self] in
            self?.finishPinFlowSubject.send()
        }
        router.push(view, animated: true, hideBackButton: false)
    }
}
