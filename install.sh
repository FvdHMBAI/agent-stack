#!/usr/bin/env bash
set -euo pipefail

# AgentStack Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/FvdHMBAI/agent-stack/main/install.sh | bash

VERSION="1.0.0"
INSTALL_DIR="${AGENT_STACK_DIR:-$HOME/.agent-stack}"
BIN_DIR="${AGENT_STACK_BIN:-/usr/local/bin}"
GITHUB_ORG="FvdHMBAI"

COMPONENTS=(
  "guardrail"
  "model-router"
  "nightshift"
  "graphify-toolkit"
  "autonomie-os"
)

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

info()  { echo -e "${BLUE}[info]${NC}  $*"; }
ok()    { echo -e "${GREEN}[ok]${NC}    $*"; }
warn()  { echo -e "${YELLOW}[warn]${NC}  $*"; }
fail()  { echo -e "${RED}[fail]${NC}  $*"; exit 1; }
step()  { echo -e "\n${CYAN}${BOLD}>>> $*${NC}"; }

banner() {
  echo -e "${BOLD}"
  echo '    _                    _   ____  _             _    '
  echo '   / \   __ _  ___ _ __ | |_/ ___|| |_ __ _  ___| | __'
  echo '  / _ \ / _` |/ _ \ '\''_ \| __\___ \| __/ _` |/ __| |/ /'
  echo ' / ___ \ (_| |  __/ | | | |_ ___) | || (_| | (__|   < '
  echo '/_/   \_\__, |\___|_| |_|\__|____/ \__\__,_|\___|_|\_\'
  echo '        |___/                                         '
  echo -e "${NC}"
  echo -e "  ${BOLD}The Open-Source AI Agent Operating System${NC}"
  echo -e "  Version ${VERSION}"
  echo ""
}

check_command() {
  if ! command -v "$1" &>/dev/null; then
    fail "Required command not found: $1. Please install it first."
  fi
}

check_bash_version() {
  local major="${BASH_VERSINFO[0]}"
  if [[ "$major" -lt 4 ]]; then
    fail "Bash 4+ required (found ${BASH_VERSION}). On macOS: brew install bash"
  fi
}

detect_os() {
  local os
  os=$(uname -s)
  case "$os" in
    Linux)  echo "linux" ;;
    Darwin) echo "macos" ;;
    *)      echo "unknown" ;;
  esac
}

main() {
  banner

  step "Checking prerequisites"
  check_bash_version
  ok "Bash ${BASH_VERSION}"

  for cmd in git curl jq; do
    check_command "$cmd"
    ok "$cmd found"
  done

  local os
  os=$(detect_os)
  info "Detected OS: $os"

  if [[ "$os" == "unknown" ]]; then
    warn "Unsupported OS. Installation may work but is untested."
  fi

  step "Creating install directory: $INSTALL_DIR"
  mkdir -p "$INSTALL_DIR"
  ok "Directory ready"

  step "Cloning components"
  local installed=0
  local failed_components=()

  for component in "${COMPONENTS[@]}"; do
    local target="$INSTALL_DIR/$component"
    if [[ -d "$target/.git" ]]; then
      info "$component already exists, pulling latest..."
      if git -C "$target" pull --quiet 2>/dev/null; then
        ok "$component updated"
        installed=$((installed + 1))
      else
        warn "$component update failed, skipping"
        installed=$((installed + 1))
      fi
    else
      info "Cloning $component..."
      if git clone --quiet "https://github.com/$GITHUB_ORG/$component.git" "$target" 2>/dev/null; then
        ok "$component cloned"
        installed=$((installed + 1))
      else
        warn "Failed to clone $component"
        failed_components+=("$component")
      fi
    fi
  done

  step "Running component installers"
  for component in "${COMPONENTS[@]}"; do
    local target="$INSTALL_DIR/$component"
    if [[ -f "$target/install.sh" ]]; then
      info "Installing $component..."
      if bash "$target/install.sh" 2>/dev/null; then
        ok "$component installed"
      else
        warn "$component installer returned non-zero (may still work)"
      fi
    else
      info "$component has no installer, skipping"
    fi
  done

  step "Installing CLI"
  local cli_source
  cli_source="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/agent-stack"

  if [[ ! -f "$cli_source" ]]; then
    cli_source="$INSTALL_DIR/agent-stack-cli"
    curl -fsSL "https://raw.githubusercontent.com/$GITHUB_ORG/agent-stack/main/agent-stack" -o "$cli_source" 2>/dev/null || true
  fi

  if [[ -f "$cli_source" ]]; then
    if [[ -w "$BIN_DIR" ]]; then
      cp "$cli_source" "$BIN_DIR/agent-stack"
      chmod +x "$BIN_DIR/agent-stack"
      ok "CLI installed to $BIN_DIR/agent-stack"
    else
      info "Need sudo to install to $BIN_DIR"
      sudo cp "$cli_source" "$BIN_DIR/agent-stack"
      sudo chmod +x "$BIN_DIR/agent-stack"
      ok "CLI installed to $BIN_DIR/agent-stack"
    fi
  else
    warn "CLI wrapper not found. You can run components directly from $INSTALL_DIR"
  fi

  echo "$INSTALL_DIR" > "$INSTALL_DIR/.install-path"
  echo "$VERSION" > "$INSTALL_DIR/.version"

  step "Installation complete"
  echo ""
  echo -e "  ${GREEN}${BOLD}$installed/${#COMPONENTS[@]} components installed${NC}"
  if [[ ${#failed_components[@]} -gt 0 ]]; then
    echo -e "  ${YELLOW}Failed: ${failed_components[*]}${NC}"
  fi
  echo ""
  echo -e "  ${BOLD}Quick start:${NC}"
  echo "    agent-stack doctor     # verify installation"
  echo "    agent-stack status     # see component status"
  echo "    agent-stack guard init # set up guardrails for a project"
  echo ""
  echo -e "  ${BOLD}Documentation:${NC} https://github.com/$GITHUB_ORG/agent-stack"
  echo ""
}

main "$@"
