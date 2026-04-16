//
//  AuthenticationCoordinator.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//

import UIKit
import Combine

enum AuthenticationResult {
    case loginCompleted
    case registrationCompleted
}

protocol AuthenticationCoordinatorOutput {
    var finishFlow: AnyPublisher<AuthenticationResult, Never> { get }
}

final class AuthenticationCoordinator: BaseCoordinator, AuthenticationCoordinatorOutput {
    
    private var pendingRegistrationData = PendingAuthData()
    
    //MARK: - AuthenticationCoordinatorOutput
    private let finishFlowSubject = PassthroughSubject<AuthenticationResult, Never>()
    var finishFlow: AnyPublisher<AuthenticationResult, Never> {
        finishFlowSubject.eraseToAnyPublisher()
    }
        
    //MARK: - Dependencies
    private let router: Routable
    private let authFactory: AuthenticationFactoryProtocol
    
    //MARK: - Initializer
    init(router: Routable, authFactory: AuthenticationFactoryProtocol) {
        self.authFactory = authFactory
        self.router = router
        
        super.init()
    }
    
}

//MARK: - Coordinatable
extension AuthenticationCoordinator: Coordinatable {
    func start() {
        setupPopListener()
        performLoginFlow()
    }
}

//MARK: - Flow Handling Methods
private extension AuthenticationCoordinator {
    
    func performLoginFlow() {
        let (viewModel, view) = authFactory.makeLoginScene()

        viewModel.showRegistration
            .sink { [weak self] in
                self?.performRegistrationLoginFlow()
            }
            .store(in: &cancellables)
        
        bindFinish(from: viewModel) { [weak self] in
            self?.finishFlowSubject.send(.loginCompleted)
        }
    
        router.setRootModule(view, hideNavBar: false)
    }
    
    func performRegistrationLoginFlow() {
        let (viewModel, view) = authFactory.makeRegistrationLoginScene()
        
        viewModel.showCreatePassword
            .sink { [weak self] login in
                self?.pendingRegistrationData.pendingLogin = login
                self?.performRegistrationPasswordFlow()
            }
            .store(in: &cancellables)
        
        router.push(view, animated: true)
    }
    
    func performRegistrationPasswordFlow() {
        guard let login = pendingRegistrationData.pendingLogin else { return }
        let (viewModel, view) = authFactory.makeRegistrationPasswordScene(login: login)
        
        bindFinish(from: viewModel) { [weak self] in
            self?.finishFlowSubject.send(.registrationCompleted)
        }
        
        router.push(view, animated: true)
    }
    
}

//MARK: - Private Methods
private extension AuthenticationCoordinator {
    
    func setupPopListener() {
        router.popPublisher
            .sink { [weak self] poppedController in
                self?.handlePop(poppedController)
            }
            .store(in: &cancellables)
    }
    
    func handlePop(_ controller: UIViewController) {
        guard let controller = controller as? RouteIdentifiable else { return }
        switch controller.route {
        case .registrationLogin:
            pendingRegistrationData.pendingLogin = nil
        default: break
        }
    }
    
}
