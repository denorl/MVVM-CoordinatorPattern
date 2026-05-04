//
//  CoordinatorFactory.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//


final class AppCoordinatorFactory {
    private let modulesFactory = ModulesFactory()
}

extension AppCoordinatorFactory: AppCoordinatorFactoryProtocol {
    func makeAuthenticationCoordinator(router: FullRoutable) -> AuthenticationCoordinatorOutput & Coordinatable {
        return AuthenticationCoordinator(router: router, authFactory: modulesFactory)
    }
    
    func makePinCoordinator(router: NavigationRoutable, route: Route.Pin) -> Coordinatable & PinCoordinatorOutput {
        return PinCoordinator(router: router, route: route, factory: modulesFactory)
    }
    
    func makeTabBarCoordinator(router: FullRoutable) -> Coordinatable & TabBarCoordinatorOutput {
        return TabBarCoordinator(
            router: router, factory: TabBarCoordinatorFactory(modulesFactory: modulesFactory))
    }
}
