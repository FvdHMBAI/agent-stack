# AgentStack

[![CI](https://github.com/FvdHMBAI/agent-stack/actions/workflows/ci.yml/badge.svg)](https://github.com/FvdHMBAI/agent-stack/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**Stop building AI agents blind.** AgentStack gives you security, routing, automation, knowledge graphs, and self-improvement — in one install.

Most teams bolt together AI agent tooling piece by piece: a prompt filter here, a model proxy there, a cron job for maintenance. AgentStack is the integrated alternative — five battle-tested components that work together out of the box.

## Quick Start

```bash
# 1. Install (one command)
curl -fsSL https://raw.githubusercontent.com/FvdHMBAI/agent-stack/main/install.sh | bash

# 2. Verify
agent-stack doctor

# 3. Use
agent-stack guard init              # Set up security guardrails
eval "$(agent-stack route standard)" # Get optimal model config
agent-stack graph build              # Build knowledge graph
```

Or try with Docker:

```bash
git clone https://github.com/FvdHMBAI/agent-stack.git
cd agent-stack
docker compose up
```

## Architecture

```
                         ┌─────────────────────────────┐
                         │       agent-stack CLI        │
                         │   Unified command interface  │
                         └──────────┬──────────────────┘
                                    │
          ┌─────────────┬───────────┼───────────┬──────────────┐
          │             │           │           │              │
   ┌──────┴──────┐ ┌────┴────┐ ┌───┴────┐ ┌────┴─────┐ ┌─────┴──────┐
   │  GuardRail  │ │  Model  │ │ Night  │ │ Graphify │ │ Autonomie  │
   │             │ │ Router  │ │ Shift  │ │          │ │     OS     │
   │  Security   │ │ Routing │ │  Auto  │ │Knowledge │ │   Self-    │
   │  Guards     │ │  & Cost │ │ Maint. │ │  Graphs  │ │ Improving  │
   └─────────────┘ └─────────┘ └────────┘ └──────────┘ └────────────┘
         │               │          │           │              │
         └───────────────┴──────────┴───────────┴──────────────┘
                                    │
                         ┌──────────┴──────────┐
                         │  Ollama / Local LLM  │
                         │   (zero cloud deps)  │
                         └─────────────────────┘
```

## Components

### GuardRail — Pre-Execution Security

Intercepts and validates AI agent commands **before** they execute. Unlike prompt-level filters, GuardRail operates at the shell level — it sees the actual command, not what the LLM said it would do.

- 20 built-in guards (secrets, destructive ops, cost limits, PII)
- Custom guard API: write a bash function, drop it in a folder
- Zero dependencies, zero latency overhead
- [Repository](https://github.com/FvdHMBAI/guardrail) · [Documentation](https://github.com/FvdHMBAI/guardrail#guards)

### Model Router — Cost-Optimized LLM Routing

Routes requests to the right model at the right price. A `trivial` task goes to a local model; a `critical` task goes to the best available cloud model. No code changes needed.

- 6 tiers: trivial, standard, complex, critical, embedding, vision
- 5 providers: Ollama, Anthropic, OpenAI, Mistral, Google
- Shell-native: `eval "$(agent-stack route standard)"` sets `$MODEL`, `$PROVIDER`, `$API_KEY`
- [Repository](https://github.com/FvdHMBAI/model-router) · [Documentation](https://github.com/FvdHMBAI/model-router#tiers)

### Night Shift — Autonomous Maintenance

Scans your repos overnight: finds lint errors, type issues, security vulnerabilities, and missing tests. Fixes what it can, creates PRs for the rest.

- Automated: lint fixes, npm audit, type error repair
- Safe: backup tags, stash management, RAM/disk checks
- Configurable: repo list, task limits, worker parallelism
- [Repository](https://github.com/FvdHMBAI/nightshift) · [Documentation](https://github.com/FvdHMBAI/nightshift#configuration)

### Graphify — Codebase Knowledge Graphs

Extracts a knowledge graph from your codebase: files, functions, imports, dependencies. Query it, find shortest paths between concepts, measure blast radius before changes.

- Standalone core: single script, no server needed
- JSON output: nodes, links, metadata
- Query language: natural-language questions via LLM
- [Repository](https://github.com/FvdHMBAI/graphify-toolkit) · [Documentation](https://github.com/FvdHMBAI/graphify-toolkit#usage)

### Autonomie OS — Self-Improving Agent Framework

The meta-layer: tracks what your agent does, learns from failures, and improves its own behavior over time.

- Learning engine: pattern extraction from agent sessions
- Feedback loops: success/failure tracking with root cause analysis
- PostgreSQL-backed: queryable history of all agent decisions
- [Repository](https://github.com/FvdHMBAI/autonomie-os) · [Documentation](https://github.com/FvdHMBAI/autonomie-os#architecture)

## Why AgentStack?

### The Integration Advantage

Each component is useful alone. Together, they create capabilities none of them have individually:

| Capability | Individual Tools | AgentStack |
|---|---|---|
| Block a dangerous command | GuardRail catches it | GuardRail blocks it, Autonomie OS learns the pattern, Night Shift adds a test |
| Choose a model | Model Router picks one | Model Router picks one based on Graphify's complexity analysis |
| Fix a lint error | Night Shift patches it | Night Shift patches it, GuardRail validates the fix, Graphify updates the knowledge graph |
| Understand a codebase | Graphify maps it | Graphify maps it, Autonomie OS remembers what you queried before |

### Comparison

| Feature | AgentStack | DIY (stitching tools) | LiteLLM | Guardrails AI |
|---|---|---|---|---|
| Pre-execution security | Built-in | Manual | No | Prompt-level only |
| Model routing | Built-in | Manual proxy | Yes | No |
| Overnight automation | Built-in | Custom crons | No | No |
| Knowledge graphs | Built-in | Separate tool | No | No |
| Self-improvement | Built-in | Not feasible | No | No |
| Local-first (Ollama) | Yes | Depends | Partial | No |
| Shell-native | Yes | Depends | Python | Python |
| Zero dependencies | Yes | No | pip install | pip install |
| Single install | `curl \| bash` | Hours of setup | `pip install` | `pip install` |

## CLI Reference

```
agent-stack guard [init|check|list]     # Security guardrails
agent-stack route <tier>                # Model routing
agent-stack night [run|scan|status]     # Overnight maintenance
agent-stack graph [build|query|path]    # Knowledge graphs
agent-stack auto  [run|learn]           # Self-improvement

agent-stack status                      # All component status
agent-stack doctor                      # Health check
agent-stack version                     # Version info
agent-stack update                      # Pull latest
```

## Configuration

AgentStack uses environment variables for configuration. Set them in your shell profile or `.env`:

```bash
# Install location (default: ~/.agent-stack)
export AGENT_STACK_DIR="$HOME/.agent-stack"

# Model Router
export ANTHROPIC_API_KEY="sk-ant-..."
export OPENAI_API_KEY="sk-..."
export OLLAMA_MODEL="qwen3:8b"

# Night Shift
export NIGHTSHIFT_DB_URL="postgresql://user:pass@localhost:5432/nightshift"
export NIGHTSHIFT_REPOS="/path/to/repo1,/path/to/repo2"

# Graphify
export GRAPHIFY_OUTPUT_DIR="./graphify-out"
```

## Requirements

- **Bash 4+** (macOS: `brew install bash`)
- **git**, **curl**, **jq**
- **Ollama** (recommended, for local LLM — `curl -fsSL https://ollama.ai/install.sh | sh`)
- **PostgreSQL** (optional, for Night Shift and Autonomie OS persistence)
- **Docker** (optional, for containerized setup)

## Contributing

We welcome contributions to any component. Each has its own repository with specific guidelines:

1. Fork the component repository
2. Create a feature branch
3. Write tests (every component has a test suite)
4. Submit a PR

All components use shellcheck for linting and have CI pipelines.

## License

MIT License. See [LICENSE](LICENSE) for details.

All individual components are also MIT licensed.
