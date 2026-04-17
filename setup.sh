#!/bin/bash

set -euo pipefail

echo "🔍 Checking for Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
  echo "❌ Homebrew not found. Install from https://brew.sh/"
  exit 1
fi

echo "🔍 Checking if holmesgpt is installed..."
if ! command -v holmesgpt >/dev/null 2>&1; then
  echo "⬇️ Installing HolmesGPT..."
  brew update
  brew tap robusta-dev/homebrew-holmesgpt
  brew install holmesgpt
else
  echo "✅ holmesgpt already installed"
fi

# Verify installation
if ! command -v holmesgpt >/dev/null 2>&1; then
  echo "❌ holmesgpt installation failed"
  exit 1
fi

echo "📁 Setting up configuration..."

CONFIG_DIR="$HOME/.holmes"
CONFIG_FILE="$CONFIG_DIR/config.yaml"

mkdir -p "$CONFIG_DIR"

# Backup existing config if present
if [ -f "$CONFIG_FILE" ]; then
  echo "📦 Backing up existing config..."
  cp "$CONFIG_FILE" "$CONFIG_FILE.bak.$(date +%s)"
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
holmesgpt version || {
  echo "❌ HolmesGPT verification failed"
  exit 1
}

echo "🎉 HolmesGPT setup complete!"
