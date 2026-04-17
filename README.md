# 🧠 HolmesGPT Setup Guide (macOS)

## 📌 Prerequisites

- macOS machine
- Homebrew installed  
  Check:
  ```bash
  brew --version
  ```

---

## 🚀 Step 1: Install HolmesGPT

```bash
brew tap robusta-dev/homebrew-tap
brew install holmesgpt
```

Verify installation:

```bash
holmesgpt --help
```

---

## ⚙️ Step 2: Create Configuration

Create config directory:

```bash
mkdir -p ~/.holmes
```

Create and edit config file:

```bash
vi ~/.holmes/config.yaml
```

Paste the following:

```yaml
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
```

Save and exit:
- Press `Esc`
- Type `:wq`
- Press `Enter`

---

## ✅ Step 3: Verify Setup

```bash
holmesgpt
```

---

## 🧪 Optional: Quick Test

```bash
holmesgpt ask "Why is my pod crashing?"
```

---

## ⚠️ Common Issues

### 1. `command not found: brew`
Install Homebrew:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---

### 2. HolmesGPT not found after install

```bash
export PATH="/opt/homebrew/bin:$PATH"
```

Then reload:
```bash
source ~/.zshrc
```

---

## 🎉 Done!

HolmesGPT is now ready to troubleshoot your Kubernetes workloads 🚀

