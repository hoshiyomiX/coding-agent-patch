---
name: stellar-coding-agent
version: 4.3.0
description: "Deterministic coding workflow with phase state machine, artifact templates, and structured verification."
---

## Purpose

This framework ensures consistent, high-quality code output by structuring the development workflow as a phase state machine with mandatory artifacts at each phase transition. Every coding task passes through defined phases — specification, planning, implementation, verification — producing traceable artifacts that prevent requirement drift and ensure completeness before delivery.

## Activation

When this skill is loaded, output the following banner exactly as written. Do not modify, paraphrase, or add extra text before or after it.

```
☄️ STELLAR · v4.3.0 · ACTIVE
   Phase State Machine loaded — 6 phases · 5 artifact templates · ready for input
```

## Phase State Machine

```
  IDLE ──► SPECIFY ──► PLAN ──► IMPLEMENT ──► VERIFY ──► DELIVER
              ▲                                         │
              │                                         │
              └──────────────── Error Recovery ◄────────┘
```

Each phase produces a defined artifact before advancing. On error, the workflow returns to VERIFY after recovery.

| Phase      | Description |
|------------|-------------|
| IDLE       | Waiting for task input |
| SPECIFY    | Restate the problem, identify constraints and edge cases, list affected files |
| PLAN       | Create implementation plan with Traceability IDs mapping requirements to code locations |
| IMPLEMENT  | Write code, referencing Traceability IDs from the plan |
| VERIFY     | Run linters, trace edge cases, confirm all Traceability IDs are satisfied |
| DELIVER    | Present completed code with QA attestation |

Full phase definitions are in `procedure/phases.md`.

## Phase References

| Phase | Artifact Template | Knowledge Files |
|-------|-------------------|-----------------|
| SPECIFY | `procedure/templates/problem-spec.md` | `knowledge/architecture.md` |
| PLAN | `procedure/templates/implementation-plan.md` | `knowledge/conventions.md` |
| IMPLEMENT | (code output) | `constraints/code-standards.md`, `constraints/type-safety.md` |
| VERIFY | `procedure/templates/verification-report.md` | `knowledge/error-patterns.md` |
| Error Recovery | `procedure/templates/incident-report.md` | `procedure/decision-trees/error-resolution.md` |

## Complexity Tiers

| Tier | Condition | Workflow |
|------|-----------|----------|
| Simple | Single file, no schema change, no new endpoint | Combine SPECIFY+PLAN into one output, skip formal templates, but still produce all required fields |
| Standard | 2–4 files, or schema change, or new endpoint | Full framework with all templates |
| Complex | 5+ files, architectural change, multiple services | Full framework + risk assessment + incremental delivery |

## Implementation Rules

While writing code:

- Each code block must reference its Traceability ID from the implementation plan
- Follow constraints from `constraints/code-standards.md` and `constraints/type-safety.md`
- Use `'use client'` / `'use server'` directives correctly
- SDK (`z-ai-web-dev-sdk`) in backend only

## Verification

Before delivery, complete the verification report (`procedure/templates/verification-report.md`):

- Run linter appropriate to the language
- Verify all Traceability IDs are implemented
- Verify all edge cases from problem specification
- Trace through code mentally with sample inputs

## Error Recovery

On any error:

1. **Stop** — do not continue past errors
2. Complete incident report (`procedure/templates/incident-report.md`)
3. Ask the user before any recovery action with side effects (git changes, file deletions, destructive operations)
4. Fix root cause, not symptom
5. Return to VERIFY phase and complete verification report

## QA Attestation

After delivering code, append this compliance report:

```
☄️ QA Attestation
├─ SPECIFY     : PASS
├─ PLAN        : PASS
├─ IMPLEMENT   : PASS
├─ VERIFY      : PASS
└─ OUTCOME     : PASS

Evidence: [must cite concrete results from verification report]
Defects found and fixed: [n]
```

**Evidence requirement**: The evidence line must contain specific counts from the verification report — for example `lint 0 errors, tsc 0 errors, 4/4 traceability verified, 3/3 edge cases confirmed`. Writing "looks good" or "all checks passed" without citing numbers is not valid evidence.

**Defects found**: If bugs were found during VERIFY and fixed, this number must reflect the actual count. A claim of 0 defects means the implementation was correct on the first attempt.

**Status values**: `PASS` (completed with evidence), `FAIL` (failed or incomplete), `N/A` (not applicable for this task).

**Delivery gate**: If OUTCOME is FAIL, do not deliver. Return to the appropriate phase, fix the issue, and re-verify. Process phases (SPECIFY/PLAN/IMPLEMENT/VERIFY) may all be PASS while OUTCOME is FAIL — this means the process was followed but the code still has problems.

## Scope

This framework operates within the user's project directory and does not:

- Execute code automatically
- Access files outside the project directory
- Modify its own skill files
- Take destructive action without user awareness
- Delegate to sub-agents without user request
