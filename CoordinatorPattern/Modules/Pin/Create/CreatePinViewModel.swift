//
//  CreatePinViewModel.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 11/4/26.
//

import Combine

#warning("Switch between pin modes instead of having dofferent screens")
final class CreatePinViewModel: PinBaseViewModel {
    
    private let showConfirmPinSubject = PassthroughSubject<[Int], Never>()
    var showConfirmPin: AnyPublisher<[Int], Never> {
        showConfirmPinSubject.eraseToAnyPublisher()
    }
    
    override init() {
        super.init()
        instructionText = "Create your PIN code"
        bindPinEntry()
    }
    
}

//MARK: - Private Methods
private extension CreatePinViewModel {
    func bindPinEntry() {
        onPinEntered
            .sink { [weak self] digits in
                self?.showConfirmPinSubject.send(digits)
            }
            .store(in: &cancellables)
    }
}
