//
//  CurrencyRatesViewModel.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 2/5/26.
//

import Combine

final class AccountDetailsViewModel {
    
    private let finishFlowSubject = PassthroughSubject<Void, Never>()

}

extension AccountDetailsViewModel: CoordinatableViewModel {
    var onFinish: AnyPublisher<Void, Never> {
        finishFlowSubject.eraseToAnyPublisher()
    }
}
