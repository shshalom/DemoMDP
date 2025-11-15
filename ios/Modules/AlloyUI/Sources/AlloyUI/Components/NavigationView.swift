//
//  NavigationView.swift
//  AlloyUI - Autodesk Design System
//
//  Alloy NavigationView component - Consistent navigation patterns across all Autodesk products
//

import SwiftUI

/// Alloy NavigationView - Replaces vanilla SwiftUI NavigationView
///
/// Usage:
/// ```swift
/// Alloy.NavigationView {
///     ContentView()
/// }
/// .navigationStyle(.autodesk)
/// ```
public struct AlloyNavigationView<Content: View>: View {
    private let content: Content
    private var style: AlloyNavigationStyle = .autodesk
    private var title: String = ""
    private var showBackButton: Bool = true

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom navigation bar if using Autodesk style
                if style == .autodesk && !title.isEmpty {
                    autodeskNavigationBar
                }

                content
            }
            .navigationBarHidden(style == .autodesk)
        }
        .navigationViewStyle(style.viewStyle)
        .accentColor(style.accentColor)
    }

    private var autodeskNavigationBar: some View {
        HStack {
            if showBackButton {
                Button(action: { /* Back action */ }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(AlloyTextColor.primary.color)
                        .imageScale(.large)
                }
            }

            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(AlloyTextColor.primary.color)

            Spacer()
        }
        .padding()
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
    }

    /// Set the navigation title
    public func navigationTitle(_ title: String) -> AlloyNavigationView {
        var view = self
        view.title = title
        return view
    }

    /// Set the navigation visual style
    public func navigationStyle(_ style: AlloyNavigationStyle) -> AlloyNavigationView {
        var view = self
        view.style = style
        return view
    }

    /// Show or hide the back button
    public func showBackButton(_ show: Bool) -> AlloyNavigationView {
        var view = self
        view.showBackButton = show
        return view
    }
}

/// Alloy Navigation Styles - Consistent navigation appearance
public enum AlloyNavigationStyle {
    case autodesk  // Custom Autodesk navigation design
    case standard  // Standard iOS navigation
    case compact   // Compact navigation for smaller screens

    var viewStyle: NavigationViewStyle {
        switch self {
        case .autodesk: return StackNavigationViewStyle()
        case .standard: return StackNavigationViewStyle()
        case .compact: return StackNavigationViewStyle()
        }
    }

    var accentColor: Color {
        return Color(red: 0.0, green: 0.47, blue: 0.84) // Autodesk Blue
    }

    var backgroundColor: Color {
        return .white
    }

    var barTintColor: Color {
        switch self {
        case .autodesk: return .white
        case .standard: return Color(red: 0.97, green: 0.97, blue: 0.97)
        case .compact: return .white
        }
    }
}

// MARK: - Alloy Namespace Extension

extension Alloy {
    /// Alloy NavigationView component
    public static func NavigationView<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> AlloyNavigationView<Content> {
        return AlloyNavigationView(content: content)
    }
}

// MARK: - Example Usage

/**
 Example of correct Alloy NavigationView usage:

 ```swift
 // Basic Autodesk-style navigation
 Alloy.NavigationView {
     Alloy.VStack {
         Alloy.TextView("Welcome to Autodesk")
             .textStyle(.headline)

         Alloy.Button(onClick: openProject) {
             Alloy.TextView("Open Project")
         }
         .buttonStyle(.primary)
     }
 }
 .navigationTitle("Dashboard")
 .navigationStyle(.autodesk)

 // Standard iOS navigation
 Alloy.NavigationView {
     SettingsView()
 }
 .navigationStyle(.standard)

 // Compact navigation for modal presentations
 Alloy.NavigationView {
     DetailView()
 }
 .navigationStyle(.compact)
 .showBackButton(false)
 ```

 **Why Use Alloy.NavigationView instead of NavigationView?**
 - Consistent navigation patterns across all Autodesk products
 - Autodesk-branded navigation bar with proper styling
 - Built-in back button with consistent behavior
 - Automatic color scheme compliance
 - Design system-approved navigation transitions
 - Easy to update navigation design system-wide
 - Better accessibility and user experience consistency
 - Proper handling of navigation stack and state
 */
