//
//  AppCoordinatorLaunchTests.swift
//  CoordinatorPatternTests
//
//  Created on 27/4/26.
//

import Testing
import Combine
import UIKit
@testable import CoordinatorPattern

// MARK: - Mock Session

final class MockSession: SessionProvider {
    var isAuthorized: Bool
    var hasPinCode: Bool
    var isPinCodeOwnedByCurrentUser: Bool
    var isFullAccessGranted: Bool
    
    init(
        isAuthorized: Bool = false,
        hasPinCode: Bool = false,
        isPinCodeOwnedByCurrentUser: Bool = false,
        isFullAccessGranted: Bool = false
    ) {
        self.isAuthorized = isAuthorized
        self.hasPinCode = hasPinCode
        self.isPinCodeOwnedByCurrentUser = isPinCodeOwnedByCurrentUser
        self.isFullAccessGranted = isFullAccessGranted
    }
    
    func end() {}
}

// MARK: - Stub Coordinators

private final class StubAuthCoordinator: BaseCoordinator, AuthenticationCoordinatorOutput {
    private let subject = PassthroughSubject<Void, Never>()
    var finishFlow: AnyPublisher<Void, Never> { subject.eraseToAnyPublisher() }
}

private final class StubPinCoordinator: BaseCoordinator, PinCoordinatorOutput {
    private let subject = PassthroughSubject<Void, Never>()
    var finishPinFlow: AnyPublisher<Void, Never> { subject.eraseToAnyPublisher() }
}

private final class StubMainCoordinator: BaseCoordinator, MainCoordinatorOutput {
    private let subject = PassthroughSubject<Void, Never>()
    var finishFlow: AnyPublisher<Void, Never> { subject.eraseToAnyPublisher() }
}

// MARK: - Stub Factory

private final class StubAppCoordinatorFactory: AppCoordinatorFactoryProtocol {
    
    private(set) var madeAuthenticationCoordinator = false
    private(set) var madePinCoordinator = false
    private(set) var madeMainCoordinator = false
    private(set) var lastPinRoute: Route.Pin?
    
    func makeAuthenticationCoordinator(router: Routable) -> Coordinatable & AuthenticationCoordinatorOutput {
        madeAuthenticationCoordinator = true
        return StubAuthCoordinator()
    }
    
    func makePinCoordinator(router: Routable, route: Route.Pin) -> Coordinatable & PinCoordinatorOutput {
        madePinCoordinator = true
        lastPinRoute = route
        return StubPinCoordinator()
    }
    
    func makeMainCoordinator(router: Routable) -> Coordinatable & MainCoordinatorOutput {
        madeMainCoordinator = true
        return StubMainCoordinator()
    }
}

// MARK: - Stub Router

private final class StubRouter: Routable {
    
    var toPresent: UIViewController? { nil }
    var popPublisher: AnyPublisher<UIViewController, Never> {
        Empty().eraseToAnyPublisher()
    }
    
    func assignRootController() {}
    func present(_ module: Presentable?, animated: Bool) {}
    func presentAlert(config: AlertConfiguration, animated: Bool) {}
    func push(_ module: (any Presentable)?, animated: Bool, hideBackButton: Bool) {}
    func setRootModule(_ module: Presentable?, hideNavBar: Bool) {}
    func popModule(animated: Bool) {}
    func dismissModule(animated: Bool, completion: (() -> Void)?) {}
}

// MARK: - Test Suite

@Suite("AppCoordinator Launch Flow")
struct AppCoordinatorLaunchTests {
    
    private func makeSUT(
        session: MockSession
    ) -> (sut: AppCoordinator, factory: StubAppCoordinatorFactory) {
        let factory = StubAppCoordinatorFactory()
        let router = StubRouter()
        let sut = AppCoordinator(router: router, factory: factory, session: session)
        return (sut, factory)
    }
    
    // MARK: - Authentication Flow
    
    @Test("Unauthorized user launches authentication flow")
    func unauthorizedUser_startsAuthenticationFlow() {
        let session = MockSession(isAuthorized: false)
        let (sut, factory) = makeSUT(session: session)
        
        sut.start()
        
        #expect(factory.madeAuthenticationCoordinator == true)
        #expect(factory.madePinCoordinator == false)
        #expect(factory.madeMainCoordinator == false)
    }
    
