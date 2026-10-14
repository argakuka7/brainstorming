# obra skills — ported for pi, ZCode, and OpenCode

Skills from [Superpowers](https://github.com/obra/superpowers) and
[mattpocock/skills](https://github.com/mattpocock/skills), ported to run on pi,
ZCode, and OpenCode. Not the whole methodology — just these.

| Skill | What it does |
|-------|--------------|
| [`brainstorming`](./skills/brainstorming/) | Finds out what your human partner actually wants — and why — before anything gets built. Open questions, playback, a size for the work, and a written design the human approves before a line gets written. |
| [`systematic-debugging`](./skills/systematic-debugging/) | The Iron Law: no fixes without root cause investigation first. Four phases — root cause, pattern analysis, hypothesis, implementation — with rules that hold up under time pressure. |
| [`handoff`](./skills/handoff/) | Compacts the current conversation into a handoff document another agent can pick up. Written to the OS temp directory, referencing artifacts instead of restating them, with secrets redacted. User-invoked: `/skill:handoff`. |

## What's in here

```
skills/brainstorming/          the skill, the builder-check prompt, the visual companion
skills/systematic-debugging/   the skill, plus its supporting techniques
skills/handoff/                the skill, plus its agents/openai.yaml metadata
references/tool-mapping.md     shared: action → tool table for pi, ZCode, OpenCode
install.sh                     links the skills into every harness found on this machine
```

## Install

```bash
git clone https://github.com/argakuka7/brainstorming.git
cd brainstorming
./install.sh                          # every skill, every harness
./install.sh systematic-debugging    # just one
./install.sh --force                 # replace entries that already exist
```

Or by hand:

```bash
cd brainstorming
for skill in skills/*/; do
  skill="$(basename "$skill")"
  ln -s "$PWD/skills/$skill" ~/.pi/agent/skills/"$skill"
  ln -s ~/.pi/agent/skills/"$skill" ~/.zcode/skills/"$skill"
  ln -s ~/.pi/agent/skills/"$skill" ~/.config/opencode/skills/"$skill"
done
```

As a pi package, `pi.skills` is declared in `package.json`, so the repo also
installs through pi's normal package mechanism.

**Verify:** ask your agent to brainstorm something — it should open with one
question, not a plan. Then hand it a failing test — it should investigate
before it edits anything. Then run `/skill:handoff` — it should write a handoff
document to your temp directory, not into the workspace.

## Requirements

- A harness that can read files, write files, and run shell commands.
- **Node.js** for the visual companion only. Everything else works without it.

## Port notes

Ported from [obra/superpowers](https://github.com/obra/superpowers) (MIT, © 2025
Jesse Vincent) and [mattpocock/skills](https://github.com/mattpocock/skills) (MIT,
© 2026 Matt Pocock). See [NOTICE.md](./NOTICE.md) for which files came from which
upstream, and [LICENSE](./LICENSE) / [LICENSE.mattpocock](./LICENSE.mattpocock)
for both licenses.

Common to every skill:

- Tool actions are mapped per harness in [`references/tool-mapping.md`](./references/tool-mapping.md)
  (pi, ZCode, OpenCode V1/V2) instead of assuming Claude Code, and every skill
  points at that one shared table.
- References to skills that live in the rest of Superpowers now carry an
  "or a local equivalent" fallback, so they don't dangle when it isn't installed.
- A "Running on pi, ZCode, and OpenCode" section names the harness-specific
  detail that would otherwise be assumed.

`brainstorming` specifically:

- The builder-check dispatch instructions name the subagent tool for each
  harness, with the inline fallback kept.
- Visual companion launch instructions cover pi, ZCode, and OpenCode.
- Design documents are written to `docs/specs/` rather than
  `docs/superpowers/specs/`.
- Visual companion session files live in `<project>/.brainstorm/` rather than
  `<project>/.superpowers/brainstorm/`.
- The companion's branding no longer loads a remote logo or phones home; the
  frame links to this repo.

`handoff` specifically:

- "call the Skill tool for" → how each harness actually loads a skill.
- A note that a handoff document is not a session resume (pi's `--continue` /
  `--resume`, and the equivalent in ZCode and OpenCode), so the skill isn't used
  for work that never left the machine.

Skill bodies are otherwise upstream's, near-verbatim.

## License

MIT — see [LICENSE](./LICENSE) (Superpowers, © 2025 Jesse Vincent) and
[LICENSE.mattpocock](./LICENSE.mattpocock) (© 2026 Matt Pocock).
