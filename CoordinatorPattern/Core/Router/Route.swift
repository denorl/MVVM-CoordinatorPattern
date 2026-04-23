//
//  Route.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 16/4/26.
//

enum Route {
    enum Authentication {
        
        case login
        
        enum Registration {
            case registrationLogin
            case registrationPassword
        }
    }

    enum Pin {
        case enterPin
        case createPin
        case confirmPin
        case forgotPin
    }
}
