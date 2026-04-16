//
//  FlowMode.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 16/4/26.
//

#warning("change methods that call it")
enum Route {
    enum Authentication {
        case login
        case registrationLogin
        case registrationPassword
    }

    enum Pin {
        case enterPin
        case createPin
    }
}
