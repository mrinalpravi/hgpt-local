#!/bin/bash

set -euo pipefail

echo "🔍 Checking for Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
  echo "❌ Homebrew not found. Install from https://brew.sh/"
  exit 1
fi

# Ensure brew shellenv is loaded (fixes PATH issues in scripts)
if [[ -d "/opt/homebrew/bin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -d "/usr/local/bin" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

echo "🔍 Checking if holmesgpt is installed..."
if ! brew list holmesgpt >/dev/null 2>&1; then
  echo "⬇️ Installing HolmesGPT..."
  brew update
  brew tap robusta-dev/homebrew-holmesgpt
  brew install holmesgpt
else
  echo "✅ holmesgpt already installed"
fi

echo "🔗 Ensuring holmesgpt is linked..."
brew link holmesgpt >/dev/null 2>&1 || true

# Final verification with PATH fixed
if ! command -v holmesgpt >/dev/null 2>&1; then
  echo "❌ holmesgpt installed but not found in PATH"
  echo "👉 Add this to your shell config (~/.zshrc or ~/.bashrc):"
  echo '   eval "$(/opt/homebrew/bin/brew shellenv)"'
  exit 1
fi

echo "✅ holmesgpt available at: $(which holmesgpt)"

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

echo "🔍 Verifying HolmesGPT..."
holmesgpt version

echo "🎉 HolmesGPT setup complete!"

# Optional: Kubernetes check
if command -v kubectl >/dev/null 2>&1; then
  echo "🔍 Checking Kubernetes access..."
  if kubectl get nodes >/dev/null 2>&1; then
    echo "✅ Kubernetes access OK"
  else
    echo "⚠️ kubectl installed but cluster not accessible"
  fi
fi
