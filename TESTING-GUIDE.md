# DemoMDP - PR Governance Workflow Testing Guide

## Overview

DemoMDP is a complete testing environment for the MDP Framework's PR Governance Workflow. It demonstrates how AI-powered policy enforcement works in a real iOS/SwiftUI project with actual code violations and intelligent fix suggestions.

## What's Included

### 1. Mock AlloyUI Framework
Real Swift code that the AI can analyze and learn from:
- `ios/Modules/AlloyUI/Sources/AlloyUI/Components/TextView.swift`
- `ios/Modules/AlloyUI/Sources/AlloyUI/Components/Button.swift`
- `ios/Modules/AlloyUI/Sources/AlloyUI/Components/TextField.swift`
- `ios/Modules/AlloyUI/Sources/AlloyUI/Components/NavigationView.swift`

### 2. Test Cases (Code with Violations)
- **ContentView.swift** - Uses vanilla `Text()` and `Image()` components
- **ProfileSettingsView.swift** - Multiple violations (NavigationView, Form, Button, Toggle, etc.)
- **TestViolation.swift** - Contains force unwrap (`user!.name`)
- **DemoMDPApp.swift** - Clean code, no violations

### 3. Policies
- **ui.alloy.governance** - AI-powered Alloy Design System enforcement
- **ios.swift.no-force-unwrap** - AI-powered force unwrap detection

### 4. GitHub Actions Workflow
- `.github/workflows/mdp-governance.yml` - Auto-generated workflow
- `.github/MDP-SETUP.md` - Setup documentation

---

## Setup Instructions

### Step 1: Initialize Git Repository (if not already done)

```bash
cd /Users/shwaits/Workspace/DemoMDP
git init
git add .
git commit -m "Initial commit: DemoMDP with AlloyUI framework and test violations"
```

### Step 2: Create GitHub Repository

```bash
# Option A: Using gh CLI
gh repo create DemoMDP --public --source=. --remote=origin --push

# Option B: Manual
# 1. Create repo on github.com
# 2. Add remote: git remote add origin https://github.com/YOUR_USERNAME/DemoMDP.git
# 3. Push: git push -u origin main
```

### Step 3: Configure GitHub Secrets

1. Go to your GitHub repo: `https://github.com/YOUR_USERNAME/DemoMDP`
2. Navigate to: **Settings → Secrets and variables → Actions**
3. Click **"New repository secret"**
4. Add secret:
   - Name: `ANTHROPIC_API_KEY`
   - Value: Your Anthropic API key from https://console.anthropic.com/

Note: `GITHUB_TOKEN` is automatically provided by GitHub Actions.

### Step 4: Verify Workflow File

Check that `.github/workflows/mdp-governance.yml` exists and contains:
- Trigger on PR events (opened, synchronize, reopened)
- File path filters for `.swift`, `.kt`, `.tsx`, etc.
- Policy evaluation step
- PR comment and status check steps

---

## Testing the PR Governance Workflow

### Test Case 1: Create PR with Violations

**Purpose:** Verify that the workflow detects violations and blocks merge.

```bash
# Create a test branch
git checkout -b test/vanilla-ui-violations

# Push the branch (violations already exist in ContentView.swift and ProfileSettingsView.swift)
git push origin test/vanilla-ui-violations

# Create PR via gh CLI
gh pr create \
  --title "Test: Vanilla UI violations" \
  --body "This PR intentionally contains vanilla SwiftUI components to test governance" \
  --base main \
  --head test/vanilla-ui-violations

# Or create PR via GitHub web UI
```

**Expected Results:**
1. Workflow triggers automatically within seconds
2. PR status check appears: "MDP Governance - In progress"
3. After ~1-2 minutes, workflow completes
4. PR comment appears with violation details
5. Status check shows "Failed" (blocks merge)

**Example Violations Detected:**

```
## 🛡️ MDP Governance Report

❌ 2 policies failed with 8 violations.

### Violations

#### ui.alloy.governance (BLOCKED)

- **[ERROR]** Use Alloy.TextView instead of vanilla Text() in `ContentView.swift:12`

  <details>
  <summary>Suggested Fix</summary>

  ```diff
  - Text("Hello, world!")
  + Alloy.TextView("Hello, world!")
  +     .textStyle(.body)
  +     .textColor(AlloyTextColor.primary)
  ```
  </details>

- **[ERROR]** Use Alloy.Button instead of vanilla Button() in `ProfileSettingsView.swift:45`

  <details>
  <summary>Suggested Fix</summary>

  ```diff
  - Button("Save") { saveSettings() }
  + Alloy.Button(onClick: saveSettings) {
  +     Alloy.TextView("Save")
  + }
  + .buttonStyle(.primary)
  ```
  </details>

#### ios.swift.no-force-unwrap (BLOCKED)

- **[ERROR]** Force unwrap detected in `TestViolation.swift:8`

  <details>
  <summary>Suggested Fix</summary>

  ```diff
  - let name = user!.name
  + guard let user = user else { return }
  + let name = user.name
  ```
  </details>
```

### Test Case 2: Fix Violations and Verify Approval

**Purpose:** Verify that fixing violations allows PR to pass.

```bash
# On the test branch, fix the violations
# Apply the suggested fixes from the PR comment

# For example, edit ContentView.swift:
# Replace: Text("Hello, world!")
# With:    Alloy.TextView("Hello, world!").textStyle(.body).textColor(AlloyTextColor.primary)

# Commit and push
git add .
git commit -m "Fix: Replace vanilla UI with Alloy components"
git push origin test/vanilla-ui-violations
```

