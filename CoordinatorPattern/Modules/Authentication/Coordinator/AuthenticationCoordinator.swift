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
    var finishFlow: AnyPublisher<Void, Never> { get }
}

final class AuthenticationCoordinator: BaseCoordinator, AuthenticationCoordinatorOutput {
    
    //MARK: - AuthenticationCoordinatorOutput
    private let finishFlowSubject = PassthroughSubject<Void, Never>()
    var finishFlow: AnyPublisher<Void, Never> {
        finishFlowSubject.eraseToAnyPublisher()
    }
        
    //MARK: - Dependencies
    private let router: Routable
    private let authFactory: AuthenticationFactoryProtocol
    
    //MARK: - Initializer
    init(router: Routable, authFactory: AuthenticationFactoryProtocol) {
        self.router = router
        self.authFactory = authFactory

        super.init()
    }
    
    override func start() {
        performLoginFlow()
    }
    
}

//MARK: - Flows Assembly
private extension AuthenticationCoordinator {
    
    func performLoginFlow() {
        let (viewModel, view) = authFactory.makeLoginScene()

        viewModel.showRegistration
            .sink { [weak self] in
                self?.performRegistrationFlow()
            }
            .store(in: &cancellables)
        
        viewModel.onErrorPublisher
            .sink { [weak self] title, message in
                let action = AlertConfiguration.AlertAction(title: "Try Again", style: .default, completion: nil)
                let config = AlertConfiguration(
                    title: title,
                    message: message,
                    style: .alert, actions: [action]
                )
                
                self?.router.presentAlert(config: config)
            }
            .store(in: &cancellables)
        
        bindFinish(from: viewModel) { [weak self] in
            self?.finishFlowSubject.send()
        }
    
        router.setRootModule(view, hideNavBar: false)
    }
    
    func performRegistrationFlow() {
        let (viewModel, view) = authFactory.makeRegistrationScene()
        
        viewModel.backToLoginPubliher
            .sink { [weak self] in
                self?.router.popModule(animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.onErrorPublisher
            .sink { [weak self] title, message in
                let action = AlertConfiguration.AlertAction(title: "Try Again", style: .default, completion: nil)
                let config = AlertConfiguration(
                    title: title,
                    message: message,
                    style: .alert, actions: [action]
                )
                
                self?.router.presentAlert(config: config)
            }
            .store(in: &cancellables)
        
        bindFinish(from: viewModel) { [weak self] in
            self?.finishFlowSubject.send()
        }
        
        router.push(view, animated: true, hideBackButton: true)
    }
    
}
