//
//  UILabel.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 4/5/26.
//

import UIKit

extension UILabel {
    func setBalanceText(_ totalText: String, largeFont: UIFont, smallFont: UIFont) {
        let attributedString = NSMutableAttributedString(string: totalText)
        
        let decimalSeparator = ","
        
        if let rangeOfDecimal = totalText.range(of: decimalSeparator) {
            let nsRangeOfDecimal = NSRange(rangeOfDecimal, in: totalText)
            
            let mainNumberRange = NSRange(location: 0, length: nsRangeOfDecimal.location)
            attributedString.addAttribute(.font,
                                        value: largeFont,
                                        range: mainNumberRange)
            
            let remainderRange = NSRange(location: nsRangeOfDecimal.location,
                                         length: totalText.count - nsRangeOfDecimal.location)
            attributedString.addAttribute(.font,
                                        value: smallFont,
                                        range: remainderRange)
        }
        
        self.attributedText = attributedString
    }
}
