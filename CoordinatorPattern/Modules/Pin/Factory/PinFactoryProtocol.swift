//
//  PinFactoryProtocol.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 6/4/26.
//
import UIKit

protocol PinFactoryProtocol {
    func makeCreatePinViewModel() -> CreatePinViewModel
    func makeCreatePinView(for viewModel: CreatePinViewModel) -> UIViewController
    
    func makeConfirmPinViewModel(firstPin: [Int]) -> ConfirmPinViewModel
    func makeConfirmPinView(for viewModel: ConfirmPinViewModel) -> UIViewController
    
    func makeEnterPinViewModel() -> EnterPinViewModel
    func makeEnterPinView(for viewModel: EnterPinViewModel) -> UIViewController
}
