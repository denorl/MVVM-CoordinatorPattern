//
//  AppColor.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 7/4/26.
//
import UIKit

enum AppColor {
    case lightGray
    case themeBlue
    
    var color: UIColor {
        switch self {
        case .lightGray:
            return UIColor(hex: "#F3F4F8")
        case .themeBlue:
            return UIColor(hex: "#005AFE")
        }
    }
}
