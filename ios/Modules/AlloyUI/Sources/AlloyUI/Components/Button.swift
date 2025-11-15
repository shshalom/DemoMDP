//
//  Button.swift
//  AlloyUI - Autodesk Design System
//
//  Alloy Button component - Consistent interactive buttons across all Autodesk products
//

import SwiftUI

/// Alloy Button - Replaces vanilla SwiftUI Button()
///
/// Usage:
/// ```swift
/// Alloy.Button(onClick: saveAction) {
///     Alloy.TextView("Save")
/// }
/// .buttonStyle(.primary)
/// .buttonSize(.medium)
/// ```
public struct AlloyButton<Content: View>: View {
    private let action: () -> Void
    private let content: Content
    private var style: AlloyButtonStyle = .primary
    private var size: AlloyButtonSize = .medium
    private var isEnabled: Bool = true

    public init(onClick action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }

    public var body: some View {
        Button(action: action) {
            content
                .padding(size.padding)
                .frame(minWidth: size.minWidth, minHeight: size.minHeight)
        }
        .buttonStyle(PlainButtonStyle())
        .background(isEnabled ? style.backgroundColor : style.disabledBackgroundColor)
        .foregroundColor(isEnabled ? style.textColor : style.disabledTextColor)
        .cornerRadius(style.cornerRadius)
        .opacity(isEnabled ? 1.0 : 0.5)
        .disabled(!isEnabled)
        .accessibilityAddTraits(.isButton)
    }

    /// Set the button visual style
    public func buttonStyle(_ style: AlloyButtonStyle) -> AlloyButton {
        var view = self
        view.style = style
        return view
    }

    /// Set the button size
    public func buttonSize(_ size: AlloyButtonSize) -> AlloyButton {
        var view = self
        view.size = size
        return view
    }

    /// Enable or disable the button
    public func enabled(_ isEnabled: Bool) -> AlloyButton {
        var view = self
        view.isEnabled = isEnabled
        return view
    }
}

/// Alloy Button Styles - Consistent button appearance across Autodesk products
public enum AlloyButtonStyle {
    case primary    // Main action buttons
    case secondary  // Secondary actions
    case tertiary   // Low emphasis actions
    case danger     // Destructive actions

    var backgroundColor: Color {
        switch self {
        case .primary: return Color(red: 0.0, green: 0.47, blue: 0.84) // Autodesk Blue
        case .secondary: return Color(red: 0.95, green: 0.95, blue: 0.95) // Light Gray
        case .tertiary: return Color.clear
        case .danger: return Color(red: 0.85, green: 0.16, blue: 0.16) // Error Red
        }
    }

    var textColor: Color {
        switch self {
        case .primary: return .white
        case .secondary: return Color(red: 0.11, green: 0.11, blue: 0.11) // Autodesk Black
        case .tertiary: return Color(red: 0.0, green: 0.47, blue: 0.84) // Autodesk Blue
        case .danger: return .white
        }
    }

    var disabledBackgroundColor: Color {
        return Color(red: 0.9, green: 0.9, blue: 0.9)
    }

    var disabledTextColor: Color {
        return Color(red: 0.67, green: 0.67, blue: 0.67)
    }

    var cornerRadius: CGFloat {
        return 8.0
    }
}

/// Alloy Button Sizes - Consistent button sizing
public enum AlloyButtonSize {
    case small
    case medium
    case large

    var padding: EdgeInsets {
        switch self {
        case .small: return EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
        case .medium: return EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        case .large: return EdgeInsets(top: 14, leading: 28, bottom: 14, trailing: 28)
        }
    }

    var minWidth: CGFloat {
        switch self {
        case .small: return 60
        case .medium: return 100
        case .large: return 140
        }
    }

    var minHeight: CGFloat {
        switch self {
        case .small: return 28
        case .medium: return 40
        case .large: return 52
        }
    }
}

// MARK: - Alloy Namespace Extension

extension Alloy {
    /// Alloy Button component
    public static func Button<Content: View>(
        onClick action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) -> AlloyButton<Content> {
        return AlloyButton(onClick: action, content: content)
    }
}

// MARK: - Example Usage

/**
 Example of correct Alloy Button usage:

 ```swift
 // Primary action button
 Alloy.Button(onClick: saveDocument) {
     Alloy.TextView("Save")
 }
 .buttonStyle(.primary)
 .buttonSize(.medium)

 // Secondary button
 Alloy.Button(onClick: cancelAction) {
     Alloy.TextView("Cancel")
 }
 .buttonStyle(.secondary)
 .buttonSize(.medium)

 // Danger button for destructive actions
 Alloy.Button(onClick: deleteFile) {
     Alloy.TextView("Delete")
 }
 .buttonStyle(.danger)
 .buttonSize(.medium)

 // Small tertiary button
 Alloy.Button(onClick: showDetails) {
     Alloy.TextView("More Info")
 }
 .buttonStyle(.tertiary)
 .buttonSize(.small)

 // Disabled button
 Alloy.Button(onClick: submit) {
     Alloy.TextView("Submit")
 }
 .buttonStyle(.primary)
 .enabled(false)
 ```

 **Why Use Alloy.Button instead of Button()?**
 - Consistent button styles across all Autodesk products
 - Built-in accessibility features
 - Automatic state management (enabled/disabled)
 - Design system-compliant sizing
 - Easy to update design system-wide
 - Better maintainability and consistency
 */
