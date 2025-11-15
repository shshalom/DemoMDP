---
id: ui.alloy.governance
version: 2025.01.13
scope: repo
role: developer
title: Alloy Design System Governance Rules
description: Enforce consistent use of Alloy Design System components across all Autodesk products to ensure design consistency, maintainability, and accessibility
tags:
  - ui
  - design-system
  - alloy
  - consistency
  - accessibility
  - autodesk

constraints:
  use_alloy_components: true
  target_compliance: 0.95
  framework_locations:
    ios: "ios/Modules/AlloyUI/Sources/AlloyUI/Components/"
    android: "pgf/alloyDomain/src/"
    web: "web/alloy-components/src/"
  severity: error
  aoi_feedback_enabled: true

on_violation:
  - action: fail
    message: "BLOCKED: Use Alloy Components Instead of Vanilla UI"
  - action: comment
    message: "Replace vanilla UI components with Alloy Design System equivalents. See examples for your platform. If component missing, trigger AOI feedback request."
    metadata:
      alloy_catalog: "Available components listed in framework paths"
      exception_process: "Architecture team approval required"
      escalation: "Automatic alert to Alloy team if component missing"
---

## Purpose
---
Enforce consistent use of Alloy Design System components across all Autodesk products to ensure design consistency, maintainability, and accessibility.

### Why This Rule Exists
- **Consistency**: All Autodesk products should look and feel cohesive
- **Maintenance**: Design updates happen once in Alloy, not in every component
- **Accessibility**: Alloy components include built-in accessibility features
- **Performance**: Optimized components with proper resource usage
- **Brand Alignment**: Consistent visual language across all products

### Context
Alloy is our unified design system that ensures consistency across all Autodesk products. Using vanilla UI components instead of Alloy components leads to:
- **Design inconsistencies** between teams and products
- **Maintenance overhead** when design changes need to be applied
- **Accessibility issues** due to missing built-in accessibility features
- **Poor user experience consistency** across the Autodesk ecosystem
---

## Detection
---
### Real Framework Locations
**iOS AlloyUI Framework**: `ios/Modules/AlloyUI/Sources/AlloyUI/Components/`
- Available components: TextView, TextField, Button, Avatars, Badges, Banners, Cells, Checkbox, Color, Dividers, EmptyState, FileVersionIndicator, FlowLayout, Image, ProgressIndicator, RadioButton, RichTextEditor, SearchBar, SegmentedControl, Shapes, Stepper, TableRows, Tabs, Tags, TextArea, Toast, ToggleSwitch

**Android/Kotlin alloyDomain**: `pgf/alloyDomain/src/`
- Domain components and UI builders for Kotlin Multiplatform

**Web Components**: `web/alloy-components/src/`
- React/TypeScript Alloy components for web applications

### Detection Patterns

