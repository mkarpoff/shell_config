# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Context

This is the home directory for an Amazon software developer (mkarpoff). It serves as the launch point for one-off tasks and personal environment configuration. Actual code lives in Brazil workspaces at `/Volumes/workspace/` (macOS) or `/ws/` (dev-desktop).

## Environment

- **OS**: macOS (Darwin, Apple Silicon) or Amazon Linux (dev-desktop). Detect with `uname -s`.
- **Shell**: zsh with vi-mode (`bindkey -v`, `jk` mapped to Escape)
- **Editor**: vim (`$EDITOR=vim`), IdeaVim in JetBrains IDEs
- **Runtime manager**: mise (node LTS, python 3.8-3.12)
- **Package manager**: Homebrew (macOS) or yum/dnf (dev-desktop)
- **Clipboard**: `pbcopy` / `pbpaste` (native on macOS; OSC 52 shim on dev-desktop)

## Key paths

| Purpose | Path |
|---------|------|
| Brazil workspaces | `/Volumes/workspace/` (macOS) or `/ws/` (dev-desktop) |
| Toolbox binaries | `~/.toolbox/bin/` |
| Local scripts | `~/.local/bin/` |
| Claude rules | `~/.claude/rules/` |
| Claude plugins | `~/.claude/plugins/` |
| AIM-managed plugins | `~/.aim/cc-plugins/` |
| Shell config (sourced) | `~/.zsh_config`, `~/.config/brazil/rc` |
| Brazil aliases/functions | `~/.config/brazil/rc` |

## Shell aliases and functions (from ~/.config/brazil/rc)

### Brazil shortcuts
- `bb` = `brazil-build`
- `bw` = `brazil workspace`
- `brc` / `brcp` = `brazil-recursive-cmd` / parallel variant
- `bbr` / `bbrp` = recursive build / parallel recursive build
- `bbra` = `brc --all brazil-build` (all packages)

### Workspace build/test orchestration
The brazil rc defines functions for managing per-workspace build order and test configuration via dotfiles (`.build_order`, `.test_config`) at the workspace root:

- `add_build_package <path>` / `remove_build_package` / `list_build_order` / `clear_build_order`
- `build_packages [-i]` -- builds packages in `.build_order` sequentially (`-i` ignores failures)
- `add_test_package <path>` / `remove_test_package` / `list_test_packages` / `clear_test_packages`
- `run_integration_tests [-i]` -- runs `brazil-build integTest` on packages in `.test_config`

These functions require the CWD to be under the workspace root (`/Volumes/workspace/<WorkspaceName>/` on macOS, `/ws/<WorkspaceName>/` on dev-desktop).

### Other aliases
- `mwinit` = `mwinit -s`
- `cdk-dev` = `npx cdk -a "npx ts-node --prefer-ts-exts lib/app.ts"` (CDK without brazil-build)
- `notify <msg>` -- speaks a notification aloud via macOS `say` (macOS only)

## Claude Code configuration notes

- Model: Opus 4.6 (1M context) with fallback chain through Opus 4.8/4.7
- Editor mode: vim with `jk` escape remap
- Plugins: AmazonBuilderCoreAIAgents (pipeline-assistant, core), mkarpoff-skills (local)
- MCP servers: builder-mcp, slack-mcp, design-inspector-mcp, grasp-mcp (M365), local-chorus-mcp
- AWS region default: us-west-2
- Co-authored-by trailer: disabled

## Working with this directory

Since this is a home folder (not a repo), tasks initiated here are typically:
1. Environment configuration (dotfiles, shell config, Claude settings)
2. One-off investigations or queries using MCP tools
3. Workspace-level operations that span multiple Brazil workspaces
4. Personal tooling and scripts in `~/.local/bin/` or `~/.config/`

When making changes to shell config, the sourcing chain is:
`.zshrc` -> `.zsh_config` -> `~/.config/brazil/rc` (and optionally `~/.config/vpn/rc`)
