#!/bin/bash

set -euo pipefail

echo "🔍 Checking for Homebrew..."

BREW_BIN="$(command -v brew || true)"

if [ -z "$BREW_BIN" ]; then
  echo "❌ Homebrew not found. Install from https://brew.sh/"
  exit 1
fi

echo "✅ Homebrew found at: $BREW_BIN"

# Ensure correct PATH using brew prefix
BREW_PREFIX="$($BREW_BIN --prefix)"
export PATH="$BREW_PREFIX/bin:$BREW_PREFIX/sbin:$PATH"

echo "🔧 Using Homebrew prefix: $BREW_PREFIX"

echo "🔍 Checking if Holmes is installed..."

if ! brew list holmesgpt >/dev/null 2>&1; then
  echo "⬇️ Installing HolmesGPT..."
  brew update
  brew tap robusta-dev/homebrew-holmesgpt
  brew install holmesgpt
else
  echo "✅ Holmes already installed"
fi

echo "🔗 Ensuring Holmes is linked..."
brew link holmesgpt >/dev/null 2>&1 || true

# ✅ Correct binary check
HOLMES_BIN="$(command -v holmes || true)"

if [ -z "$HOLMES_BIN" ]; then
  echo "❌ holmes CLI not found even after install"
  echo "👉 Try restarting terminal or check brew doctor"
  exit 1
fi

echo "✅ holmes available at: $HOLMES_BIN"

echo "📁 Setting up configuration..."

CONFIG_DIR="$HOME/.holmes"
CONFIG_FILE="$CONFIG_DIR/config.yaml"

mkdir -p "$CONFIG_DIR"

# Backup existing config
if [ -f "$CONFIG_FILE" ]; then
  BACKUP_FILE="$CONFIG_FILE.bak.$(date +%s)"
  echo "📦 Backing up existing config to $BACKUP_FILE"
  cp "$CONFIG_FILE" "$BACKUP_FILE"
fi

echo "📝 Writing config..."

cat > "$CONFIG_FILE" <<EOF
model: bedrock/us.anthropic.claude-sonnet-4-20250514-v1:0
toolsets:
  kubevela/core:
    enabled: true
  kubernetes/core:
    enabled: true
  kubernetes/logs:
    enabled: true
  kubernetes/live_metrics:
    enabled: true
    description: "Live metrics and monitoring for Kubernetes resources"
  kubernetes/resource_lineage_extras:
    enabled: true
    description: "Extended resource lineage tracking and dependency analysis"
EOF

echo "✅ Config written to $CONFIG_FILE"

echo "🔍 Verifying Holmes..."

holmes version

echo "🎉 Holmes setup complete!"

# Optional Kubernetes check
if command -v kubectl >/dev/null 2>&1; then
  echo "🔍 Checking Kubernetes access..."
  if kubectl get nodes >/dev/null 2>&1; then
    echo "✅ Kubernetes access OK"
  else
    echo "⚠️ kubectl installed but cluster not accessible"
  fi
fi
