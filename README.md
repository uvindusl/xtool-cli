# xtool-cli

CLI tool to automate iOS app creation with Xcode + xtool + git for vphone development.

## Overview

This tool automates the workflow for developing iOS apps on a remote Mac using xtool and vphone emulator:

1. **Creates Xcode project** from template with proper structure
2. **Sets up xtool project** with symlinks to Swift source files (so you edit once, run everywhere)
3. **Initializes git repository** with proper .gitignore
4. **Pushes to target directory** (bare repo at `~/Documents/xtool-apps/<AppName>`)
5. **Optionally creates GitHub repository** and pushes

## Installation

```bash
# Clone or download this repository
cd xtool-cli
./install.sh
```

This installs `xtool-create` to `~/.local/bin` and creates a config file at `~/.config/xtool-cli/config.yaml`.

Make sure `~/.local/bin` is in your PATH:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Configuration

Edit `~/.config/xtool-cli/config.yaml` with your settings:

```yaml
author: "Your Name"
team_id: "ABC1234567"  # Optional Apple Developer Team ID
target_base_dir: "~/Documents/xtool-apps"
bundle_id_prefix: "com.yourname"
github:
  create_by_default: false
  private_by_default: false
xtool:
  vphone_cid: 3
  install_script: "~/Documents/vphone-linux/tools/install-ipa.py"
```

## Usage

```bash
# Basic usage (uses config defaults)
xtool-create MyApp

# With custom bundle ID and author
xtool-create MyApp --bundle-id com.mycompany.myapp --author "John Doe"

# With Apple Developer Team ID
xtool-create MyApp --team-id ABC1234567

# Create GitHub repository (public)
xtool-create MyApp --github

# Create GitHub repository (private)
xtool-create MyApp --github --private

# Custom target directory
xtool-create MyApp --target-dir ~/Documents/xtool-apps/MyApp

# Dry run (show what would be created)
xtool-create MyApp --dry-run

# Skip GitHub creation
xtool-create MyApp --no-github
```

## Workflow After Creation

After running `xtool-create MyApp`, you'll have:

```
~/Documents/xtool-apps/MyApp/           # Xcode project (edit Swift files here)
├── MyApp.xcodeproj/
├── MyApp/
│   ├── ContentView.swift
│   └── MyAppApp.swift
└── .git/                               # Git repo with bare remote

~/Documents/xtool-apps/MyApp-xtool/     # xtool project (symlinks to Xcode sources)
├── Sources/MyApp/
│   ├── ContentView.swift -> ../../MyApp/MyApp/ContentView.swift
│   └── MyAppApp.swift -> ../../MyApp/MyApp/MyAppApp.swift
├── Package.swift
├── xtool.yml
└── vrun.sh
```

### Cross-Platform Development (Mac + Linux)

This setup lets you develop the **same project** on both Mac and Linux:

| Platform | Tool | What Works |
|----------|------|------------|
| **Mac** | Xcode | Full IDE, Simulator, Device, Interface Builder, SwiftUI Previews |
| **Linux** | xtool + vphone | Build IPA, Install to emulator, Run app |

**The Xcode project IS the source of truth** — it's a real, standard Xcode project. The xtool project symlinks to the same Swift files.

```
┌─────────────────────────────────────────────────────────────────┐
│                    SAME PROJECT FILES                           │
├─────────────────────────────────────────────────────────────────┤
│  ~/Documents/xtool-apps/MyApp/                                  │
│  ├── MyApp.xcodeproj/          ← REAL Xcode project (Mac)      │
│  │   └── project.pbxproj                                          │
│  ├── MyApp/                    ← Swift source files (shared)    │
│  │   ├── ContentView.swift                                        │
│  │   └── MyAppApp.swift                                           │
│  └── .git/                                                            │
└─────────────────────────────────────────────────────────────────┘
                              │
          ┌───────────────────┴───────────────────┐
          ▼                                       ▼
    ┌───────────────┐                       ┌───────────────┐
    │   ON MAC      │                       │   ON LINUX    │
    │               │                       │               │
    │ Open in Xcode │                       │ xtool + vphone│
    │ Build/Run on  │                       │ Build IPA     │
    │ Simulator/    │                       │ Install to    │
    │ Device        │                       │ vphone VM     │
    │               │                       │               │
    │ Edit Swift    │◄─── SYMLINKS ────────►│ Edit same     │
    │ files         │                       │ Swift files   │
    └───────────────┘                       └───────────────┘
```

