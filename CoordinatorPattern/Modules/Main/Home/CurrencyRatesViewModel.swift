//
//  CurrencyRatesViewModel.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 2/5/26.
//

import Combine

final class CurrencyRatesViewModel {
    
    private let finishFlowSubject = PassthroughSubject<Void, Never>()

}

extension CurrencyRatesViewModel: CoordinatableViewModel {
    var onFinish: AnyPublisher<Void, Never> {
        finishFlowSubject.eraseToAnyPublisher()
    }
}
