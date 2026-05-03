//
//  SettingsFactory.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 1/5/26.
//

import UIKit

protocol SettingsFactoryProtocol {
    func makeSettingsScene() -> (vm: SettingsViewModel, vc: UIViewController)
}

