# Tool mapping: pi / ZCode / OpenCode

Shared by every skill in this repo. The skills name *actions*, never tools.
This file translates those actions into the real tool names on the three
harnesses this port targets. Load it only when a tool name actually matters.

## Skills

| Harness | How a skill is discovered and loaded |
|---------|--------------------------------------|
| pi | Global skills in `~/.pi/agent/skills/<name>/SKILL.md` (or a package with `pi.skills`). Load by reading the `SKILL.md`, or let the human run `/skill:<name>`. |
| ZCode | `~/.zcode/skills/<name>/SKILL.md` — Claude-style skill folders. |
| OpenCode V1 / V2 | `<project>/.opencode/skills/<name>/SKILL.md` or `~/.config/opencode/skills/<name>/SKILL.md`; load with OpenCode's native `skill` tool. |

## Actions

| The skill says | pi | ZCode | OpenCode V1 | OpenCode V2 |
|----------------|----|-------|-------------|-------------|
| Read a file | `read` | file-read tool | `read` | `read` |
| Create / edit / delete a file | `write`, `edit` | write / edit tool | `apply_patch` | `patch`, else `write` + `edit` |
| Run a shell command | `bash` | shell tool | `bash` | `shell` |
| Search file contents / find files | `grep`, `find`, `ls` | search tools | `grep`, `glob` | `grep`, `glob` |
| Dispatch a subagent | `subagent` (`pi-subagents`), or `remote_subagent` for another host | ZCode's task/agent dispatch | `task` with `subagent_type: "general"` | `subagent` with `agent: "general"` |
| Invoke a skill | read the skill's `SKILL.md` | native skill loading | `skill` | `skill` |
| Track progress in a task list | whatever todo/task tool is installed; else a plan file | ZCode's todo tool | `todowrite` | no todo tool — use a markdown plan file |
| Fetch a URL / search the web | `web_fetch`, `web_search` | web tools | `webfetch` | `webfetch`, `websearch` |
| Ask the human a structured question | `ask_user_question` | ZCode's question prompt | inline in chat | inline in chat |

## Degradation rules

- **No subagent tool?** Do the builder check yourself: read the design document
  as if you were the builder, and sort the questions the same way. Never invent
  a `Task` call, and never claim a reviewer looked at the document when none did.
- **No todo tool?** Track work in the plan file, or a repo-local `TODO.md`.
- **No visual companion possible?** (no Node, no browser, remote-only session)
  Stay in text. Describe the layout in words instead of offering the tab.
