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
    
    private let finishFlowSubject = PassthroughSubject<AuthenticationResult, Never>()
    var finishFlow: AnyPublisher<AuthenticationResult, Never> {
        finishFlowSubject.eraseToAnyPublisher()
    }
    private var pendingRegistrationData: String?
    private var pendingFirstPin: [Int]?
    
    private let router: Routable
    private let authFactory: AuthenticationFactoryProtocol
    private let pinFactory: PinFactoryProtocol
    private var mode: AuthFlowMode
    
    init(router: Routable, authFactory: AuthenticationFactoryProtocol, pinFactory: PinFactoryProtocol, mode: AuthFlowMode) {
        self.authFactory = authFactory
        self.pinFactory = pinFactory
        self.router = router
        self.mode = mode
        super.init()
        setupPopListener()
    }
    
}

//MARK: - Coordinatable
extension AuthenticationCoordinator: Coordinatable {
    func start() {
        switch mode {
        case .login:
            performLoginFlow()
        case .registrationLogin:
            performRegistrationLoginFlow()
        case .registrationPassword:
            performRegistrationPasswordFlow()
        case .createPin:
            performCreatePinFlow()
        case .confirmPin:
            performConfirmPinFlow()
        case .enterPin:
            performEnterPinFlow()
        }
    }
}

//MARK: - Flow Handling Methods
private extension AuthenticationCoordinator {
    
    func performLoginFlow() {
        let viewModel = authFactory.makeLoginViewModel()
        let view = authFactory.makeLoginView(for: viewModel)
        
        viewModel.showRegistration
            .sink { [weak self] in
                self?.mode = .registrationLogin
                self?.start()
            }
            .store(in: &cancellables)
        
        bindFinish(from: viewModel) { [weak self] in
            if Session.hasPinCode {
                self?.mode = .enterPin
                self?.start()
            } else {
                self?.mode = .createPin
                self?.start()
            }
        }
    
        router.setRootModule(view, hideNavBar: false)
    }
    
    func performRegistrationLoginFlow() {
        let viewModel = authFactory.makeRegistrationLoginViewModel()
        let view = authFactory.makeRegistrationLoginView(for: viewModel)
        
        viewModel.showCreatePassword
            .sink { [weak self] login in
                self?.pendingRegistrationData = login
                self?.mode = .registrationPassword
                self?.start()
            }
            .store(in: &cancellables)
        
        router.push(view, animated: true)
    }
    
    func performRegistrationPasswordFlow() {
        guard let login = pendingRegistrationData else { return }
        
        let viewModel = authFactory.makeRegistrationPasswordViewModel(login: login)
        let view = authFactory.makeRegistrationPasswordView(for: viewModel)
        
        bindFinish(from: viewModel) { [weak self] in
            self?.mode = .createPin
            self?.start()
        }
        
        router.push(view, animated: true)
    }
    
    func performCreatePinFlow() {
        let viewModel = pinFactory.makeCreatePinViewModel()
        let view = pinFactory.makeCreatePinView(for: viewModel)
        
        viewModel.showConfirmPin
            .sink { [weak self] firstPin in
                self?.pendingFirstPin = firstPin
                self?.mode = .confirmPin
                self?.start()
            }
            .store(in: &cancellables)
        
        router.push(view, animated: true)
    }
    
    func performConfirmPinFlow() {
        guard let firstPin = pendingFirstPin else { return }
        
        let viewModel = pinFactory.makeConfirmPinViewModel(firstPin: firstPin)
        let view = pinFactory.makeConfirmPinView(for: viewModel)
        
        bindFinish(from: viewModel) { [weak self] in
            self?.finishFlowSubject.send(.registrationCompleted)
        }
        
        router.push(view, animated: true)
    }
    
    func performEnterPinFlow() {
        let viewModel = pinFactory.makeEnterPinViewModel()
        let view = pinFactory.makeEnterPinView(for: viewModel)
        
        bindFinish(from: viewModel) { [weak self] in
            self?.finishFlowSubject.send(.loginCompleted)
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
        if controller is RegistrationLoginViewController {
            mode = .login
        } else if controller is RegistrationPasswordViewController {
            mode = .registrationLogin
        }
    }
    
}
