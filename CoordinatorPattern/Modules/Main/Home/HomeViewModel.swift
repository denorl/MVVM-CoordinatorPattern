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
    
    private let showAccountDetaisSubject = PassthroughSubject<Void, Never>()
    var showAccountDetais: AnyPublisher<Void, Never> {
        showAccountDetaisSubject.eraseToAnyPublisher()
    }
    
    func accountDetailsTapped() {
        showAccountDetaisSubject.send()
    }
    
}

//MARK: - CoordinatableViewModel
extension HomeViewModel: CoordinatableViewModel {
    var onFinish: AnyPublisher<Void, Never> {
        finishHomeFlowSubject.eraseToAnyPublisher()
    }
}

