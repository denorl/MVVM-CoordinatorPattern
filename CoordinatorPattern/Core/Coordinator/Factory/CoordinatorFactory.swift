//
//  CoordinatorFactory.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//

final class CoordinatorFactory {
    private let modulesFactory = ModulesFactory()
}

extension CoordinatorFactory: CoordinatorFactoryProtocol {
    func makeAuthenticationCoordinator(router: Routable, mode: AuthFlowMode) -> AuthenticationCoordinatorOutput & Coordinatable {
        return AuthenticationCoordinator(router: router, authFactory: modulesFactory, pinFactory: modulesFactory, mode: mode)
    }
    
    func makePinCoordinator(router: Routable, mode: PinFlowMode) -> Coordinatable & PinCoordinatorOutput {
        return PinCoordinator(router: router, factory: modulesFactory, mode: mode)
    }
    
    func makeMainCoordinator(router: Routable) -> Coordinatable & MainCoordinatorOutput {
        return MainCoordinator(router: router, factory: modulesFactory)
    }
}
