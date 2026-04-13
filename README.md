<div align="center">

# ☄️ stellar-coding-agent

**Deterministic coding workflow for LLM agents**

[![Version](https://img.shields.io/badge/version-5.0.0-blue.svg)](CHANGELOG.md)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

Structures coding tasks as a **phase state machine** with traceability IDs, artifact templates, and source state verification. Designed for the [z.ai](https://z.ai) platform.

```text
IDLE → SPECIFY → PLAN → IMPLEMENT → VERIFY → DELIVER
  ↑                                        │
  └──── Error Recovery ◄───────────────────┘
```

</div>

---

## Install

```bash
git clone https://github.com/hoshiyomiX/stellar-coding-agent.git /tmp/cap
cd /tmp/cap && bash setup.sh
```

Invoke in any session:

```
Skill(command="stellar-coding-agent")
```

Look for `☄️ STELLAR · v5.0.0 · ACTIVE` — confirms the framework loaded.

## Uninstall

```bash
rm -rf /home/z/my-project/skills/stellar-coding-agent
```

---

## How It Works

The framework provides **tools, not rules**. Each phase produces an artifact the next phase consumes, creating a chain that prevents skipping straight to code.

| Phase | Output | Why |
|-------|--------|-----|
| **SPECIFY** | Problem specification | Forces precise thinking before writing code |
| **PLAN** | Implementation plan with Traceability IDs | Maps requirements to code locations |
| **IMPLEMENT** | Annotated code | Each block references its Traceability ID |
| **VERIFY** | Evidence-based report | Automated checks + edge case tracing |
| **DELIVER** | Summary + compliance report | Traceable record of what was done |

**Traceability IDs** (`IMPL-001`, `IMPL-002`, ...) chain through every phase — requirement → code → verification. If something is dropped, the gap is visible.

### Source State Verification (SSV)

Before analyzing git repositories, the framework verifies data freshness:

```bash
git fetch → compare HEAD to origin → sync if behind → proceed
```

Prevents stale-checkout analysis (the failure that inspired this feature).

### Error Recovery

Structured 5-step decision tree: **capture → classify → identify actions → fix → re-verify**. Git operations have explicit safety rules — `git fetch` before `git pull`, no force push without user instruction, stop all git ops if infrastructure blocks.

---

## File Structure

```
skill/stellar-coding-agent/
├── SKILL.md                          # Core framework (phases, SSV, error recovery, PCR)
├── CHANGELOG.md                      # Version history
├── procedure/
│   ├── phases.md                     # Phase definitions with entry/exit criteria
│   ├── templates/
│   │   ├── problem-spec.md           # SPECIFY artifact
│   │   ├── implementation-plan.md    # PLAN artifact (Traceability IDs)
│   │   ├── verification-report.md    # VERIFY artifact (evidence capture)
│   │   └── incident-report.md        # Error documentation
│   └── decision-trees/
│       └── error-resolution.md       # 5-step structured decision tree
├── constraints/
│   ├── code-standards.md             # Function, file, import, quality standards
│   └── type-safety.md                # Type system constraints with examples
├── knowledge/
│   ├── architecture.md               # Runtime environment, directory layout, service topology
│   ├── conventions.md                # Coding conventions, state management, import order
│   ├── platform-constraints.md       # Sandbox-specific limitations (gateway, routes, SDK)
│   └── error-patterns.md             # Common errors with cause → fix mapping
└── memory-template.md                # Template for user preference storage
```

---

## Philosophy (v5.0.0)

> **Stop telling the LLM what it MUST do. Start giving it tools it WANTS to use.**

v5.0.0 is a philosophical reset based on an honest audit:

- **What works**: Traceability IDs, templates, SSV, error decision tree — they work because they're useful, not because they're mandatory
- **What doesn't work**: Compliance enforcement language ("must", "mandatory", "do not skip") — has no measurable effect on LLM behavior regardless of wording
- **What's honest**: The framework cannot guarantee compliance, force behavior, or persist across sessions. It's text in a skill file. The user is the final judge of quality.

---

## Version History

| Version | Summary |
|---------|---------|
| [**v5.0.0**](CHANGELOG.md) | Philosophical reset. Removed compliance theater, kept useful tools. SKILL.md: 181→95 lines. |
| [v4.6.0](CHANGELOG.md) | Source State Verification (SSV). Evidence tiers in attestation. |
| [v4.5.0](CHANGELOG.md) | Coexistence mode with fullstack-dev. *(Removed in v5.0.0)* |
| [v4.4.2](CHANGELOG.md) | QA Attestation required for all tasks, not just coding. |
| [v4.4.1](CHANGELOG.md) | Compliance binding after banner. |
| [v4.4.0](CHANGELOG.md) | Git error classification and safety rules. |
| [v4.3.0](CHANGELOG.md) | OUTCOME gate, evidence requirement, defect counter. |
| [v4.2.0](CHANGELOG.md) | Styled activation banner. |
| [v4.1.0](CHANGELOG.md) | Removed fullstack-dev routing wrapper. Direct invocation. |
| [v4.0.0](CHANGELOG.md) | Complete redesign: phase state machine, artifact templates, traceability IDs. |

---

## License

MIT
