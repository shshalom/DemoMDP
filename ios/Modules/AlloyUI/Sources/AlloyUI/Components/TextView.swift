//
//  TextView.swift
//  AlloyUI - Autodesk Design System
//
//  Alloy TextView component - Consistent text display across all Autodesk products
//

import SwiftUI

/// Alloy TextView - Replaces vanilla SwiftUI Text()
///
/// Usage:
/// ```swift
/// Alloy.TextView("Hello World")
///     .textStyle(.headline)
///     .textColor(AlloyTextColor.primary)
/// ```
public struct AlloyTextView: View {
    private let text: String
    private var style: AlloyTextStyle = .body
    private var color: AlloyTextColor = .primary
    private var alignment: TextAlignment = .leading

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .font(style.font)
            .foregroundColor(color.color)
            .multilineTextAlignment(alignment)
            .accessibilityLabel(text)
    }

    /// Set the text style (headline, body, caption, etc.)
    public func textStyle(_ style: AlloyTextStyle) -> AlloyTextView {
        var view = self
        view.style = style
        return view
    }

    /// Set the text color from Alloy color palette
    public func textColor(_ color: AlloyTextColor) -> AlloyTextView {
        var view = self
        view.color = color
        return view
    }

    /// Set text alignment
    public func textAlignment(_ alignment: TextAlignment) -> AlloyTextView {
        var view = self
        view.alignment = alignment
        return view
    }
}

/// Alloy Text Styles - Consistent typography across Autodesk products
public enum AlloyTextStyle {
    case title
    case headline
    case subheadline
    case body
    case caption
    case footnote

    var font: Font {
        switch self {
        case .title: return .system(size: 28, weight: .bold, design: .default)
        case .headline: return .system(size: 22, weight: .semibold, design: .default)
        case .subheadline: return .system(size: 18, weight: .medium, design: .default)
        case .body: return .system(size: 16, weight: .regular, design: .default)
        case .caption: return .system(size: 14, weight: .regular, design: .default)
        case .footnote: return .system(size: 12, weight: .regular, design: .default)
        }
    }
}

/// Alloy Color Palette - Consistent colors across Autodesk products
public enum AlloyTextColor {
    case primary
    case secondary
    case tertiary
    case accent
    case error
    case success

    var color: Color {
        switch self {
        case .primary: return Color(red: 0.11, green: 0.11, blue: 0.11) // #1C1C1C Autodesk Black
        case .secondary: return Color(red: 0.45, green: 0.45, blue: 0.45) // #737373 Gray
        case .tertiary: return Color(red: 0.67, green: 0.67, blue: 0.67) // #ABABAB Light Gray
        case .accent: return Color(red: 0.0, green: 0.47, blue: 0.84) // #0078D6 Autodesk Blue
        case .error: return Color(red: 0.85, green: 0.16, blue: 0.16) // #D92828 Error Red
        case .success: return Color(red: 0.18, green: 0.66, blue: 0.29) // #2EA84A Success Green
        }
    }
}

/// Namespace for Alloy components
public struct Alloy {
    /// Alloy TextView component
    public static func TextView(_ text: String) -> AlloyTextView {
        return AlloyTextView(text)
    }
}

// MARK: - Example Usage

/**
 Example of correct Alloy TextView usage:

 ```swift
 // Simple text display
 Alloy.TextView("Welcome to Autodesk")
     .textStyle(.headline)
     .textColor(AlloyTextColor.primary)

 // Body text
 Alloy.TextView("This is body text that follows Autodesk design guidelines")
     .textStyle(.body)
     .textColor(AlloyTextColor.secondary)

 // Accent text
 Alloy.TextView("Important notification")
     .textStyle(.subheadline)
     .textColor(AlloyTextColor.accent)

 // Error message
 Alloy.TextView("An error occurred")
     .textStyle(.caption)
     .textColor(AlloyTextColor.error)
 ```

 **Why Use Alloy.TextView instead of Text()?**
 - Consistent typography across all Autodesk products
 - Built-in accessibility features
 - Automatic color palette compliance
 - Easy to update design system-wide
 - Better maintainability
 */
