//
//  CoordinatableViewModel.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 6/4/26.
//

import Combine

protocol CoordinatableViewModel {
    var onFinish: AnyPublisher<Void, Never> { get }
}
