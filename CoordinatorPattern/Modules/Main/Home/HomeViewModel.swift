//
//  MainViewModel.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 12/4/26.
//

import Foundation
import Combine

final class HomeViewModel {
    
    //MARK: - Finish home flow publisher
    private let finishHomeFlowSubject = PassthroughSubject<Void, Never>()
    
    private let showCurrencyRatesDetaisSubject = PassthroughSubject<Void, Never>()
    var showCurrencyRatesDetais: AnyPublisher<Void, Never> {
        showCurrencyRatesDetaisSubject.eraseToAnyPublisher()
    }
    
    func currencyRatesTapped() {
        showCurrencyRatesDetaisSubject.send()
    }
    
}

//MARK: - CoordinatableViewModel
extension HomeViewModel: CoordinatableViewModel {
    var onFinish: AnyPublisher<Void, Never> {
        finishHomeFlowSubject.eraseToAnyPublisher()
    }
}

