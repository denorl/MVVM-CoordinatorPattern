//
//  AppCoordinator.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//

import Combine

enum AuthFlowMode {
    case login
    case registrationLogin
    case registrationPassword
    case createPin
    case confirmPin
    case enterPin
}

enum PinFlowMode {
    case enterPin
    case createPin
}

fileprivate enum LaunchInstructor {
    case authentication(mode: AuthFlowMode)
    case main
    case pin(mode: PinFlowMode)
    
    static func setup() -> LaunchInstructor {
        guard Session.isAuthorized else {
            return .authentication(mode: .login)
        }
        
        if Session.hasPinCode {
            return Session.isPinValidated ? .main : .pin(mode: .enterPin)
        } else {
            return .pin(mode: .createPin)
        }
    }
}

final class AppCoordinator: BaseCoordinator {
    private let router: Routable
    private let factory: CoordinatorFactoryProtocol
    
    init(router: Routable, factory: CoordinatorFactoryProtocol) {
        self.router = router
        self.factory = factory
    }
    
    private var instructor: LaunchInstructor {
        return LaunchInstructor.setup()
    }
}

//MARK: - Coordinatable
extension AppCoordinator: Coordinatable {
    func start() {
        switch instructor {
        case .authentication(let authMode):
            performAuthenticationFlow(mode: authMode)
        case .main:
            performMainFlow()
        case .pin(let pinMode):
            performPinFlow(mode: pinMode)
        }
    }
}

//MARK: - Flows Assembly
private extension AppCoordinator {
    func performAuthenticationFlow(mode: AuthFlowMode) {
        let coordinator = factory.makeAuthenticationCoordinator(router: router, mode: mode)
        coordinator.finishFlow
            .first()
            .sink { [weak self, weak coordinator] authResult in
                self?.removeChildCoordinator(coordinator)
                self?.start()
            }
            .store(in: &cancellables)
        
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func performPinFlow(mode: PinFlowMode) {
        let coordinator = factory.makePinCoordinator(router: router, mode: mode)
        coordinator.finishFlow
            .first()
            .sink { [weak self] in
                self?.removeChildCoordinator(coordinator)
                self?.start()
            }
            .store(in: &cancellables)
        
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func performMainFlow() {
        let coordinator = factory.makeMainCoordinator(router: router)
        coordinator.finishFlow
            .first()
            .sink { [weak self] in
                self?.removeChildCoordinator(coordinator)
                self?.start()
            }
            .store(in: &cancellables)
        
        addChildCoordinator(coordinator)
        coordinator.start()
    }
}
