# MLang Configuration

This directory contains MLang framework configuration and runtime data.

## Structure

- `config.yaml` - Main configuration file
- `keys/` - Signing keys for policy verification (commit public keys only)
- `packs/` - Compiled policy registry (build output)
  - `stable/` - Stable channel policies
  - `preview/` - Preview channel policies
  - `dev/` - Development channel policies
- `store/` - State capsule storage (file-based)
- `cache/` - Resolver cache (LKG)
- `agents/` - Agent pattern templates

## Next Steps

1. Write your policies in the `policies/` folder (Markdown format)
2. Build them: `mlang policy build`
3. Generate signing keys: `mlang keys generate`
4. Run doctor check: `mlang doctor`

For more information, see: https://docs.mdp.dev
