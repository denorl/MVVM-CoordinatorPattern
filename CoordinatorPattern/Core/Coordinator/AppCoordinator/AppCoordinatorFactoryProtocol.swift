//
//  CoordinatorFactoryProtocol.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//

protocol AppCoordinatorFactoryProtocol {
    func makeAuthenticationCoordinator(router: FullRoutable) -> Coordinatable & AuthenticationCoordinatorOutput
    func makePinCoordinator(router: NavigationRoutable, route: Route.Pin) -> Coordinatable & PinCoordinatorOutput
    func makeTabBarCoordinator(router: FullRoutable) -> Coordinatable & TabBarCoordinatorOutput
}
