---
name: aws-ada
description: Use before any AWS CLI call, aws tool invocation, or AWS credential/profile access. Covers ADA profile discovery, usage, naming, and safety rules. Triggers on aws, ada, profile, credentials, account lookup.
version: 1.0.0
---

# AWS Access via ADA Profiles

## Overview
All AWS access uses ADA (Amazon Developer Access) profiles via Conduit. ADA provides temporary credentials via `credential_process` in `~/.aws/config`. You MUST use `--profile <name>` with every `use_aws` or `aws` CLI call.

All accounts are Conduit accounts. The default admin role is `IibsAdminAccess-DO-NOT-DELETE`. Only use a different role if explicitly told to.

## Discovering Profiles

**ALWAYS use `ada profile list` to discover available profiles.** Do NOT read or parse `~/.aws/config` directly — it contains credential_process entries managed by ADA and reading it provides no useful information beyond what `ada profile list` already shows.

```bash
ada profile list                        # List all configured profiles
ada profile print --profile=<name>      # Show details for a specific profile
```

## Using Profiles

ALWAYS pass `--profile` when making AWS calls:
```bash
aws sts get-caller-identity --profile <name>
```

With the `use_aws` tool, set `profile_name`:
```
use_aws(service_name="sts", operation_name="get-caller-identity", profile_name="<name>", region="us-west-2")
```

## Adding Profiles

```bash
ada profile add --profile <name> --provider conduit --account <account_id> --role IibsAdminAccess-DO-NOT-DELETE
```

**Adding a production read-only profile:**
```bash
ada profile add --profile <name> --provider conduit --account <account_id> --role IibsAdminAccess-DO-NOT-DELETE --conduit-read-only
```
The `--conduit-read-only` flag grants read-only credentials regardless of the role's actual permissions. Use this when creating `*ProdReadOnly` profiles.

## Looking Up Account Information

When the user provides an account ID but no account name, use `ReadInternalWebsites` to look it up:

```
https://iad.merlon.amazon.dev/account/aws/<ACCOUNT_ID>
```

This returns: `name`, `description`, `owner`, `bindle`, and `CTI` for the account.

Use the returned name to suggest an appropriate profile name.

## Profile Naming Convention

Pattern: `<ServiceName><Environment>[Role]`

| Suffix/Pattern | Meaning | Example |
|---|---|---|
| `Alpha` | Alpha/dev environment | `HRSAlpha` |
| `Beta` | Beta/test environment | `HRSBeta` |
| `Gamma` | Gamma/pre-prod environment | `HRSGamma` |
| `Prod` | Production (use caution) | `HRSProd` |
| `ProdAdmin` | Production with admin access (DANGEROUS) | `HRSProdAdmin` |
| `ProdReadOnly` | Production read-only (SAFE) | `InterviewDBProdReadOnly` |
| `Dev<alias>` | Personal dev account | `DevMkarpoff` |

## Safety Rules

1. **ALWAYS prefer ReadOnly profiles** for production — use `*ProdReadOnly` over `*Prod` or `*ProdAdmin`
2. **NEVER use ProdAdmin profiles** unless the user explicitly requests it and the operation requires write access
3. **Use Beta/Alpha profiles** for testing and development
4. **When environment is ambiguous**, ask the user which environment they mean
5. **For destructive operations** in prod, confirm with the user first

## Credential Errors

If you see `ExpiredToken`, `InvalidClientTokenId`, or `credentials not found`:
1. Credentials auto-refresh via `credential_process` — retry first
2. Ask the user to run `mwinit` to refresh Midway authentication. **Do NOT run `mwinit` yourself.**
3. Verify the profile exists: `ada profile list`

## Important: Do NOT Read ~/.aws/config

The `~/.aws/config` file is managed by ADA and contains only `credential_process` directives. **Never** read, parse, grep, or cat this file. All profile information is available through `ada profile list` and `ada profile print`. Reading `.aws/config` directly provides no additional value and can lead to incorrect assumptions about available credentials.
