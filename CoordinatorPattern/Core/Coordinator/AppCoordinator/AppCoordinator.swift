//
//  AppCoordinator.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//

import Combine

fileprivate enum LaunchInstructor {
    case authentication
    case main
    case pin(mode: Route.Pin)
    
    static func resolve(from session: SessionProvider) -> LaunchInstructor {
        guard session.isAuthorized else { return .authentication }
        guard session.hasPinCode && session.isPinCodeOwnedByCurrentUser else { return .pin(mode: .createPin) }
        return session.isFullAccessGranted ? .main : .pin(mode: .enterPin)
    }
}

final class AppCoordinator: BaseCoordinator {
    
    private let router: Routable
    private let factory: AppCoordinatorFactoryProtocol
    private var session: SessionProvider
    
    init(router: Routable, factory: AppCoordinatorFactoryProtocol, session: SessionProvider) {
        self.router = router
        self.factory = factory
        self.session = session
    }
    
    private var instructor: LaunchInstructor {
        return LaunchInstructor.resolve(from: session)
    }
    
    override func start() {
        switch instructor {
        case .authentication:
            performAuthenticationFlow()
        case .main:
            performMainFlow()
        case .pin(let pinRoute):
            performPinFlow(for: pinRoute)
        }
    }
    
}

//MARK: - Flows Assembly
private extension AppCoordinator {
    
    func performAuthenticationFlow() {
        let coordinator = factory.makeAuthenticationCoordinator(router: router)
        coordinator.finishFlow
            .first()
            .sink { [weak self, weak coordinator] in
                self?.removeChildCoordinator(coordinator)
                self?.start()
            }
            .store(in: &cancellables)
        
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func performMainFlow() {
        let coordinator = factory.makeTabBarCoordinator(router: router)
        
        coordinator.finishFlow
            .first()
            .sink { [weak self] finishReason in
                self?.removeChildCoordinator(coordinator)
                self?.handleMainFlowFinish(finishReason)
                self?.start()
            }
            .store(in: &cancellables)
        
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func performPinFlow(for route: Route.Pin) {
        let coordinator = factory.makePinCoordinator(router: router, route: route)
        
        coordinator.finishPinFlow
            .first()
            .sink { [weak self] in
                self?.removeChildCoordinator(coordinator)
                self?.session.isFullAccessGranted = true
                self?.start()
            }
            .store(in: &cancellables)
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func handleMainFlowFinish(_ finishReason: TabFlow.TabFlowFinishReason) {
        switch finishReason {
        case .signOut:
            self.session.end()
        }
    }

}
