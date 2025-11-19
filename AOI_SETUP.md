# AOI (Architecture of Intent) Setup Guide

This guide explains how to set up and demonstrate the complete AOI feedback loop in DemoMDP.

## Storage Backend: File vs PostgreSQL

**DemoMDP uses file-based storage by default** - this works out-of-the-box with zero configuration.

### Comparison

| Feature | File-Based (Default) | PostgreSQL (Advanced) |
|---------|---------------------|----------------------|
| **Setup Required** | None ✅ | Docker + migrations |
| **Violation Detection** | ✅ Works | ✅ Works |
| **Component Existence Check** | ✅ Works | ✅ Works |
| **Spec Generation** | ✅ Works | ✅ Works |
| **Counter-PR Creation** | ✅ Works (single PR) | ✅ Works |
| **Duplicate Prevention** | ❌ Creates duplicate PRs | ✅ Tracks existing components |
| **PR Aggregation** | ❌ One PR at a time | ✅ "Blocking 5 PRs" tracking |
| **Lifecycle Tracking** | ❌ No persistence | ✅ detect → implement → migrate |
| **Follow-up PRs** | ❌ Manual only | ✅ Automated via webhooks |
| **Query Commands** | ❌ Not available | ✅ `mlang aoi query/stats` |
| **GitHub Actions** | ✅ Works immediately | Requires service configuration |

### When to Use Each

**Use File-Based** (current default) if:
- Demonstrating AOI concept
- Local development/testing
- Don't need state across multiple PRs
- Want zero configuration

**Use PostgreSQL** if:
- Production deployment
- Need duplicate detection across PRs
- Want lifecycle analytics
- Enabling automated follow-up PRs

**This guide covers both options.** File-based works immediately. PostgreSQL setup is optional and documented in Part 1 below.

---

## Overview

The AOI system detects missing framework components during policy evaluation and creates:
1. **Spec Generation**: AOI spec describing the missing component
2. **Counter-PR**: Pull request in the framework repository with stub implementation
3. **Follow-up PR**: Migration pull request in the application repository

## Prerequisites

- Node.js 20+
- Docker (for PostgreSQL)
- GitHub CLI (`gh`) for PR creation
- Framework published to npm (`@mdp-framework/mlang@1.1.28` or later)

## Part 1: PostgreSQL Setup (Optional)

**Skip this section if using file-based storage (default).** PostgreSQL is only needed for advanced AOI features like duplicate prevention and lifecycle tracking.

### Step 1: Start PostgreSQL

```bash
# Using Docker
docker run -d \
  --name mdp-postgres \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=mdp_aoi \
  postgres:16
```

### Step 2: Run Migrations

```bash
# From DemoMDP directory
npx @mdp-framework/mlang@1.1.28 aoi migrate \
  --database mdp_aoi \
  --user postgres \
  --password postgres
```

This creates the `aoi_state` table with columns for tracking:
- Component specifications
- State transitions (detected → spec_generated → pr_created → implemented → migrated)
- Ownership and tracking metadata

### Step 3: Verify Database

```bash
# Check that migrations ran successfully
npx @mdp-framework/mlang@1.1.28 aoi query --database mdp_aoi --user postgres --password postgres
```

## Part 2: Framework Repository Setup

AOI needs a "framework repository" where counter-PRs will be created. This can be:
- A separate GitHub repository (e.g., `autodesk/alloy-ui-framework`)
- A branch-based workflow in the same repo

### Option A: Separate Repository (Recommended)

```bash
# Create framework repo on GitHub
gh repo create YOUR_ORG/alloy-ui-framework --public

# Clone it locally
git clone https://github.com/YOUR_ORG/alloy-ui-framework
cd alloy-ui-framework

# Initialize with basic structure
mkdir -p ios/Modules/AlloyUI/Sources/AlloyUI/Components
mkdir -p docs

# Create README
cat > README.md << 'EOF'
# Alloy UI Framework

Design system components for Autodesk products.

## Components

See `ios/Modules/AlloyUI/Sources/AlloyUI/Components/` for available components.

## AOI Integration

This repository receives counter-PRs from the MDP AOI system when missing
components are detected during policy evaluation.
EOF

git add .
git commit -m "Initial framework structure"
git push origin main
```

### Option B: Branch-Based Workflow

Use the existing DemoMDP repository with a dedicated framework branch:

```bash
cd DemoMDP
git checkout -b framework/alloy-ui
mkdir -p ios/Modules/AlloyUI/Sources/AlloyUI/Components
git add .
git commit -m "Initialize AlloyUI framework structure"
git push -u origin framework/alloy-ui
```

### Update Policy Configuration

The Alloy policy in `policies/ui.alloy.governance.md` already has:

