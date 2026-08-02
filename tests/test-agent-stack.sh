#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# ─── Test Framework ───

TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0
FAILURES=""

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

assert_eq() {
  local expected="$1" actual="$2" msg="${3:-assertion}"
  TESTS_RUN=$((TESTS_RUN + 1))
  if [[ "$expected" == "$actual" ]]; then
    TESTS_PASSED=$((TESTS_PASSED + 1))
    echo -e "  ${GREEN}PASS${NC} $msg"
  else
    TESTS_FAILED=$((TESTS_FAILED + 1))
    FAILURES="${FAILURES}\n  FAIL: ${msg} (expected '${expected}', got '${actual}')"
    echo -e "  ${RED}FAIL${NC} $msg"
  fi
}

assert_contains() {
  local haystack="$1" needle="$2" msg="${3:-contains assertion}"
  TESTS_RUN=$((TESTS_RUN + 1))
  if echo "$haystack" | grep -qF "$needle"; then
    TESTS_PASSED=$((TESTS_PASSED + 1))
    echo -e "  ${GREEN}PASS${NC} $msg"
  else
    TESTS_FAILED=$((TESTS_FAILED + 1))
    FAILURES="${FAILURES}\n  FAIL: ${msg} (needle '${needle}' not found)"
    echo -e "  ${RED}FAIL${NC} $msg"
  fi
}

assert_file_exists() {
  local path="$1" msg="${2:-file exists}"
  TESTS_RUN=$((TESTS_RUN + 1))
  if [[ -f "$path" ]]; then
    TESTS_PASSED=$((TESTS_PASSED + 1))
    echo -e "  ${GREEN}PASS${NC} $msg"
  else
    TESTS_FAILED=$((TESTS_FAILED + 1))
    FAILURES="${FAILURES}\n  FAIL: ${msg} (not found: $path)"
    echo -e "  ${RED}FAIL${NC} $msg"
  fi
}

assert_executable() {
  local path="$1" msg="${2:-is executable}"
  TESTS_RUN=$((TESTS_RUN + 1))
  if [[ -x "$path" ]]; then
    TESTS_PASSED=$((TESTS_PASSED + 1))
    echo -e "  ${GREEN}PASS${NC} $msg"
  else
    TESTS_FAILED=$((TESTS_FAILED + 1))
    FAILURES="${FAILURES}\n  FAIL: ${msg} (not executable: $path)"
    echo -e "  ${RED}FAIL${NC} $msg"
  fi
}

echo ""
echo "============================================"
echo "  AgentStack Test Suite"
echo "============================================"

# ─── File Structure ───

echo ""
echo "=== File Structure ==="

assert_file_exists "$PROJECT_DIR/install.sh" "install.sh exists"
assert_file_exists "$PROJECT_DIR/agent-stack" "agent-stack CLI exists"
assert_file_exists "$PROJECT_DIR/README.md" "README.md exists"
assert_file_exists "$PROJECT_DIR/LICENSE" "LICENSE exists"
assert_file_exists "$PROJECT_DIR/docker-compose.yml" "docker-compose.yml exists"
assert_file_exists "$PROJECT_DIR/Dockerfile" "Dockerfile exists"
assert_file_exists "$PROJECT_DIR/.github/workflows/ci.yml" "CI workflow exists"

# ─── Executability ───

echo ""
echo "=== Executability ==="

chmod +x "$PROJECT_DIR/install.sh" "$PROJECT_DIR/agent-stack"
assert_executable "$PROJECT_DIR/install.sh" "install.sh is executable"
assert_executable "$PROJECT_DIR/agent-stack" "agent-stack is executable"

# ─── CLI Help ───

echo ""
echo "=== CLI Help ==="

help_output=$(bash "$PROJECT_DIR/agent-stack" help 2>&1)
assert_contains "$help_output" "guard" "help mentions guard"
assert_contains "$help_output" "route" "help mentions route"
assert_contains "$help_output" "night" "help mentions night"
assert_contains "$help_output" "graph" "help mentions graph"
assert_contains "$help_output" "auto" "help mentions auto"
assert_contains "$help_output" "status" "help mentions status"
assert_contains "$help_output" "doctor" "help mentions doctor"
assert_contains "$help_output" "version" "help mentions version"

# ─── CLI Version ───

echo ""
echo "=== CLI Version ==="

version_output=$(bash "$PROJECT_DIR/agent-stack" version 2>&1)
assert_contains "$version_output" "AgentStack" "version shows AgentStack"
assert_contains "$version_output" "1.0.0" "version shows 1.0.0"

