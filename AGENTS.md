# Exile Repo Agent Rules

**XCSV-AI-CONTRACT: 1.0.0**

This repo tracks deployed source mirrors, migration tooling, diagnostics, and third-party addon catalogue material for the XCSV Arma 3 Exile server.

## Mandatory entrypoint

Read `AI-START-HERE.md`, then the canonical XCSV contract at `D:\XCSV\wiki\AI-Start-Here.md` before roadmap interpretation or implementation.

When Architect says **read the GitHub**, **read the roadmap**, **get caught up**, **resume XCSV**, or equivalent, execute `READ_ONLY_BOOTSTRAP` first.

Roadmap status is intent, not implementation proof. Reconcile RAG/history, this working tree, Git/GitHub, `LiveSource`, packed/deployed state and runtime evidence. Work only on the smallest remaining delta.

## RAG Maintenance

After changing live-source mirrors, PBO tooling, extDB/database tooling, BattlEye tooling, launch assumptions, or operational docs, update XCSV memory:

1. `D:\XCSV\tools\build-memory-index.ps1`
2. `D:\XCSV\tools\build-docs.ps1`
3. `D:\XCSV\tools\build-rag-index.ps1`

Use `D:\XCSV\tools\search-rag.ps1 -Query "terms"` before broad manual searches for project history. The generated RAG files under `D:\CAGE\xcsv-rag\` are local-only and must not be committed.

Live PBO work must be mirrored into `E:\ExileRepo\LiveSource\...` before commit; the packed server PBO must never be the only copy of a change.
