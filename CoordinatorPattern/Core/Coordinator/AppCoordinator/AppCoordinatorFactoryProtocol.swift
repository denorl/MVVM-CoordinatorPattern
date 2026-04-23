//
//  CoordinatorFactoryProtocol.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//

protocol AppCoordinatorFactoryProtocol {
    func makeAuthenticationCoordinator(router: Routable) -> Coordinatable & AuthenticationCoordinatorOutput
    func makePinCoordinator(router: Routable, route: Route.Pin) -> Coordinatable & PinCoordinatorOutput
    func makeMainCoordinator(router: Routable) -> Coordinatable & MainCoordinatorOutput
}