```yaml
aoi:
  enabled: true
  framework: "ios/Modules/AlloyUI"  # Path in framework repo
  owners:
    - "@alloy-team"
  include_tests: true
  threshold: 0.85
  auto_create_counter_pr: false  # Set to true for automatic PR creation
  auto_create_followup_pr: false
```

## Part 3: Evaluation and AOI Trigger

### Step 1: Create Test PR Data

Create a file that simulates a PR with Alloy violations:

```bash
cat > test-pr.json << 'EOF'
{
  "pr_number": 123,
  "repo": "autodesk/demo-app",
  "branch": "feature/authentication",
  "files": [
    {
      "path": "ios/Features/Auth/LoginView.swift",
      "status": "added",
      "additions": 50,
      "deletions": 0,
      "patch": "@@ -0,0 +1,50 @@\n+import SwiftUI\n+\n+struct LoginView: View {\n+    var body: some View {\n+        VStack {\n+            Text(\"Login\")\n+            Button(\"Sign In\") {\n+                // Login action\n+            }\n+        }\n+    }\n+}"
    }
  ],
  "created_at": "2025-11-19T12:00:00Z"
}
EOF
```

### Step 2: Run Evaluation

```bash
# Rebuild policies to ensure AOI config is included
npx @mdp-framework/mlang@1.1.28 policy build --in policies --out .mlang/policies

# Run evaluation
npx @mdp-framework/mlang@1.1.28 evaluate \
  --file test-pr.json \
  --policy ui.alloy.governance
```

### Expected Output

The evaluation will:
1. Detect violations: Use of `Text()` and `Button()` instead of Alloy components
2. Check if AlloyUI components exist in the framework
3. If missing, trigger AOI workflow:
   - Create AOI spec
   - Store state in PostgreSQL
   - Log that counter-PR would be created (if auto_create_counter_pr was true)

## Part 4: Manual AOI Workflow Simulation

Since `auto_create_counter_pr` is `false`, you can manually simulate the workflow:

### Step 1: Query AOI State

```bash
npx @mdp-framework/mlang@1.1.28 aoi query \
  --database mdp_aoi \
  --user postgres \
  --password postgres \
  --status detected
```

### Step 2: Create Counter-PR Manually

```bash
# In framework repository
cd alloy-ui-framework

# Create branch
git checkout -b aoi-text-view-component

# Create stub component
mkdir -p ios/Modules/AlloyUI/Sources/AlloyUI/Components
cat > ios/Modules/AlloyUI/Sources/AlloyUI/Components/TextView.swift << 'EOF'
import SwiftUI

/// Alloy Design System Text View
///
/// AOI-generated stub for missing component detected in policy evaluation.
///
/// Detection Context:
/// - PR: autodesk/demo-app#123
/// - Pattern: Text("...")
/// - Policy: ui.alloy.governance
public struct TextView: View {
    private let content: String

    public init(_ content: String) {
        self.content = content
    }

    public var body: some View {
        // TODO: Implement Alloy styling
        Text(content)
    }
}
EOF

git add .
git commit -m "[AOI] Add TextView component stub

Detected missing component during policy evaluation in PR #123.

Component: TextView
Framework: ios/Modules/AlloyUI
Policy: ui.alloy.governance@2025.11.17

This is a stub implementation. The Alloy team should:
1. Review the proposed API
2. Add proper styling and theming
3. Include accessibility features
4. Add comprehensive tests
"

git push -u origin aoi-text-view-component

# Create PR
gh pr create \
  --title "[AOI] Add TextView component" \
  --body "Auto-generated stub for missing Alloy component.

## Context
- Detected in: autodesk/demo-app#123
- Policy: ui.alloy.governance
- Framework: ios/Modules/AlloyUI

## TODO
- [ ] Review proposed API
- [ ] Add Alloy styling
- [ ] Add accessibility support
- [ ] Add tests
- [ ] Update component catalog
"
```

### Step 3: Update AOI State

```bash
# Update state to pr_created
npx @mdp-framework/mlang@1.1.28 aoi update \
  --database mdp_aoi \
  --user postgres \
  --password postgres \
  --component TextView \
  --status pr_created \
  --pr-number 42  # The actual PR number from gh pr create
```

### Step 4: Simulate Counter-PR Merge

```bash
# After the framework team reviews and merges the counter-PR
npx @mdp-framework/mlang@1.1.28 aoi update \
  --database mdp_aoi \
  --user postgres \
  --password postgres \
  --component TextView \
  --status implemented
```

### Step 5: Create Follow-up PR

```bash
# Back in application repo (DemoMDP)
cd DemoMDP

npx @mdp-framework/mlang@1.1.28 aoi followup \
  --database mdp_aoi \
  --user postgres \
  --password postgres \
  --component TextView \
  --repo autodesk/demo-app \
  --original-pr 123
```

