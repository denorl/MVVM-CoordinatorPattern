//
//  CGFloat.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 21/4/26.
//

import Foundation

extension CGFloat {
    var scaled: CGFloat {
        self * AppLayout.scaleFactor
    }
}

extension Double {
    var scaled: CGFloat {
        CGFloat(self) * AppLayout.scaleFactor
    }
}

extension Int {
    var scaled: CGFloat {
        CGFloat(self) * AppLayout.scaleFactor
    }
}
