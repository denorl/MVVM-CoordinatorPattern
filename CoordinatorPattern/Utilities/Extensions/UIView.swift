//
//  UIView.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 21/4/26.
//

import UIKit

extension UIView {
    enum TransitionDirection {
        case forward, backward
        
        var subtype: CATransitionSubtype {
            self == .forward ? .fromRight : .fromLeft
        }
    }

    func slideTransition(duration: CFTimeInterval = 0.3, direction: TransitionDirection) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = .push
        transition.subtype = direction.subtype
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        self.layer.add(transition, forKey: kCATransition)
    }
}

extension UIView {
    var isKeyboardActive: Bool {
        return keyboardLayoutGuide.layoutFrame.height > safeAreaInsets.bottom
    }
}
