//
//  ConfirmPinViewModel.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 11/4/26.
//

import Combine

final class ConfirmPinViewModel: PinBaseViewModel {
    
    private let firstPin: [Int]
    
    init(firstPin: [Int]) {
        self.firstPin = firstPin
        super.init()
        instructionText = "Confirm your PIN code"
        bindPinEntry()
    }
    
}

//MARK: - Private Methods
private extension ConfirmPinViewModel {
    func bindPinEntry() {
        onPinEntered
            .sink { [weak self] digits in
                self?.validatePin(digits)
            }
            .store(in: &cancellables)
    }
    
    func validatePin(_ digits: [Int]) {
        if digits == firstPin {
            PinManager.savePin(digits)
            Session.shared.isFullAccessGranted = true
            onFinishSubject.send()
        } else {
            errorMessage = "PINs do not match. Try again."
            resetPin()
        }
    }
}