    // MARK: - Pin Creation Flow
    
    @Test("Authorized user without PIN code launches create-pin flow")
    func authorizedNoPinCode_startsCreatePinFlow() {
        let session = MockSession(
            isAuthorized: true,
            hasPinCode: false,
            isPinCodeOwnedByCurrentUser: false
        )
        let (sut, factory) = makeSUT(session: session)
        
        sut.start()
        
        #expect(factory.madePinCoordinator == true)
        #expect(factory.lastPinRoute == .createPin)
        #expect(factory.madeAuthenticationCoordinator == false)
        #expect(factory.madeMainCoordinator == false)
    }
    
    @Test("Authorized user with PIN owned by different user launches create-pin flow")
    func authorizedPinOwnedByOtherUser_startsCreatePinFlow() {
        let session = MockSession(
            isAuthorized: true,
            hasPinCode: true,
            isPinCodeOwnedByCurrentUser: false
        )
        let (sut, factory) = makeSUT(session: session)
        
        sut.start()
        
        #expect(factory.madePinCoordinator == true)
        #expect(factory.lastPinRoute == .createPin)
        #expect(factory.madeAuthenticationCoordinator == false)
        #expect(factory.madeMainCoordinator == false)
    }
    
    // MARK: - Pin Entry Flow
    
    @Test("Authorized user with own PIN but no full access launches enter-pin flow")
    func authorizedWithOwnPin_notUnlocked_startsEnterPinFlow() {
        let session = MockSession(
            isAuthorized: true,
            hasPinCode: true,
            isPinCodeOwnedByCurrentUser: true,
            isFullAccessGranted: false
        )
        let (sut, factory) = makeSUT(session: session)
        
        sut.start()
        
        #expect(factory.madePinCoordinator == true)
        #expect(factory.lastPinRoute == .enterPin)
        #expect(factory.madeAuthenticationCoordinator == false)
        #expect(factory.madeMainCoordinator == false)
    }
    
    // MARK: - Main Flow
    
    @Test("Fully authenticated and unlocked user launches main flow")
    func fullyAuthenticatedAndUnlocked_startsMainFlow() {
        let session = MockSession(
            isAuthorized: true,
            hasPinCode: true,
            isPinCodeOwnedByCurrentUser: true,
            isFullAccessGranted: true
        )
        let (sut, factory) = makeSUT(session: session)
        
        sut.start()
        
        #expect(factory.madeMainCoordinator == true)
        #expect(factory.madeAuthenticationCoordinator == false)
        #expect(factory.madePinCoordinator == false)
    }
    
    // MARK: - Edge Cases
    
    @Test("Authorized with PIN but no ownership and full access granted still routes to create-pin")
    func authorizedWithPinNoOwnership_fullAccessTrue_stillCreatePin() {
        let session = MockSession(
            isAuthorized: true,
            hasPinCode: true,
            isPinCodeOwnedByCurrentUser: false,
            isFullAccessGranted: true
        )
        let (sut, factory) = makeSUT(session: session)
        
        sut.start()
        
        #expect(factory.madePinCoordinator == true)
        #expect(factory.lastPinRoute == .createPin)
    }
    
    @Test("Authorized without PIN but full access granted still routes to create-pin")
    func authorizedNoPinCode_fullAccessTrue_stillCreatePin() {
        let session = MockSession(
            isAuthorized: true,
            hasPinCode: false,
            isPinCodeOwnedByCurrentUser: true,
            isFullAccessGranted: true
        )
        let (sut, factory) = makeSUT(session: session)
        
        sut.start()
        
        #expect(factory.madePinCoordinator == true)
        #expect(factory.lastPinRoute == .createPin)
    }
    
    // MARK: - Child Coordinator Management
    
    @Test("start() adds the created coordinator as a child")
    func start_addsChildCoordinator() {
        let session = MockSession(isAuthorized: false)
        let (sut, _) = makeSUT(session: session)
        
        sut.start()
        
        #expect(sut.childCoordinators.count == 1)
    }
}
