//
//  PinBaseViewModel.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 11/4/26.
//

import Foundation
import Combine

class PinBaseViewModel {
    
    //MARK: - Constants
    let maxDigits = 6
    var cancellables = Set<AnyCancellable>()
    
    //MARK: - Finish Flow Publishers
    let onFinishSubject = PassthroughSubject<Void, Never>()
    
    //MARK: - Pin Entered Publisher
    private let onPinEnteredSubject = PassthroughSubject<[Int], Never>()
    var onPinEntered: AnyPublisher<[Int], Never> {
        onPinEnteredSubject.eraseToAnyPublisher()
    }
    
    //MARK: - Published Properties
    @Published private(set) var enteredDigits: [Int] = []
    @Published var errorMessage: String? = nil
    @Published var instructionText: String = ""
    
    //MARK: - Public Methods
    func digitTapped(_ digit: Int) {
        guard enteredDigits.count < maxDigits else { return }
        errorMessage = nil
        enteredDigits.append(digit)
        
        if enteredDigits.count == maxDigits {
            onPinEnteredSubject.send(enteredDigits)
        }
    }
    
    func backspaceTapped() {
        guard !enteredDigits.isEmpty else { return }
        errorMessage = nil
        enteredDigits.removeLast()
    }
    
    func resetPin() {
        enteredDigits = []
    }
}

//MARK: - CoordinatableViewModel
extension PinBaseViewModel: CoordinatableViewModel {
    var onFinish: AnyPublisher<Void, Never> {
        onFinishSubject.eraseToAnyPublisher()
    }
}
