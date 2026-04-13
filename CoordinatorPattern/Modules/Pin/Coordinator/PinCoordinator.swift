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
    private let finishFlowSubject = PassthroughSubject<Void, Never>()
    var finishFlow: AnyPublisher<Void, Never> {
        finishFlowSubject.eraseToAnyPublisher()
    }
    
    private let router: Routable
    private let factory: PinFactoryProtocol
    private var mode: PinFlowMode
    private var pendingFirstPin: [Int]?
    
    init(router: Routable, factory: PinFactoryProtocol, mode: PinFlowMode) {
        self.router = router
        self.factory = factory
        self.mode = mode
    }
    
}

extension PinCoordinator: Coordinatable {
    func start() {
        switch mode {
        case .createPin:
            performCreatePinFlow()
        case .enterPin:
            performEnterPinFlow()
        }
    }
}

//MARK: - Private Methods
private extension PinCoordinator {
    func performCreatePinFlow() {
        let viewModel = factory.makeCreatePinViewModel()
        let view = factory.makeCreatePinView(for: viewModel)
        
        viewModel.showConfirmPin
            .sink { [weak self] firstPin in
                self?.pendingFirstPin = firstPin
                self?.performConfirmPinFlow()
            }
            .store(in: &cancellables)
        
        router.setRootModule(view, hideNavBar: false)
    }
    
    func performConfirmPinFlow() {
        guard let firstPin = pendingFirstPin else { return }
        
        let viewModel = factory.makeConfirmPinViewModel(firstPin: firstPin)
        let view = factory.makeConfirmPinView(for: viewModel)
        
        bindFinish(from: viewModel) { [weak self] in
            self?.finishFlowSubject.send()
        }
        
        router.push(view, animated: true)
    }
    
    func performEnterPinFlow() {
        let viewModel = factory.makeEnterPinViewModel()
        let view = factory.makeEnterPinView(for: viewModel)
        
        bindFinish(from: viewModel) { [weak self] in
            self?.finishFlowSubject.send()
        }
        
        router.setRootModule(view, hideNavBar: false)
    }
}
