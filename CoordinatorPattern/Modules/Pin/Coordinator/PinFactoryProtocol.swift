//
//  PinFactoryProtocol.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 6/4/26.
//
import UIKit

protocol PinFactoryProtocol {
    func makePinScene(for route: Route.Pin) -> (vm: PinViewModel, vc: PinViewController)
}