# ─── CLI Unknown Command ───

echo ""
echo "=== Error Handling ==="

unknown_output=$(bash "$PROJECT_DIR/agent-stack" nonexistent 2>&1 || true)
assert_contains "$unknown_output" "Unknown command" "unknown command shows error"

# ─── Subcommand Help ───

echo ""
echo "=== Subcommand Help ==="

guard_help=$(AGENT_STACK_DIR=/nonexistent bash "$PROJECT_DIR/agent-stack" guard help 2>&1 || true)
assert_contains "$guard_help" "GuardRail" "guard help mentions GuardRail"

route_help=$(AGENT_STACK_DIR=/nonexistent bash "$PROJECT_DIR/agent-stack" route help 2>&1 || true)
assert_contains "$route_help" "Model Router" "route help mentions Model Router"

night_help=$(AGENT_STACK_DIR=/nonexistent bash "$PROJECT_DIR/agent-stack" night help 2>&1 || true)
assert_contains "$night_help" "Night Shift" "night help mentions Night Shift"

graph_help=$(AGENT_STACK_DIR=/nonexistent bash "$PROJECT_DIR/agent-stack" graph help 2>&1 || true)
assert_contains "$graph_help" "Graphify" "graph help mentions Graphify"

auto_help=$(AGENT_STACK_DIR=/nonexistent bash "$PROJECT_DIR/agent-stack" auto help 2>&1 || true)
assert_contains "$auto_help" "Autonomie OS" "auto help mentions Autonomie OS"

# ─── Doctor ───

echo ""
echo "=== Doctor ==="

doctor_output=$(bash "$PROJECT_DIR/agent-stack" doctor 2>&1)
assert_contains "$doctor_output" "Prerequisites" "doctor shows prerequisites"
assert_contains "$doctor_output" "bash" "doctor checks bash"
assert_contains "$doctor_output" "git" "doctor checks git"
assert_contains "$doctor_output" "curl" "doctor checks curl"
assert_contains "$doctor_output" "jq" "doctor checks jq"

# ─── Status ───

echo ""
echo "=== Status ==="

status_output=$(bash "$PROJECT_DIR/agent-stack" status 2>&1)
assert_contains "$status_output" "GuardRail" "status shows GuardRail"
assert_contains "$status_output" "Model Router" "status shows Model Router"
assert_contains "$status_output" "Night Shift" "status shows Night Shift"
assert_contains "$status_output" "Graphify" "status shows Graphify"
assert_contains "$status_output" "Autonomie OS" "status shows Autonomie OS"

# ─── Install Script Syntax ───

echo ""
echo "=== Install Script ==="

install_syntax=$(bash -n "$PROJECT_DIR/install.sh" 2>&1 || echo "SYNTAX_ERROR")
if [[ "$install_syntax" == *"SYNTAX_ERROR"* ]]; then
  TESTS_RUN=$((TESTS_RUN + 1))
  TESTS_FAILED=$((TESTS_FAILED + 1))
  FAILURES="${FAILURES}\n  FAIL: install.sh syntax check"
  echo -e "  ${RED}FAIL${NC} install.sh syntax check"
else
  TESTS_RUN=$((TESTS_RUN + 1))
  TESTS_PASSED=$((TESTS_PASSED + 1))
  echo -e "  ${GREEN}PASS${NC} install.sh syntax check"
fi

cli_syntax=$(bash -n "$PROJECT_DIR/agent-stack" 2>&1 || echo "SYNTAX_ERROR")
if [[ "$cli_syntax" == *"SYNTAX_ERROR"* ]]; then
  TESTS_RUN=$((TESTS_RUN + 1))
  TESTS_FAILED=$((TESTS_FAILED + 1))
  FAILURES="${FAILURES}\n  FAIL: agent-stack CLI syntax check"
  echo -e "  ${RED}FAIL${NC} agent-stack CLI syntax check"
else
  TESTS_RUN=$((TESTS_RUN + 1))
  TESTS_PASSED=$((TESTS_PASSED + 1))
  echo -e "  ${GREEN}PASS${NC} agent-stack CLI syntax check"
fi

# ─── README Content ───

echo ""
echo "=== README Quality ==="

readme_content=$(cat "$PROJECT_DIR/README.md")
readme_lines=$(wc -l < "$PROJECT_DIR/README.md")

