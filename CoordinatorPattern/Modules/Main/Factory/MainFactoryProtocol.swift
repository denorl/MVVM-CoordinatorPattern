//
//  MainFactoryProtocol.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 12/4/26.
//

import UIKit

protocol MainFactoryProtocol {
    func makeMainModule() -> (vm: MainViewModel, vc: UIViewController)
}
