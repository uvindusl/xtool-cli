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
