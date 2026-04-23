//
//  Theme.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 21/4/26.
//

import UIKit

enum Theme {
    
    enum Color {
        
        case themeBlue(opacity: CGFloat = 1)
        case themeGreen
        case themeRed
        case themeLightGray
        
        case themeBackground
        case secondaryBackground
        case surface
        
        case label
        case secondaryLabel
        case primaryButtonText(opacity: CGFloat = 1)
        
        case separator
        
        var color: UIColor {
            
            return UIColor { traitCollection in
                let isDarkMode = traitCollection.userInterfaceStyle == .dark
                
                switch self {
                case .themeBlue(let opacity):
                    return isDarkMode ? UIColor(hex: "#2E7BFF").withAlphaComponent(opacity) : UIColor(hex: "#005AFE").withAlphaComponent(opacity)
                case .themeRed:
                    return UIColor(hex: "#FF0000")
                case .themeGreen:
                    return UIColor(hex: "#32CD32")
                case .themeLightGray:
                    return UIColor(hex: "#D3D3D3")
                case .themeBackground:
                    return isDarkMode ? UIColor(hex: "#121212") : UIColor(hex: "#FFFFFF")
                    
                case .secondaryBackground:
                    return isDarkMode ? UIColor(hex: "#1E1E1E") : UIColor(hex: "#F3F4F8")
                    
                case .surface:
                    return isDarkMode ? UIColor(hex: "#252525") : UIColor(hex: "#FFFFFF")
                    
                case .label:
                    return isDarkMode ? UIColor(hex: "#FFFFFF") : UIColor(hex: "#000000")
                    
                case .secondaryLabel:
                    return isDarkMode ? UIColor(hex: "#8E8E93") : UIColor(hex: "#6C727F")
                    
                case .primaryButtonText(let opacity):
                    return UIColor(hex: "#FFFFFF").withAlphaComponent(opacity)
                    
                case .separator:
                    return isDarkMode ? UIColor(hex: "#38383A") : UIColor(hex: "#E5E5EA")
                }
            }
            
        }
        
        var cgColor: CGColor { color.cgColor }
        
    }
    
}

//MARK: - Fonts
extension Theme {
    enum Font {
        /// Creates a scaled system font
        static func system(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
            return UIFont.systemFont(ofSize: size.scaled, weight: weight)
        }
    }
}

// MARK: - Semantic Typography
extension Theme.Font {
    // MARK: - Large Titles & Headers
    static var largeTitle: UIFont { system(size: 34, weight: .bold) }
    static var title: UIFont      { system(size: 28, weight: .bold) }
    static var title2: UIFont     { system(size: 22, weight: .bold) }
    static var title3: UIFont     { system(size: 20, weight: .semibold) }
    
    // MARK: - Body & Content
    static var headline: UIFont   { system(size: 17, weight: .semibold) }
    static var body: UIFont       { system(size: 17, weight: .regular) }
    static var callout: UIFont    { system(size: 16, weight: .regular) }
    static var subheadline: UIFont { system(size: 15, weight: .regular) }
    
    // MARK: - Small Text & Metadata
    static var footnote: UIFont   { system(size: 13, weight: .regular) }
    static var caption: UIFont    { system(size: 12, weight: .regular) }
    static var caption2: UIFont   { system(size: 11, weight: .regular) }
    
    // MARK: - Other role-specific fonts
    /// Text inside buttons
    static var button: UIFont     { system(size: 16, weight: .semibold) }
    
    /// Input field text
    static var input: UIFont      { system(size: 16, weight: .regular) }
}

extension Theme {
    enum Image {
        case logo
        
        var imageName: String {
            switch self {
            case .logo:
                "LibertyLogo"
            }
        }
    }

}