This creates a migration PR that updates the original code to use the new Alloy component.

## Part 5: Webhook Handler (Optional)

For fully automated workflow, set up a webhook handler that:
1. Listens for PR merge events from the framework repository
2. Automatically transitions AOI state from `pr_created` to `implemented`
3. Automatically creates follow-up migration PRs

### Setup

```bash
# In your application server/CI environment
npm install @mdp-framework/gateway@1.1.28

# Create webhook handler
cat > aoi-webhook.js << 'EOF'
import { WebhookHandler } from '@mdp-framework/gateway/aoi';
import { PostgresAOIStateStore } from '@mdp-framework/gateway/aoi';

const stateStore = new PostgresAOIStateStore({
  host: 'localhost',
  port: 5432,
  database: 'mdp_aoi',
  user: 'postgres',
  password: process.env.DB_PASSWORD
});

const handler = new WebhookHandler(stateStore);

// Express/Fastify route
app.post('/webhooks/github', async (req, res) => {
  await handler.handle(req.body);
  res.json({ ok: true });
});
EOF

# Run webhook server
node aoi-webhook.js
```

### Configure GitHub Webhook

```bash
# In framework repository
gh api repos/YOUR_ORG/alloy-ui-framework/hooks \
  -X POST \
  -f name='web' \
  -f active=true \
  -f config[url]='https://your-server.com/webhooks/github' \
  -f config[content_type]='application/json' \
  -f events[]='pull_request'
```

## Testing the Full Workflow

### End-to-End Test

```bash
# 1. Start PostgreSQL
docker start mdp-postgres

# 2. Run migrations
npx @mdp-framework/mlang@1.1.28 aoi migrate --database mdp_aoi --user postgres --password postgres

# 3. Create test PR with violations
cat > test-violation.json << 'EOF'
{
  "pr_number": 456,
  "files": [{
    "path": "ios/NewFeature.swift",
    "patch": "+    Text(\"Hello World\")\n+    Button(\"Click Me\") { }"
  }]
}
EOF

# 4. Evaluate (triggers AOI detection)
npx @mdp-framework/mlang@1.1.28 evaluate --file test-violation.json --policy ui.alloy.governance

# 5. Query detected components
npx @mdp-framework/mlang@1.1.28 aoi query --status detected

# 6. Check stats
npx @mdp-framework/mlang@1.1.28 aoi stats
```

## Verification

To verify the complete setup:

```bash
# Check PostgreSQL is running
docker ps | grep mdp-postgres

# Check database schema
docker exec mdp-postgres psql -U postgres -d mdp_aoi -c "\dt"

# Check AOI configuration in policy
cat .mlang/policies/ui.alloy.governance.json | jq '.aoi'

# Check config points to PostgreSQL
grep "dsn:" .mlang/config.yaml
```

Expected outputs:
- PostgreSQL container running on port 5432
- `aoi_state` table exists
- Policy JSON includes AOI configuration
- Config DSN points to `postgresql://...`

## Troubleshooting

### PostgreSQL Connection Failed

```bash
# Check if PostgreSQL is running
docker ps | grep postgres

# Check connection
docker exec mdp-postgres pg_isready -U postgres

# View logs
docker logs mdp-postgres
```

### AOI State Not Persisting

```bash
# Verify migrations ran
docker exec mdp-postgres psql -U postgres -d mdp_aoi -c "SELECT * FROM aoi_state LIMIT 1;"

# Check permissions
docker exec mdp-postgres psql -U postgres -d mdp_aoi -c "\dp aoi_state"
```

### Policy Missing AOI Field

```bash
# Rebuild policies with latest CLI
npx @mdp-framework/mlang@1.1.28 policy build --in policies --out .mlang/policies

# Verify AOI field present
cat .mlang/policies/ui.alloy.governance.json | jq '.aoi'
```

## Next Steps

1. **Enable Automatic PR Creation**: Set `auto_create_counter_pr: true` in policy
2. **Configure Webhook Handler**: Set up automated state transitions
3. **Add More Policies**: Create AOI-enabled policies for other frameworks
4. **Monitor Dashboard**: Use `mlang aoi stats` to track component requests
5. **Integrate CI/CD**: Run evaluations in GitHub Actions workflow

## Resources

- **Policy Schema**: `/packages/schemas/src/policy-card.schema.json`
- **AOI Coordinator**: `/packages/gateway/src/aoi/coordinator.ts`
- **State Store**: `/packages/gateway/src/aoi/postgres-state-store.ts`
- **CLI Commands**: `npx @mdp-framework/mlang aoi --help`
