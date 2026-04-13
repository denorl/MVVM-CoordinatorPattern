//
//  ThemeImage.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 7/4/26.
//

enum ThemeImage {
    case logo
    
    var imageName: String {
        switch self {
        case .logo:
            "LibertyLogo"
        }
    }
}
