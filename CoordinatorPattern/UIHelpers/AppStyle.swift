//
//  AppStyle.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 21/4/26.
//

import UIKit

enum AppStyle {
    
    enum Pin {
        static let maxDigits = 6
        static let dotSize: CGFloat = 14.scaled
        static let dotSpacing: CGFloat = 16.scaled
        static let shakeAnimationDuration: TimeInterval = 0.4
        
        static let inactiveColor: UIColor = Theme.Color.themeLightGray.color
        static let activeColor: UIColor = Theme.Color.themeBlue().color
        
        static let headerTopOffset: CGFloat = 80.scaled
        
        static let pinPadButtonHeight = 72.scaled
        static var pinPadbottomOffset: CGFloat { 60.scaled }
        static var pinPadHorizontalInset: CGFloat { 35.scaled }
    }
    
    enum PrimaryButton {
        static let height = AppLayout.buttonHeight
        static let cornerRadius = 12.scaled
        static let font = Theme.Font.button
    }
    
    enum AuthTextField {
        static let height = AppLayout.inputHeight
        static let elementsPadding = AppLayout.textFieldElementsPadding
        static let cornerRadius = 12.scaled
        static let font = Theme.Font.input
        static let backgroundColor = Theme.Color.secondaryBackground.color
    }
    
}