**iOS - Violations (Don't Do This):**
```swift
// Vanilla SwiftUI/UIKit
Text("Hello World")
Button("Click Me") { }
TextField("Enter text", text: $binding)
List { }
VStack { }
HStack { }
NavigationView { }
```

**Android/Kotlin - Violations (Don't Do This):**
```kotlin
// Vanilla Android/Compose components
Text("Hello World")
Button(onClick = { }) { Text("Click") }
TextField(value = text, onValueChange = { })
LazyColumn { }
Column { }
Row { }
```

**Web - Violations (Don't Do This):**
```typescript
// Vanilla HTML/React
<div>Hello World</div>
<button onClick={() => {}}>Click</button>
<input type="text" />
```
---

## Exceptions
---
**Approved Use Cases for Vanilla UI:**

1. **Component Not Yet Available**: If Alloy component doesn't exist, file AOI feedback request
2. **Prototype/Experimental Code**: Clearly marked experimental features (requires `// EXPERIMENTAL:` comment)
3. **Internal Tools**: Non-customer-facing internal developer tools (requires architecture approval)
4. **Performance Critical Paths**: Documented performance bottlenecks where Alloy overhead is measured issue (requires profiling data)
5. **Third-Party Integrations**: When integrating external SDKs that provide their own UI components
6. **Legacy Code Migration**: During gradual migration periods (requires migration plan with timeline)

**Exception Approval Process:**
- All exceptions require Architecture team approval
- Document reason in code comments with ticket reference
- Add to exception tracking dashboard
- Set review date for re-evaluation (max 6 months)
---

## Examples
---
### iOS Example 1 - Text Component

**❌ Violation:**
```swift
import SwiftUI

struct UserProfile: View {
    var body: some View {
        VStack {
            Text("User Profile")
                .font(.headline)
                .foregroundColor(.primary)

            Text("Welcome back, John")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
```

**✅ Correct (Using Alloy):**
```swift
import AlloyUI

struct UserProfile: View {
    var body: some View {
        Alloy.VStack {
            Alloy.TextView("User Profile")
                .textStyle(.headline)
                .textColor(AlloyTextColor.primary)

            Alloy.TextView("Welcome back, John")
                .textStyle(.subheadline)
                .textColor(AlloyTextColor.secondary)
        }
    }
}
```

---

### iOS - Button Components

**❌ Violation:**
```swift
Button("Save Changes") {
    saveUserProfile()
}
.buttonStyle(.borderedProminent)
.foregroundColor(.white)
```

**✅ Correct (Using Alloy):**
```swift
Alloy.Button(onClick: saveUserProfile) {
    Alloy.TextView("Save Changes")
}
.buttonStyle(.primary)
```

---

### iOS - Text Input

**❌ Violation:**
```swift
@State private var userName: String = ""

TextField("Enter name", text: $userName)
    .textFieldStyle(.roundedBorder)
    .padding()
```

**✅ Correct (Using Alloy):**
```swift
@State private var userName: String = ""

Alloy.TextField(text: $userName)
    .placeholder("Enter name")
    .labelText("User Name")
    .textFieldStyle(.standard)
```

---

### Android/Kotlin - Text Display

**❌ Violation:**
```kotlin
@Composable
fun UserProfile() {
    Column {
        Text(
            text = "User Profile",
            style = MaterialTheme.typography.headlineMedium
        )
        Text(
            text = "Welcome back, John",
            style = MaterialTheme.typography.bodyMedium
        )
    }
}
```

**✅ Correct (Using Alloy):**
```kotlin
import com.autodesk.alloy.domain.*

@Composable
fun UserProfile() {
    AlloyColumn {
        AlloyText(
            text = "User Profile",
            style = AlloyTextStyle.Headline,
            color = AlloyColor.Primary
        )
        AlloyText(
            text = "Welcome back, John",
            style = AlloyTextStyle.Body,
            color = AlloyColor.Secondary
        )
    }
}
```

---

### Android/Kotlin - Button Components

**❌ Violation:**
```kotlin
Button(
    onClick = { saveUserProfile() },
    colors = ButtonDefaults.buttonColors(
        containerColor = MaterialTheme.colorScheme.primary
    )
) {
    Text("Save Changes")
}
```

**✅ Correct (Using Alloy):**
```kotlin
AlloyButton(
    text = "Save Changes",
    style = AlloyButtonStyle.Primary,
    onClick = { saveUserProfile() }
)
```

---

### Web/React - Components

**❌ Violation:**
```typescript
import React from 'react';

export const UserProfile: React.FC = () => {
  return (
    <div className="profile">
      <h2>User Profile</h2>
      <p>Welcome back, John</p>
      <button onClick={saveUserProfile}>
        Save Changes
      </button>
    </div>
  );
};
```

**✅ Correct (Using Alloy):**
```typescript
import React from 'react';
import { AlloyText, AlloyButton, AlloyVStack } from '@autodesk/alloy-react';

export const UserProfile: React.FC = () => {
  return (
    <AlloyVStack spacing="md">
      <AlloyText variant="headline" color="primary">
        User Profile
      </AlloyText>
      <AlloyText variant="body" color="secondary">
        Welcome back, John
      </AlloyText>
      <AlloyButton
        variant="primary"
        onClick={saveUserProfile}
      >
        Save Changes
      </AlloyButton>
    </AlloyVStack>
  );
};
```
---

## AOI Integration
---
### Adaptive Organizational Intelligence (AOI) - Gap Detection & Feedback Loop

When the governance system detects violations, it performs **intelligent framework discovery**:

1. **Detect Violation**: Identify vanilla UI component usage
2. **Search Framework**: Explore actual Alloy framework directories
3. **Component Exists**: Provide exact replacement with real API examples
4. **Component Missing**: Trigger AOI feedback loop

### Missing Component Feedback Loop
When a required Alloy component doesn't exist:

```yaml
# AOI Feedback Loop Trigger
Detection: "Developer used vanilla SwiftUI Button"
Search: "ios/Modules/AlloyUI/Sources/AlloyUI/Components/Button.swift"
Result: "NOT_FOUND"
Action: "Trigger AOI feedback loop"

# Generated Feedback
To: "Alloy Design System Team"
Subject: "Missing Component Request: Button"
Priority: "HIGH (blocking 3 PRs this week)"

Context:
  - PR: "#1234 - File Upload Feature"
  - Developer: "@john.doe"
  - Attempted Pattern: "Button('Upload File') { uploadAction() }"
  - Use Case: "Primary action button for file upload functionality"
  - Similar Requests: "2 other PRs this week needed similar button"

Proposed API:
  Alloy.Button(style: .primary, size: .large) {
      Text("Upload File")
  }
  .onTapGesture { uploadAction() }

Intelligence:
  - Based on 3 similar vanilla Button usages this week
  - Suggested API follows existing Alloy patterns
  - Would resolve violations in: FileUpload, DocumentShare, ProjectCreate
```

### Learning System
The AOI system learns from every interaction:
- **Pattern Recognition**: Identifies common vanilla UI patterns
- **Usage Analytics**: Tracks which components are most needed
- **API Suggestions**: Proposes component APIs based on real usage
- **Priority Scoring**: Ranks missing components by team impact
---

## Remediation
---
### Step 1: Identify Vanilla Component Usage
Run automated scan to detect vanilla UI components in your codebase:

```bash
# iOS
grep -r "Text(" --include="*.swift" ios/
grep -r "Button(" --include="*.swift" ios/

# Android
grep -r "androidx.compose" --include="*.kt" android/

# Web
grep -r "<button" --include="*.tsx" web/
grep -r "<input" --include="*.tsx" web/
```

### Step 2: Find Alloy Equivalent
Check component availability in Alloy framework:

**iOS Available Components** (`ios/Modules/AlloyUI/Sources/AlloyUI/Components/`):
- TextView, TextField, Button, Avatars, Badges, Banners, Cells, Checkbox
- Color, Dividers, EmptyState, FileVersionIndicator, FlowLayout, Image
- ProgressIndicator, RadioButton, RichTextEditor, SearchBar, SegmentedControl
- Shapes, Stepper, TableRows, Tabs, Tags, TextArea, Toast, ToggleSwitch

**Android Components** (`pgf/alloyDomain/src/`):
- AlloyText, AlloyButton, AlloyTextField, AlloyCheckbox, AlloyRadioButton
- AlloySwitch, AlloySlider, AlloyProgressBar, AlloyCard, AlloyDivider

**Web Components** (`web/alloy-components/src/`):
- AlloyText, AlloyButton, AlloyInput, AlloyCheckbox, AlloyRadio, AlloySelect
- AlloyTextArea, AlloyCard, AlloyDivider, AlloyModal, AlloyToast

### Step 3: Replace with Alloy Component
1. Update imports to include Alloy framework
2. Replace vanilla component with Alloy equivalent
3. Update props/modifiers to match Alloy API
4. Test for visual consistency and functionality
5. Verify accessibility features work correctly

### Step 4: Component Not Available?
If Alloy component doesn't exist for your use case:

**Trigger AOI Feedback Loop:**
1. File component request in Alloy backlog
2. Include:
   - Use case description
   - Vanilla component you tried to use
   - Proposed Alloy API design
   - Priority/impact (how many teams need it)
3. Track request status in component roadmap
4. Use vanilla component with exception approval temporarily
5. Set reminder to migrate once Alloy component is available

### Step 5: Validate Compliance
Run governance check before committing:

```bash
# Validate with MDP CLI
mlang evaluate --file pr-data.json --policy ui.alloy.governance

# Expected output for compliant PR:
# ✓ PASSED - All UI components use Alloy Design System
```
---

## References
---
**Alloy Design System Documentation:**
- Component Catalog: `https://alloy.autodesk.com/components`
- Design Guidelines: `https://alloy.autodesk.com/guidelines`
- API Reference: `https://alloy.autodesk.com/api-docs`

**Framework Source Code:**
- iOS: `ios/Modules/AlloyUI/Sources/AlloyUI/`
- Android: `pgf/alloyDomain/src/`
- Web: `web/alloy-components/src/`

**Governance Resources:**
- Exception Request Form: `https://alloy.autodesk.com/governance/exceptions`
- Compliance Dashboard: `https://alloy.autodesk.com/compliance`
- Component Roadmap: `https://alloy.autodesk.com/roadmap`
- AOI Feedback Portal: `https://alloy.autodesk.com/feedback`

**Related Policies:**
- `ui.design.tokens` - Design token usage enforcement
- `ui.accessibility.wcag` - Accessibility compliance
- `eng.pr.review` - General PR hygiene standards

**Teams & Contacts:**
- Alloy Design System Team: `@alloy-team`
- iOS Mobile Team: `@ios-team`
- Android Team: `@android-team`
- Web Team: `@web-team`
- Architecture Team (Exceptions): `@architecture-team`
---
