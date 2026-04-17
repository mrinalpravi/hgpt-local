#!/bin/bash

set -e

echo "🔍 Checking for Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
  echo "❌ Homebrew not found. Please install Homebrew first:"
  echo "   https://brew.sh/"
  exit 1
fi

echo "🔍 Checking if holmesgpt is installed..."
if ! command -v holmesgpt >/dev/null 2>&1; then
  echo "⬇️ Installing holmesgpt..."
  brew tap robusta-dev/homebrew-tap || true
  brew install holmesgpt
else
  echo "✅ holmesgpt already installed"
fi

CONFIG_DIR="$HOME/.holmes"
CONFIG_FILE="$CONFIG_DIR/config.yaml"

echo "📁 Ensuring config directory exists..."
mkdir -p "$CONFIG_DIR"

echo "📝 Writing config to $CONFIG_FILE..."

cat > "$CONFIG_FILE" <<EOF
model: bedrock/us.anthropic.claude-sonnet-4-20250514-v1:0
toolsets:
  kubevela/core:
    enable: true
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

echo "✅ Configuration written successfully!"

echo "🎉 HolmesGPT setup complete!"
