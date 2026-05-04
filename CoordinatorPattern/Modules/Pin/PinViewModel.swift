//
//  PinBaseViewModel.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 11/4/26.
//

import Foundation
import Combine

final class PinViewModel {
    
    private let pinManager: PinManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    let maxDigits = AppStyle.Pin.maxDigits
    private var firstPin: [Int]?
    private var previousRoute: Route.Pin?
    
    //MARK: - Finish Flow Publishers
    let onFinishSubject = PassthroughSubject<Void, Never>()
    
    //MARK: - Show Confirm Pin Publisher
    private let showConfirmPinSubject = PassthroughSubject<[Int], Never>()
    var showConfirmPin: AnyPublisher<[Int], Never> {
        showConfirmPinSubject.eraseToAnyPublisher()
    }

    //MARK: - Published Properties
    @Published private(set) var route: Route.Pin
    @Published private(set) var enteredDigits: [Int] = []
    @Published var errorMessage: String? = nil
    @Published var instructionText: String = ""
    
    @Published private(set) var isBackButtonHidden = true
    @Published private(set) var isForgotPinButtonHidden = true
    
    //MARK: - Initializer
    init(route: Route.Pin, pinManager: PinManagerProtocol) {
        self.route = route
        self.pinManager = pinManager
        bindInstructionText(to: route)
    }
    
    //MARK: - Public Methods
    func digitTapped(_ digit: Int) {
        guard enteredDigits.count < maxDigits else { return }
        errorMessage = nil
        enteredDigits.append(digit)
        
        if enteredDigits.count == maxDigits {
            handleRouting()
            enteredDigits.removeAll()
        }
    }
    
    func backspaceTapped() {
        guard !enteredDigits.isEmpty else { return }
        errorMessage = nil
        enteredDigits.removeLast()
    }
    
    func backButtonTapped() {
        guard route == .confirmPin else { return }
        enteredDigits.removeAll()
        
        route = previousRoute == .forgotPin ? .forgotPin : .createPin
        previousRoute = nil
        firstPin = nil
    }
    
    func forgotPinButtonTapped() {
        try? pinManager.removePin()
        route = .forgotPin
    }
    
}

//MARK: - CoordinatableViewModel
extension PinViewModel: CoordinatableViewModel {
    var onFinish: AnyPublisher<Void, Never> {
        onFinishSubject.eraseToAnyPublisher()
    }
}

//MARK: - Instruction Text configuration
extension PinViewModel {
    func bindInstructionText(to route: Route.Pin) {
        $route
            .map { route in
                switch route {
                case .createPin: "Create PIN"
                case .confirmPin: "Confirm PIN"
                case .enterPin: "Enter PIN"
                case .forgotPin: "Enter new PIN"
                }
            }
            .assign(to: &$instructionText)
    }
}

//MARK: - Private Methods
private extension PinViewModel {
        
    func handleRouting() {
        previousRoute = route
        switch route {
        case .confirmPin, .enterPin:
            handlePinEntry()
        case .createPin, .forgotPin:
            firstPin = enteredDigits
            enteredDigits.removeAll()
            route = .confirmPin
        }
    }
    
    func handlePinEntry() {
        if route == .confirmPin {
            confirmPin()
        } else {
           validatePin()
        }
    }
    
    func confirmPin() {
        do {
            if enteredDigits == firstPin {
                guard let currentUserId = UserDefaultsStorage.currentUserIdentifier else { return }
                try pinManager.savePin(enteredDigits, for: currentUserId)
                onFinishSubject.send()
            }
        } catch {
            errorMessage = "An unexpected error occured. Please try again later"
        }
    }
    
    func validatePin() {
        do {
            try pinManager.validatePin(enteredDigits)
            onFinishSubject.send()
        } catch let error as PinValidationError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "An unexpected error occured. Please try again later"
        }
    }
    
}
