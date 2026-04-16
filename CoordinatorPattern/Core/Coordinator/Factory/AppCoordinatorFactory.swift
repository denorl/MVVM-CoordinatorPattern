//
//  CoordinatorFactory.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//

#warning("make app coordinator factory")

final class AppCoordinatorFactory {
    private let modulesFactory = ModulesFactory()
}

extension AppCoordinatorFactory: AppCoordinatorFactoryProtocol {
    func makeAuthenticationCoordinator(router: Routable) -> AuthenticationCoordinatorOutput & Coordinatable {
        return AuthenticationCoordinator(router: router, authFactory: modulesFactory)
    }
    
    func makePinCoordinator(router: Routable, route: Route.Pin) -> Coordinatable & PinCoordinatorOutput {
        return PinCoordinator(router: router, factory: modulesFactory, route: route)
    }
    
    func makeMainCoordinator(router: Routable) -> Coordinatable & MainCoordinatorOutput {
        return MainCoordinator(router: router, factory: modulesFactory)
    }
}