**Expected Results:**
1. Workflow triggers again on the new push
2. Violations decrease or disappear
3. Status check shows "Success" (allows merge)
4. PR comment shows: "✅ All policies passed! This PR is approved for merge."

### Test Case 3: Test Force Unwrap Policy

**Purpose:** Verify Swift safety policy enforcement.

```bash
# Create new branch
git checkout main
git checkout -b test/force-unwrap

# Add a force unwrap to any Swift file
# For example, in ContentView.swift add:
#   let value = optionalString!

git add .
git commit -m "Test: Add force unwrap violation"
git push origin test/force-unwrap

gh pr create \
  --title "Test: Force unwrap detection" \
  --body "Testing force unwrap policy" \
  --base main \
  --head test/force-unwrap
```

**Expected Results:**
- Workflow detects force unwrap
- Provides safe alternatives (if let, guard let, nil coalescing)
- Status check fails

---

## Understanding the AI Suggestions

### How the AI Provides Intelligent Suggestions

1. **AI reads your code violations:**
   - Scans ContentView.swift and finds `Text("Hello, world!")`

2. **AI explores the AlloyUI framework:**
   - Reads `ios/Modules/AlloyUI/Sources/AlloyUI/Components/TextView.swift`
   - Understands the Alloy API: `Alloy.TextView(...).textStyle(...).textColor(...)`

3. **AI generates contextual fixes:**
   ```swift
   // Instead of generic "use Alloy component"
   // Provides actual working code:
   Alloy.TextView("Hello, world!")
       .textStyle(.body)
       .textColor(AlloyTextColor.primary)
   ```

4. **AI adapts to your patterns:**
   - Sees how you use text in your app
   - Suggests appropriate styles (headline vs body)
   - Matches your coding conventions

### Why This Matters

**Without framework code:**
- AI can only say "use Alloy.TextView instead"
- No concrete example of how to use it

**With framework code:**
- AI shows exact API
- Includes proper method calls
- Suggests appropriate styles/colors
- Provides copy-paste-ready fixes

---

## Cost Analysis

**Estimated costs per PR:**
- 2 AI-powered policies
- Average PR: 5-10 files changed
- **Cost: ~$0.05 per PR**

Costs only incurred when:
- PRs are opened
- PRs are updated (new commits)
- Workflow runs manually

---

## Troubleshooting

### Workflow doesn't trigger
- Check that `.github/workflows/mdp-governance.yml` exists
- Verify GitHub Actions is enabled: Settings → Actions → General
- Ensure you're creating PR (not just pushing)

### "ANTHROPIC_API_KEY not found" error
- Verify secret is named exactly `ANTHROPIC_API_KEY`
- Check secret is set in correct repo
- Try re-creating the secret

### No violations detected but violations exist
- Check file patterns in workflow (must match your changed files)
- Verify policies are compiled: `.mlang/packs/stable/*.json`
- Check workflow logs for policy loading errors

### AI suggestions seem generic
- Ensure AlloyUI framework files exist at `ios/Modules/AlloyUI/Sources/AlloyUI/Components/`
- Verify framework files contain actual Swift code
- Check that policies reference correct framework paths

---

## Advanced Testing

### Test AOI (Architecture of Intent) Features

The `ui.alloy.governance` policy has AOI enabled, which means:
- If violations exceed threshold, counter-PR created
- Framework team gets automatic notification
- Feedback loop for missing components

To test AOI:
1. Create multiple PRs with same component violations
2. Watch for counter-PR creation in framework repo
3. Verify feedback includes usage examples

### Test Patch Application

The workflow supports automatic fix application:
- AI generates patches
- Patches can be applied via GitHub API
- Creates commits with fixes

To test:
1. Enable `--execute` flag in workflow
2. Create PR with violations
3. Approve auto-fix application
4. Verify commit appears with fixes

---

## Next Steps

After successful testing:

1. **Apply to real projects:**
   - Use `mlang github init` in your actual repos
   - Compile policies specific to your needs
   - Add framework code your team uses

2. **Customize policies:**
   - Edit markdown in `policies/` directory
   - Run `mlang policy build` to recompile
   - Push updated policies

3. **Scale the system:**
   - Deploy to multiple repos
   - Share policies via registry
   - Create organization-wide governance

---

## Files Reference

### Generated by MDP Framework
- `.github/workflows/mdp-governance.yml` - Via `mlang github init`
- `.github/MDP-SETUP.md` - Via `mlang github init`
- `.mlang/packs/stable/*.json` - Via `mlang policy build`

### Mock Framework (for testing)
- `ios/Modules/AlloyUI/Sources/AlloyUI/Components/*.swift`

### Test Violations
- `DemoMDP/ContentView.swift`
- `DemoMDP/ProfileSettingsView.swift`
- `DemoMDP/TestViolation.swift`

### Policy Source
- `policies/ui-alloy-governance.md`
- `policies/ios-swift-no-force-unwrap.md`

---

## Support

For issues or questions:
- MDP Framework: https://github.com/mdp-labs/mdp-mlang
- Documentation: https://github.com/mdp-labs/mdp-mlang/tree/main/Docs
- Report bugs: https://github.com/mdp-labs/mdp-mlang/issues

---

**Generated:** 2025-11-14
**Framework Version:** @mdp-framework/mlang@1.1.17
**Status:** Ready for E2E Testing
