import UIKit

enum AppLayout {
    
    // MARK: - Scaling Constants
    private static let referenceHeight: CGFloat = 852.0
    private static let currentHeight: CGFloat = UIScreen.main.bounds.height
    
    /// A multiplier representing the ratio between the current device and the design reference.
    static var scaleFactor: CGFloat {
        return currentHeight / referenceHeight
    }
    
    // MARK: - Core Scaling Logic
    
    /// Scales a base value and clamps it within a safe range to prevent UI distortion on extreme screen sizes.
    ///
    /// - Parameters:
    ///   - base: The ideal point value provided in the design mocks.
    ///   - minVal: The absolute minimum allowed (useful for maintaining accessible touch targets, e.g., 44pt).
    ///   - maxVal: The absolute maximum allowed to prevent elements from appearing oversized on large devices.
    /// - Returns: A responsive CGFloat value adjusted for the current device scale.
    private static func clampedHeight(_ base: CGFloat, minVal: CGFloat, maxVal: CGFloat) -> CGFloat {
        let scaled = base * scaleFactor
        return min(max(scaled, minVal), maxVal)
    }
}

// MARK: - Component Dimensions
extension AppLayout {
    
    /// The responsive height for primary call-to-action buttons.
    /// Scaled from a base of 54pt, clamped between 48pt (Apple's minimum) and 64pt.
    static var buttonHeight: CGFloat {
        clampedHeight(54, minVal: 48, maxVal: 64)
    }
    
    /// The responsive height for text input fields.
    /// Scaled from a base of 50pt, clamped between 44pt and 60pt.
    static var inputHeight: CGFloat {
        clampedHeight(50, minVal: 44, maxVal: 60)
    }
    
    static let topScreenOffset: CGFloat = 80.scaled
    static let safeAreaTopOffset: CGFloat = 40.scaled
    static let horizontalInset: CGFloat = 20.scaled
    
    /// Standard horizontal padding for internal elements within a text field (e.g., icons, text).
    static let textFieldElementsPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
}

// MARK: - Spacing System
extension AppLayout {
    
    /// A semantic spacing scale based on an 8pt/4pt grid system.
    /// All values are automatically adjusted by the `scaleFactor`.
    enum Spacing {
        /// 4pt - Used for tightly coupled elements like a label and its validation hint.
        static let quark: CGFloat = 2.scaled
        
        /// 8pt - Tight spacing for related items such as a title and subtitle.
        static let tiny: CGFloat = 8.scaled
        
        /// 12pt - Compact spacing for internal card padding or list items.
        static let small: CGFloat = 12.scaled
        
        /// 16pt - Standard gutter spacing. Recommended for general stack view distribution.
        static let medium: CGFloat = 16.scaled
        
        /// 24pt - Significant spacing used to separate different logical sections.
        static let large: CGFloat = 24.scaled
        
        /// 32pt - Major layout break for separating distinct functional blocks.
        static let extraLarge: CGFloat = 32.scaled
        
        /// 48pt+ - Hero spacing used typically at the top of a view or before primary actions.
        static let huge: CGFloat = 48.scaled
    }
}

