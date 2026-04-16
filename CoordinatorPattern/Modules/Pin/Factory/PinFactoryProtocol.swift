//
//  PinFactoryProtocol.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 6/4/26.
//
import UIKit

protocol PinFactoryProtocol {
    func makeCreatePinScene() -> (vm: CreatePinViewModel, vc: UIViewController)
    func makeConfirmPinScene(firstPin: [Int]) -> (vm: ConfirmPinViewModel, vc: UIViewController)
    func makeEnterPinScene() -> (vm: EnterPinViewModel, vc: UIViewController)
}