**On Mac (Your MacBook via Remote Desktop)**
```bash
# Open in Xcode - full native experience
open ~/Documents/xtool-apps/MyApp/MyApp.xcodeproj
# Edit Swift files normally
# Commit/push from Xcode or terminal
```

**On Linux (Your Current Setup with xtool + vphone)**
```bash
# Build and run on vphone emulator
cd ~/Documents/xtool-apps/MyApp-xtool
./vrun.sh
# Uses same Swift files via symlinks
# No Xcode needed on Linux
```

### Development Workflow

1. **Edit Swift files** in `~/Documents/xtool-apps/MyApp/MyApp/` (Xcode project)
2. **Build and run on vphone**:
   ```bash
   cd ~/Documents/xtool-apps/MyApp-xtool
   ./vrun.sh
   ```
3. **Commit and push changes** using **AI-assisted commits** (see below)

The symlinks ensure that changes to Swift files in the Xcode project are immediately reflected in the xtool project.

### Sync Between Machines

```bash
# On either machine - push your changes
git push

# On the other machine - pull latest
git pull
```

---

## AI-Assisted Git Workflow (Claude Code)

This project includes git aliases for AI-powered commits using **Claude Code** (`claude` CLI).

### One-Time Setup (Run Once)

Add these aliases to your git config:

```bash
# Global (all repos) - recommended
git config --global alias.ac '!f() { git diff --cached | claude -p "Write a conventional commit message (type: subject). Only output the message, no explanation." | head -1 | xargs -I {} git commit -m {}; }; f'
git config --global alias.acp '!git add -A && git ac && git push'
git config --global alias.ai-commit '!f() { git add -A && git diff --cached | claude -p "Write a detailed conventional commit message for this diff:" | git commit -F -; }; f'
```

Or per-repo (in your Xcode project folder):
```bash
cd ~/Documents/xtool-apps/MyApp
git config alias.ac '!f() { git diff --cached | claude -p "Write a conventional commit message (type: subject). Only output the message, no explanation." | head -1 | xargs -I {} git commit -m {}; }; f'
git config alias.acp '!git add -A && git ac && git push'
git config alias.ai-commit '!f() { git add -A && git diff --cached | claude -p "Write a detailed conventional commit message for this diff:" | git commit -F -; }; f'
```

### Daily Usage

| Command | What It Does |
|---------|--------------|
| `git acp` | **Add all + AI commit + push** (recommended) |
| `git ac` | Stage files first, then AI commit |
| `git ai-commit` | Add all + AI writes detailed message |
| `git add -A && git ac` | Manual stage + AI commit |

### Workflow Examples

```bash
# 1. Make changes to Swift files
# 2. One command does everything:
cd ~/Documents/xtool-apps/MyApp
git acp
# ✅ Stages all changes
# ✅ Claude generates commit message from diff
# ✅ Commits with that message
# ✅ Pushes to origin

# Or with custom message:
git add -A
git commit -m "feat: add combo multiplier system"
git push
```

### Conventional Commit Format

The AI generates messages following [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add new game mode
fix: resolve timer reset bug
chore: update dependencies
refactor: simplify ContentView logic
docs: add README for xtool setup
style: fix formatting in Tap_FrenzyApp.swift
test: add unit tests for scoring logic
```

### Prerequisites

- **Claude Code CLI** (`claude` command) installed and authenticated
- **Git** configured with user.name and user.email
- Run inside your Xcode project directory (`~/Documents/xtool-apps/MyApp`)

---

## Template Customization

Templates are located in `~/.config/xtool-cli/templates/` after installation. You can customize:

- `templates/xcode-project/` - Xcode project structure
- `templates/xtool-project/` - xtool project structure

## Requirements

- Python 3.6+
- git
- xtool (for building/running on vphone)
- vphone-linux (for iOS emulator)
- gh CLI (optional, for GitHub repository creation)

## License

MIT