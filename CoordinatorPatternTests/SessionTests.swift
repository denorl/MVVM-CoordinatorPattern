//
//  SessionTests.swift
//  CoordinatorPatternTests
//
//  Created on 27/4/26.
//

import Testing
import Foundation
@testable import CoordinatorPattern

//MARK: - MockPinManager

private final class MockPinManager: PinManagerProtocol {
    
    // MARK: - Spies (Tracking calls)
    var savePinCalled = false
    var removePinCalled = false
    var validatePinCalled = false
    var lastSavedUserId: String?
    var lastSavedDigits: [Int]?
    
    // MARK: - Stubs (Controlling returns)
    var isPinSetStub: Bool = false
    var isPinOwnedStub: Bool = false
    var validatePinErrorStub: Error?
    
    // MARK: - PinManagerProtocol Implementation
    var isPinSet: Bool {
        return isPinSetStub
    }
    
    func isPinOwned(by userId: String) -> Bool {
        return isPinOwnedStub
    }
    
    func savePin(_ digits: [Int], for userId: String) throws {
        savePinCalled = true
        lastSavedDigits = digits
        lastSavedUserId = userId
        
        isPinSetStub = true
    }
    
    func validatePin(_ digits: [Int]) throws {
        validatePinCalled = true
        if let error = validatePinErrorStub {
            throw error
        }
    }
    
    func removePin() throws {
        removePinCalled = true
        isPinSetStub = false
        isPinOwnedStub = false
    }
}

// MARK: - Test Suite

@Suite("Session Logic", .serialized)
struct SessionTests {
    
    // MARK: - Helpers
    private func makeSUT(
        pinManager: MockPinManager = MockPinManager(),
        configure: (() -> Void)? = nil
    ) -> (sut: Session, pinManager: MockPinManager) {
        cleanUserDefaults()
        configure?()
        let sut = Session(pinManager: pinManager)
        return (sut, pinManager)
    }
    
    private func cleanUserDefaults() {
        UserDefaultsStorage.token = nil
        UserDefaultsStorage.currentUserIdentifier = nil
        // Reset isFirstAccess to its property-wrapper default (true)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isFirstAccess.key)
    }
    
    // MARK: - isAuthorized
    
    @Test("isAuthorized returns false when no token is stored")
    func isAuthorized_noToken_returnsFalse() {
        let (sut, _) = makeSUT {
            UserDefaultsStorage.isFirstAccess = false
        }
        
        #expect(sut.isAuthorized == false)
    }
    
    @Test("isAuthorized returns true when a token is stored")
    func isAuthorized_withToken_returnsTrue() {
        let (sut, _) = makeSUT {
            UserDefaultsStorage.isFirstAccess = false
            UserDefaultsStorage.token = "some-jwt-token"
        }
        
        #expect(sut.isAuthorized == true)
    }
    
    // MARK: - hasPinCode
    
    @Test("hasPinCode returns false when PinManager reports no pin")
    func hasPinCode_noPinSet_returnsFalse() {
        let pinManager = MockPinManager()
        pinManager.isPinSetStub = false
        let (sut, _) = makeSUT(pinManager: pinManager) {
            UserDefaultsStorage.isFirstAccess = false
        }
        
        #expect(sut.hasPinCode == false)
    }
    
    @Test("hasPinCode returns true when PinManager reports pin is set")
    func hasPinCode_pinSet_returnsTrue() {
        let pinManager = MockPinManager()
        pinManager.isPinSetStub = true
        let (sut, _) = makeSUT(pinManager: pinManager) {
            UserDefaultsStorage.isFirstAccess = false
        }
        
        #expect(sut.hasPinCode == true)
    }
    
    // MARK: - isPinCodeOwnedByCurrentUser
    
    @Test("isPinCodeOwnedByCurrentUser returns false when no user identifier is stored")
    func isPinOwned_noUserId_returnsFalse() {
        let pinManager = MockPinManager()
        pinManager.isPinOwnedStub = true
        let (sut, _) = makeSUT(pinManager: pinManager) {
            UserDefaultsStorage.isFirstAccess = false
        }
        
        #expect(sut.isPinCodeOwnedByCurrentUser == false)
    }
    
