//
//  BaseCoordinator.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/4/26.
//

import Foundation
import Combine

protocol Coordinatable: AnyObject {
    func start()
}

protocol CoordinatableViewModel {
    var onFinish: AnyPublisher<Void, Never> { get }
}

class BaseCoordinator: Coordinatable {
    private(set) var childCoordinators: [Coordinatable] = []
    var cancellables = Set<AnyCancellable>()
    
    func start() {}
    
    func addChildCoordinator(_ coordinator: Coordinatable) {
        guard !childCoordinators.contains(where: { $0 === coordinator} ) else { return }
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinatable?) {
        guard let coordinator = coordinator else { return}
        childCoordinators.removeAll(where: { $0 === coordinator})
    }
    
    func bindFinish(from viewModel: CoordinatableViewModel, action: @escaping () -> Void) {
        viewModel.onFinish
            .first()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard  self != nil else { return }
                action()
            }
            .store(in: &cancellables)
    }
}
