//
//  EnterPinViewModel.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 11/4/26.
//

import Combine

final class EnterPinViewModel: PinBaseViewModel {
    
    override init() {
        super.init()
        instructionText = "Enter your PIN code"
        bindPinEntry()
    }
    
}

//MARK: - Private Methods
private extension EnterPinViewModel {
    func bindPinEntry() {
        onPinEntered
            .sink { [weak self] digits in
                self?.validatePin(digits)
            }
            .store(in: &cancellables)
    }
    
    func validatePin(_ digits: [Int]) {
        if PinManager.validatePin(digits) {
            Session.isPinValidated = true
            onFinishSubject.send()
        } else {
            errorMessage = "Incorrect PIN. Try again."
            resetPin()
        }
    }
}