    @Test("isPinCodeOwnedByCurrentUser returns false and calls removePin() when PinManager says pin is set but not owned")
    func isPinOwned_pinNotOwned_returnsFalse() {
        let pinManager = MockPinManager()
        pinManager.isPinOwnedStub = false
        pinManager.isPinSetStub = true
        let (sut, _) = makeSUT(pinManager: pinManager) {
            UserDefaultsStorage.isFirstAccess = false
            UserDefaultsStorage.currentUserIdentifier = "user-42"
        }
        
        #expect(sut.isPinCodeOwnedByCurrentUser == false)
        #expect(pinManager.removePinCalled == true)
    }
    
    @Test("isPinCodeOwnedByCurrentUser returns true when user id exists and PinManager confirms ownership")
    func isPinOwned_pinOwned_returnsTrue() {
        let pinManager = MockPinManager()
        pinManager.isPinOwnedStub = true
        let (sut, _) = makeSUT(pinManager: pinManager) {
            UserDefaultsStorage.isFirstAccess = false
            UserDefaultsStorage.currentUserIdentifier = "user-42"
        }
        
        #expect(sut.isPinCodeOwnedByCurrentUser == true)
    }
    
    // MARK: - isFullAccessGranted
    
    @Test("isFullAccessGranted remains false when set to true but not authorized")
    func isFullAccessGranted_notAuthorized_returnsFalse() {
        let pinManager = MockPinManager()
        pinManager.isPinSetStub = true
        let (sut, _) = makeSUT(pinManager: pinManager) {
            UserDefaultsStorage.isFirstAccess = false
        }
        
        sut.isFullAccessGranted = true
        
        #expect(sut.isFullAccessGranted == false)
    }
    
    @Test("isFullAccessGranted remains false when set to true but no pin code")
    func isFullAccessGranted_noPinCode_returnsFalse() {
        let pinManager = MockPinManager()
        pinManager.isPinSetStub = false
        let (sut, _) = makeSUT(pinManager: pinManager) {
            UserDefaultsStorage.isFirstAccess = false
            UserDefaultsStorage.token = "token"
        }
        
        sut.isFullAccessGranted = true
        
        #expect(sut.isFullAccessGranted == false)
    }
    
    // MARK: - end()
    
    @Test("end() clears token, user identifier and removes PIN")
    func end_clearsAllSessionData() {
        let pinManager = MockPinManager()
        pinManager.isPinSetStub = true
        let (sut, pm) = makeSUT(pinManager: pinManager) {
            UserDefaultsStorage.isFirstAccess = false
            UserDefaultsStorage.token = "some-token"
            UserDefaultsStorage.currentUserIdentifier = "user-99"
        }
        
        sut.end()
        
        #expect(UserDefaultsStorage.token == nil)
        #expect(UserDefaultsStorage.currentUserIdentifier == nil)
        #expect(pm.removePinCalled == true)
    }
    
    @Test("end() makes session unauthorized")
    func end_makesSessionUnauthorized() {
        let (sut, _) = makeSUT {
            UserDefaultsStorage.isFirstAccess = false
            UserDefaultsStorage.token = "abc"
        }
        
        #expect(sut.isAuthorized == true)
        sut.end()
        #expect(sut.isAuthorized == false)
    }
    
    // MARK: - First Launch Cleanup
    
    @Test("First launch cleanup removes PIN on first access")
    func firstLaunch_removesPin() {
        let pinManager = MockPinManager()
        pinManager.isPinSetStub = true
        
        let (_, pm) = makeSUT(pinManager: pinManager)
        
        #expect(pm.removePinCalled == true)
    }
    
    @Test("Subsequent launches do not trigger cleanup")
    func subsequentLaunch_doesNotRemovePin() {
        let pinManager = MockPinManager()
        
        let (_, pm) = makeSUT(pinManager: pinManager) {
            UserDefaultsStorage.isFirstAccess = false
        }
        
        #expect(pm.removePinCalled == false)
    }
}
