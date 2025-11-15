//
//  TextField.swift
//  AlloyUI - Autodesk Design System
//
//  Alloy TextField component - Consistent text input across all Autodesk products
//

import SwiftUI

/// Alloy TextField - Replaces vanilla SwiftUI TextField()
///
/// Usage:
/// ```swift
/// @State private var userName: String = ""
///
/// Alloy.TextField(text: $userName)
///     .placeholder("Enter name")
///     .labelText("User Name")
///     .textFieldStyle(.standard)
/// ```
public struct AlloyTextField: View {
    @Binding private var text: String
    private var placeholder: String = ""
    private var label: String = ""
    private var style: AlloyTextFieldStyle = .standard
    private var isSecure: Bool = false
    private var isEnabled: Bool = true
    private var errorMessage: String? = nil

    public init(text: Binding<String>) {
        self._text = text
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Label
            if !label.isEmpty {
                Text(label)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.11))
            }

            // Input field
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .padding(style.padding)
            .background(isEnabled ? style.backgroundColor : style.disabledBackgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .stroke(
                        errorMessage != nil ? style.errorBorderColor :
                        isEnabled ? style.borderColor : style.disabledBorderColor,
                        lineWidth: style.borderWidth
                    )
            )
            .cornerRadius(style.cornerRadius)
            .disabled(!isEnabled)
            .accessibilityLabel(label.isEmpty ? placeholder : label)

            // Error message
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.system(size: 12))
                    .foregroundColor(style.errorBorderColor)
            }
        }
    }

    /// Set placeholder text
    public func placeholder(_ text: String) -> AlloyTextField {
        var view = self
        view.placeholder = text
        return view
    }

    /// Set label text (shown above field)
    public func labelText(_ text: String) -> AlloyTextField {
        var view = self
        view.label = text
        return view
    }

    /// Set the text field visual style
    public func textFieldStyle(_ style: AlloyTextFieldStyle) -> AlloyTextField {
        var view = self
        view.style = style
        return view
    }

    /// Make the field secure (password entry)
    public func secure(_ isSecure: Bool = true) -> AlloyTextField {
        var view = self
        view.isSecure = isSecure
        return view
    }

    /// Enable or disable the field
    public func enabled(_ isEnabled: Bool) -> AlloyTextField {
        var view = self
        view.isEnabled = isEnabled
        return view
    }

    /// Set error message (shows error state and message)
    public func errorMessage(_ message: String?) -> AlloyTextField {
        var view = self
        view.errorMessage = message
        return view
    }
}

/// Alloy TextField Styles - Consistent input field appearance
public enum AlloyTextFieldStyle {
    case standard   // Standard bordered input
    case filled     // Filled background input
    case minimal    // Minimal style with bottom border only

    var padding: EdgeInsets {
        switch self {
        case .standard: return EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12)
        case .filled: return EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14)
        case .minimal: return EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 4)
        }
    }

    var backgroundColor: Color {
        switch self {
        case .standard: return .white
        case .filled: return Color(red: 0.97, green: 0.97, blue: 0.97)
        case .minimal: return .clear
        }
    }

    var disabledBackgroundColor: Color {
        return Color(red: 0.95, green: 0.95, blue: 0.95)
    }

    var borderColor: Color {
        return Color(red: 0.8, green: 0.8, blue: 0.8)
    }

    var disabledBorderColor: Color {
        return Color(red: 0.9, green: 0.9, blue: 0.9)
    }

    var errorBorderColor: Color {
        return Color(red: 0.85, green: 0.16, blue: 0.16) // Error Red
    }

    var borderWidth: CGFloat {
        switch self {
        case .standard: return 1.0
        case .filled: return 0.0
        case .minimal: return 1.0
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .standard: return 6.0
        case .filled: return 8.0
        case .minimal: return 0.0
        }
    }
}

// MARK: - Alloy Namespace Extension

extension Alloy {
    /// Alloy TextField component
    public static func TextField(text: Binding<String>) -> AlloyTextField {
        return AlloyTextField(text: text)
    }
}

// MARK: - Example Usage

/**
 Example of correct Alloy TextField usage:

 ```swift
 @State private var userName: String = ""
 @State private var email: String = ""
 @State private var password: String = ""

 // Standard text field with label
 Alloy.TextField(text: $userName)
     .placeholder("Enter your name")
     .labelText("User Name")
     .textFieldStyle(.standard)

 // Filled style with validation
 Alloy.TextField(text: $email)
     .placeholder("user@example.com")
     .labelText("Email")
     .textFieldStyle(.filled)
     .errorMessage(emailValid ? nil : "Invalid email address")

 // Secure password field
 Alloy.TextField(text: $password)
     .placeholder("Enter password")
     .labelText("Password")
     .textFieldStyle(.standard)
     .secure(true)

 // Disabled field
 Alloy.TextField(text: $readOnlyValue)
     .labelText("System Generated ID")
     .textFieldStyle(.standard)
     .enabled(false)
 ```

 **Why Use Alloy.TextField instead of TextField()?**
 - Consistent text input styling across all Autodesk products
 - Built-in label and error message support
 - Automatic validation state visualization
 - Accessible by default
 - Design system-compliant spacing and colors
 - Easy to update design system-wide
 - Better maintainability and consistency
 */
