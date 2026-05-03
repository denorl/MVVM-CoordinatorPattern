//
//  ProfileViewModel.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 1/5/26.
//

import Combine

final class ProfileViewModel {
    
    //MARK: - Finish profile flow publisher
    private let finishProfileFlowSubject = PassthroughSubject<Void, Never>()
    
}

//MARK: - CoordinatableViewModel
extension ProfileViewModel: CoordinatableViewModel {
    var onFinish: AnyPublisher<Void, Never> {
        finishProfileFlowSubject.eraseToAnyPublisher()
    }
}
