//
//  AuthenticationViewModel.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 7/4/26.
//
import Foundation
import Combine

enum AuthMethod {
    case phone
    case document
    
    var fieldInputType: AuthTextFieldInputType {
        switch self {
        case .phone: .phone
        case .document: .document
        }
    }
    
    func createIdentifier(from input: String) -> AuthIdentifier {
        switch self {
        case .phone: return .phone(input)
        case .document: return .document(input)
        }
    }
}

class AuthenticationViewModel {
    
    //MARK: - Finish Flow publisher
    let onFinishSubject = PassthroughSubject<Void, Never>()
    
    //MARK: - Published Properties
    @Published var selectedAuthMethod: AuthMethod = .document
    @Published var isButtonEnabled: Bool = false
    
    func bindContinueButtonState() {}
    func continueButtonTapped() {}
}

//MARK: - CoordinatableViewModel
extension AuthenticationViewModel: CoordinatableViewModel {
    var onFinish: AnyPublisher<Void, Never> {
        onFinishSubject.eraseToAnyPublisher()
    }
}

