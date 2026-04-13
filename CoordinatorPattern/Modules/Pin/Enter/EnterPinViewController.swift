//
//  EnterPinViewController.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 11/4/26.
//

import UIKit

final class EnterPinViewController: PinBaseViewController<EnterPinViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "PIN code"
    }
    
}
