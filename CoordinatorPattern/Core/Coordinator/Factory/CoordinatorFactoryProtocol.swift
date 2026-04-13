//
//  CoordinatorFactoryProtocol.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//

protocol CoordinatorFactoryProtocol {
    func makeAuthenticationCoordinator(router: Routable, mode: AuthFlowMode) -> Coordinatable & AuthenticationCoordinatorOutput
    func makePinCoordinator(router: Routable, mode: PinFlowMode) -> Coordinatable & PinCoordinatorOutput
    func makeMainCoordinator(router: Routable) -> Coordinatable & MainCoordinatorOutput
}
