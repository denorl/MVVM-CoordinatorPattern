//
//  MainFactoryProtocol.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 12/4/26.
//
import UIKit

protocol MainFactoryProtocol {
    func makeMainViewModel() -> MainViewModel
    func makeMainView(with viewModel: MainViewModel) -> UIViewController
}