assert_contains "$readme_content" "Quick Start" "README has Quick Start section"
assert_contains "$readme_content" "Architecture" "README has Architecture section"
assert_contains "$readme_content" "Contributing" "README has Contributing section"
assert_contains "$readme_content" "MIT" "README mentions MIT license"
assert_contains "$readme_content" "curl" "README has install command"

TESTS_RUN=$((TESTS_RUN + 1))
if [[ "$readme_lines" -gt 100 ]]; then
  TESTS_PASSED=$((TESTS_PASSED + 1))
  echo -e "  ${GREEN}PASS${NC} README has ${readme_lines} lines (>100)"
else
  TESTS_FAILED=$((TESTS_FAILED + 1))
  FAILURES="${FAILURES}\n  FAIL: README too short (${readme_lines} lines)"
  echo -e "  ${RED}FAIL${NC} README too short (${readme_lines} lines)"
fi

# ─── Docker Compose Validity ───

echo ""
echo "=== Docker ==="

assert_contains "$(cat "$PROJECT_DIR/docker-compose.yml")" "ollama" "docker-compose has ollama service"
assert_contains "$(cat "$PROJECT_DIR/docker-compose.yml")" "postgres" "docker-compose has postgres service"
assert_contains "$(cat "$PROJECT_DIR/docker-compose.yml")" "agent-stack" "docker-compose has agent-stack service"

# ─── Shellcheck (if available) ───

echo ""
echo "=== Shellcheck ==="

if command -v shellcheck &>/dev/null; then
  for script in install.sh agent-stack; do
    TESTS_RUN=$((TESTS_RUN + 1))
    sc_output=$(shellcheck -S warning "$PROJECT_DIR/$script" 2>&1 || true)
    sc_errors=$(echo "$sc_output" | grep -c "^In " || true)
    if [[ "$sc_errors" -eq 0 ]]; then
      TESTS_PASSED=$((TESTS_PASSED + 1))
      echo -e "  ${GREEN}PASS${NC} shellcheck: $script"
    else
      TESTS_FAILED=$((TESTS_FAILED + 1))
      FAILURES="${FAILURES}\n  FAIL: shellcheck: $script ($sc_errors warnings)"
      echo -e "  ${RED}FAIL${NC} shellcheck: $script ($sc_errors warnings)"
      echo "$sc_output" | head -20
    fi
  done
else
  echo -e "  (shellcheck not available, skipping)"
fi

# ─── No German Strings ───

echo ""
echo "=== Language Check ==="

for script in install.sh agent-stack; do
  TESTS_RUN=$((TESTS_RUN + 1))
  german_lines=$(grep -cP '\xc3[\xa4\xb6\xbc\x9f]' "$PROJECT_DIR/$script" || true)
  if [[ "$german_lines" -eq 0 ]]; then
    TESTS_PASSED=$((TESTS_PASSED + 1))
    echo -e "  ${GREEN}PASS${NC} $script: no German strings"
  else
    TESTS_FAILED=$((TESTS_FAILED + 1))
    FAILURES="${FAILURES}\n  FAIL: $script has German strings ($german_lines lines)"
    echo -e "  ${RED}FAIL${NC} $script has German strings ($german_lines lines)"
  fi
done

# ─── No Internal Paths ───

echo ""
echo "=== Security ==="

TESTS_RUN=$((TESTS_RUN + 1))
internal_paths=$(grep -rnE '/opt/scripts|/opt/obsidian|88\.99\.82|178\.105\.140' \
  "$PROJECT_DIR/install.sh" "$PROJECT_DIR/agent-stack" 2>/dev/null || true)
if [[ -z "$internal_paths" ]]; then
  TESTS_PASSED=$((TESTS_PASSED + 1))
  echo -e "  ${GREEN}PASS${NC} no internal paths leaked"
else
  TESTS_FAILED=$((TESTS_FAILED + 1))
  FAILURES="${FAILURES}\n  FAIL: internal paths found"
  echo -e "  ${RED}FAIL${NC} internal paths found"
fi

# ─── Summary ───

echo ""
echo "============================================"
if [[ "$TESTS_FAILED" -eq 0 ]]; then
  echo -e "  ${GREEN}ALL $TESTS_RUN TESTS PASSED${NC}"
else
  echo -e "  ${RED}${TESTS_FAILED}/${TESTS_RUN} TESTS FAILED${NC}"
  echo ""
  echo -e "$FAILURES"
fi
echo -e "  Passed: $TESTS_PASSED  Failed: $TESTS_FAILED  Total: $TESTS_RUN"
echo "============================================"

exit "$TESTS_FAILED"
