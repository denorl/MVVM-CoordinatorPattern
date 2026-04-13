//
//  MainViewModel.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 12/4/26.
//

import Foundation
import Combine

final class MainViewModel {
    private let onFinishSubject = PassthroughSubject<Void, Never>()
    
    private let authManager: AuthenticationManagerProtocol
    
    init(authManager: AuthenticationManagerProtocol) {
        self.authManager = authManager
    }
    
    func signOutTapped() {
        Task {
            do {
                try await authManager.signOut()
                onFinishSubject.send()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}

extension MainViewModel: CoordinatableViewModel {
    var onFinish: AnyPublisher<Void, Never> {
        onFinishSubject.eraseToAnyPublisher()
    }
}
