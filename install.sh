#!/usr/bin/env bash
# Installer for xtool-cli

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="${HOME}/.local/bin"
CONFIG_DIR="${HOME}/.config/xtool-cli"

echo "Installing xtool-cli..."

# Create install directory
mkdir -p "${INSTALL_DIR}"

# Copy the main scripts
cp "${SCRIPT_DIR}/xtool-create" "${INSTALL_DIR}/xtool-create"
cp "${SCRIPT_DIR}/xtool-update" "${INSTALL_DIR}/xtool-update"
chmod +x "${INSTALL_DIR}/xtool-create"
chmod +x "${INSTALL_DIR}/xtool-update"

# Create config directory
mkdir -p "${CONFIG_DIR}"

# Copy templates
cp -r "${SCRIPT_DIR}/templates" "${CONFIG_DIR}/"

# Create default config if not exists
CONFIG_FILE="${CONFIG_DIR}/config.yaml"
if [[ ! -f "${CONFIG_FILE}" ]]; then
    cat > "${CONFIG_FILE}" << 'EOF'
# xtool-cli configuration
# Copy this file to ~/.config/xtool-cli/config.yaml and customize

# Default author name
author: "Your Name"

# Default Apple Developer Team ID (optional)
# team_id: "ABC1234567"

# Default target base directory
target_base_dir: "~/Documents/xtool-apps"

# Default bundle ID prefix
bundle_id_prefix: "com.yourname"

# GitHub settings
github:
  create_by_default: false
  private_by_default: false

# xtool settings
xtool:
  vphone_cid: 3
  install_script: "~/Documents/vphone-linux/tools/install-ipa.py"
EOF
    echo "Created default config at ${CONFIG_FILE}"
fi

# Check if install directory is in PATH
if [[ ":${PATH}:" != *":${INSTALL_DIR}:"* ]]; then
    echo ""
    echo "⚠️  ${INSTALL_DIR} is not in your PATH"
    echo "Add this to your shell config (.zshrc, .bashrc, etc.):"
    echo "  export PATH=\"\${HOME}/.local/bin:\${PATH}\""
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "Commands:"
echo "  xtool-create MyApp                    # Create new iOS app with Xcode + xtool + git"
echo "  xtool-create MyApp --github           # Also create GitHub repo"
echo "  xtool-update ~/Documents/xtool-apps/MyApp  # Update xtool symlinks for existing project"
echo ""
echo "Config file: ${CONFIG_FILE}"