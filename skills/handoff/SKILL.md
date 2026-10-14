---
name: handoff
description: Compact the current conversation into a handoff document for another agent to pick up.
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

Write a handoff document summarising the current conversation so a fresh agent can continue the work. Save to the temporary directory of the user's OS (`$TMPDIR`, else `/tmp`; `%TEMP%` on Windows) - not the current workspace.

Include a "suggested skills" section in the document, naming which skills the next agent should load. Name them the way the next agent will ask for them: on pi and OpenCode, `/skill:<name>`; on ZCode, the skill's name.

Do not duplicate content already captured in other artifacts (specs, plans, ADRs, issues, commits, diffs). Reference them by path or URL instead.

Redact any sensitive information, such as API keys, passwords, or personally identifiable information.

If the user passed arguments, treat them as a description of what the next session will focus on and tailor the doc accordingly.

## Running on pi, ZCode, and OpenCode

This skill is harness-neutral: it names actions, not tools. The port's shared
tool table — which file, shell, search, subagent, and todo tools to use on pi,
ZCode, and OpenCode — lives in the repo at `references/tool-mapping.md`. The
document itself is plain Markdown written with the harness's normal
file-writing tool; nothing here needs a background process.

Three things worth knowing on these harnesses:

- **A handoff document is not a resume.** pi keeps sessions on disk
  (`pi --continue`, `pi --resume`, `/resume`), and ZCode and OpenCode persist
  sessions too. Reach for this skill when work moves to a *different* agent,
  harness, machine, or workspace — not merely to pick the same session back up.
- **Temp is not durable.** If the next agent might read the document later, say
  in your reply where you wrote it. Ask your human partner whether it belongs in
  the repo instead.
- **`disable-model-invocation: true`** keeps this skill out of automatic model
  selection on harnesses that honor it (pi and other Agent Skills
  implementations). The human invokes it — `/skill:handoff` — because only they
  know when the conversation is over.
