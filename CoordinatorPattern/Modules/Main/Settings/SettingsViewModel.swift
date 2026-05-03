//
//  SettingsViewModel.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 1/5/26.
//

import Foundation
import Combine

final class SettingsViewModel {
    
    private let authManager: AuthenticationManagerProtocol
    
    //MARK: - Finish settings flow publisher
    private let finishSettingsFlowPublisher = PassthroughSubject<Void, Never>()
    
    //MARK: - Published properties
    @Published private(set) var isLoading = false
    @Published private(set) var isSignOutButtonEnabled = true
    
    init(authManager: AuthenticationManagerProtocol) {
        self.authManager = authManager
    }
    
    func signOutTapped() {
        Task {
            do {
                isSignOutButtonEnabled = false
                try await authManager.signOut()
                finishSettingsFlowPublisher.send()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}

//MARK: - CoordinatableViewModel
extension SettingsViewModel: CoordinatableViewModel {
    var onFinish: AnyPublisher<Void, Never> {
        finishSettingsFlowPublisher.eraseToAnyPublisher()
    }
}

