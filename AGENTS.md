# Exile Repo Agent Rules

**XCSV-AI-CONTRACT: 1.0.0**

This repo tracks deployed source mirrors, migration tooling, diagnostics, and third-party addon catalogue material for the XCSV Arma 3 Exile server.

## Mandatory entrypoint

Read `AI-START-HERE.md`, then both canonical XCSV policies before roadmap interpretation or implementation:

- `D:\XCSV\wiki\AI-Start-Here.md`
- `D:\XCSV\wiki\AI-Provenance-and-Doc-Sync.md`

When Architect says **read the GitHub**, **read the roadmap**, **get caught up**, **resume XCSV**, or equivalent, execute `READ_ONLY_BOOTSTRAP` first.

Roadmap status is intent, not implementation proof. Reconcile RAG/history, this working tree, Git/GitHub, `LiveSource`, packed/deployed state and runtime evidence. Work only on the smallest remaining delta.

During bootstrap declare desktop/GitHub documentation state. Treat the first 2026-08-07 reconciliation as `DIVERGED` until local evidence proves otherwise. Preserve unique facts from both sides and never overwrite one side merely to make the estate look clean.

Any AI-authored commit must carry XCSV provenance trailers. Prefer `D:\XCSV\tools\ai-commit.ps1` after review/staging; do not fake Git author identity.

## RAG Maintenance

After changing live-source mirrors, PBO tooling, extDB/database tooling, BattlEye tooling, launch assumptions, or operational docs, update XCSV memory:

1. `D:\XCSV\tools\build-memory-index.ps1`
2. `D:\XCSV\tools\build-docs.ps1`
3. `D:\XCSV\tools\build-rag-index.ps1`

Use `D:\XCSV\tools\search-rag.ps1 -Query "terms"` before broad manual searches for project history. The generated RAG files under `D:\CAGE\xcsv-rag\` are local-only and must not be committed.

Live PBO work must be mirrored into `E:\ExileRepo\LiveSource\...` before commit; the packed server PBO must never be the only copy of a change.

## GUARD screenshots and GIFs

Any change to XCSV GUARD behavior or UI must refresh the GitHub-facing screenshots
and GIFs across the XCSV repos before the work is called complete. Use
`D:\XCSV_GUARD\tools\capture.ps1` for publishable tab captures and animated
assets, then update the hub/site outputs and the relevant repo READMEs/wiki
references. Treat stale images as stale documentation.

For live debugging screenshots, keep Orca pinned left and XCSV GUARD pinned right
with `D:\XCSV\tools\ai-desktop-capture.ps1 -Layout -Shot`. Use
`-GuardTab <tab>` to navigate by name. If a shot needs more width, use
`-WideGuardForShot`; the tool may temporarily enlarge GUARD but must restore the
right-pinned operator layout before it exits.

## Documentation synchronization (mandatory)

Portfolio rule `DOCUMENTATION_SYNCHRONIZATION_CONTRACT` v`1.0.0`, owned by
`x-cessive/SOVRAN_PROJECT_BOUNDARIES` ->
`governance/DOCUMENTATION_SYNCHRONIZATION_CONTRACT.md`.

Documentation is part of the deliverable. Every substantive completion carries
exactly one disposition:

```text
DOC_IMPACT: UPDATED | NONE | DEFERRED_OUT_OF_SCOPE | BLOCKED
```

- Material documentation drift **in this repository** caused by your authorized
  change is corrected in the same completion transaction. Making the affected
  document truthful after an authorized change is follow-through, not a new
  authorization.
- `DOC_IMPACT: NONE` is invalid without a reason.
- `DOC_IMPACT: DEFERRED_OUT_OF_SCOPE` requires owning repository, affected surface,
  reason, and a durable follow-up reference. Never use it for something you were
  authorized to fix.
- Drift you caused in **another** repository is recorded and routed through
  `SOVRAN_PROJECT_BOUNDARIES` -> `registry/documentation-debt.json`. This rule
  creates an obligation to record; it grants no cross-repository write authority.

Assess by consequence, not diff size. A one-line change that alters operator
behavior is material; a large refactor that changes nothing observable is not.
Scope note: this repository is a third-party catalogue with first-party packaging
tooling. The obligation applies to the first-party tooling and to catalogue
documentation, not to upstream third-party content, whose provenance and licensing
posture must be preserved rather than rewritten.

Existing rules in this file remain in force. This section is additive.

## Completion impact (mandatory)

Portfolio rule `SOVRAN_COMPLETION_IMPACT_CONTRACT` v`1.0.0`, owned by
`x-cessive/SOVRAN_PROJECT_BOUNDARIES` ->
`governance/SOVRAN_COMPLETION_IMPACT_CONTRACT.md`.

It **composes with** the documentation rule above and embeds `DOC_IMPACT` verbatim
rather than replacing it. Everything already written in this file stays in force.

A substantive completion is not done until its material consequences have been
assessed across all eight domains, in-scope obligations resolved, and anything
material outside current authority durably routed:

```text
COMPLETION_IMPACT: v1.0.0
CHANGED_SURFACES: <paths, or NONE>

DOC_IMPACT:           UPDATED | NONE | DEFERRED_OUT_OF_SCOPE | BLOCKED
TEST_IMPACT:          UPDATED | COVERED_EXISTING | NOT_APPLICABLE | UNVERIFIED_BLOCKED | DEFERRED_OUT_OF_SCOPE
INTERFACE_IMPACT:     UNCHANGED | CHANGED_DOCUMENTED | BREAKING_DOCUMENTED | DEFERRED_OUT_OF_SCOPE
SECURITY_IMPACT:      NO_CHANGE_REVIEWED | CHANGED_REVIEWED | INCREASED_EXPOSURE_AUTHORIZED | BLOCKED | DEFERRED_OUT_OF_SCOPE
OPERATIONAL_IMPACT:   NONE | UPDATED | DEFERRED_OUT_OF_SCOPE | BLOCKED
CROSS_REPO_IMPACT:    NONE | RECORDED_AND_ROUTED | BLOCKED
COMPATIBILITY_IMPACT: NONE | MIGRATION_REQUIRED_DOCUMENTED | BREAKING_DOCUMENTED | DEFERRED_OUT_OF_SCOPE
FRESHNESS[<source>]:  VERIFIED_CURRENT | NOT_REVERIFIED | STALE | UNKNOWN
```

Rules that matter most in practice:

- **Capability does not widen authority.** An impact declaration is evidence and
  obligation metadata, never permission. Finding an operational impact does not
  authorize a deploy or a restart; finding a cross-repository impact does not
  authorize a write into that repository.
- **"The suite passes" is not evidence that the changed behavior is tested.**
  `COVERED_EXISTING` must name the specific covering test.
- **Freshness is per source.** A repository may be freshly inspected while its
  runtime or planning state is stale. No marker may be advanced for a source that
  was not actually reverified.
- Assess by **consequence, not diff size**. A one-line change can be material; a
  large internal refactor with no observable effect need not be.
- Out-of-scope impact is routed durably: non-documentation domains to
  `registry/completion-impact-debt.json` (`CID-nnnn`), documentation to
  `registry/documentation-debt.json` (`DEBT-nnnn`).
- It never authorizes editing control pointers, durable decisions, historical
  evidence or generated projections, and never authorizes running a migration.

