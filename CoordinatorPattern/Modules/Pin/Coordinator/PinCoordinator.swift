//
//  PinCoordinator.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 6/4/26.
//
import Combine

protocol PinCoordinatorOutput {
    var finishFlow: AnyPublisher<Void, Never> { get }
}

final class PinCoordinator: BaseCoordinator, PinCoordinatorOutput {
    
    private var pendingFirstPin: [Int]?
    
    #warning("rename to finish coordinator to understand better its purpose")
    //MARK: - Finish Flow publisher
    private let finishFlowSubject = PassthroughSubject<Void, Never>()
    var finishFlow: AnyPublisher<Void, Never> {
        finishFlowSubject.eraseToAnyPublisher()
    }
    
    //MARK: - Dependencies
    private let router: Routable
    private let factory: PinFactoryProtocol
    private var route: Route.Pin
        
    //MARK: - Initializer
    init(router: Routable, factory: PinFactoryProtocol, route: Route.Pin) {
        self.router = router
        self.factory = factory
        self.route = route
    }
    
}

extension PinCoordinator: Coordinatable {
    func start() {
        switch route {
        case .createPin:
            performCreatePinFlow()
        case .enterPin:
            performEnterPinFlow()
        }
    }
}

//MARK: - Flows Assembly
private extension PinCoordinator {
    
    func performCreatePinFlow() {
        let (viewModel, view) = factory.makeCreatePinScene()
        
        viewModel.showConfirmPin
            .sink { [weak self] firstPin in
                self?.pendingFirstPin = firstPin
                self?.performConfirmPinFlow()
            }
            .store(in: &cancellables)
        
        router.push(view, animated: true, hideBackButton: true)
    }
    
    func performConfirmPinFlow() {
        guard let firstPin = pendingFirstPin else { return }
        
        let (viewModel, view) = factory.makeConfirmPinScene(firstPin: firstPin)

        bindFinish(from: viewModel) { [weak self] in
            self?.finishFlowSubject.send()
        }
        
        router.push(view, animated: true, hideBackButton: false)
    }
    
    func performEnterPinFlow() {
        let (viewModel, view) = factory.makeEnterPinScene()

        bindFinish(from: viewModel) { [weak self] in
            self?.finishFlowSubject.send()
        }
        
        router.setRootModule(view, hideNavBar: false)
    }
    
}
