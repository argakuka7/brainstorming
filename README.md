# brainstorming

Find out what your human partner actually wants — and why — before anything
gets built.

An agent is very good at building. What it builds is whatever it *believes*
was asked for, and that belief is usually thinner than it feels. This skill is
the conversation that closes the gap: open questions, playback of what was
understood, a size for the work, and a written design the human approves before
a single line gets written.

Once the design is approved, building starts through the normal workflow. The
plan step hands off to a `writing-plans` skill if you have one installed
(Superpowers' `superpowers:writing-plans`, or a local equivalent).

## What's in here

```
skills/brainstorming/
├── SKILL.md                  the skill itself
├── builder-check-prompt.md   prompt for the reviewer subagent that stress-tests the design doc
├── visual-companion.md       the browser tab for mockups, diagrams, and side-by-side options
├── references/
│   └── tool-mapping.md       action → tool table for pi, ZCode, and OpenCode
└── scripts/                  the visual companion server (Node + WebSocket, no dependencies)
```

## Install

Clone, then link the skill into whichever harness you use:

```bash
git clone https://github.com/argakuka7/brainstorming.git
cd brainstorming
./install.sh            # links into pi, ZCode, and OpenCode (whichever exist)
./install.sh --force    # replace entries that already exist
```

Or do it by hand:

```bash
REPO="$PWD/skills/brainstorming"

# pi
ln -s "$REPO" ~/.pi/agent/skills/brainstorming

# ZCode  (Claude-style skill folder)
ln -s ~/.pi/agent/skills/brainstorming ~/.zcode/skills/brainstorming

# OpenCode
ln -s ~/.pi/agent/skills/brainstorming ~/.config/opencode/skills/brainstorming
```

As a pi package, `pi.skills` is declared in `package.json`, so the repo also
installs through pi's normal package mechanism.

Verify by asking your agent to brainstorm something — it should open with one
question, not a plan.

## Requirements

- A harness that can read files, write files, and run shell commands.
- **Node.js** for the visual companion only. Everything else works without it.

## Port notes

Ported from [obra/superpowers](https://github.com/obra/superpowers)
`skills/brainstorming` (MIT, © 2025 Jesse Vincent). One skill, not the whole
methodology. Changes from upstream:

- Tool actions are mapped per harness in `references/tool-mapping.md` (pi, ZCode,
  OpenCode V1/V2) instead of assuming Claude Code.
- The builder-check dispatch instructions name the subagent tool for each of
  those harnesses, with the inline fallback kept.
- Visual companion launch instructions cover pi, ZCode, and OpenCode.
- Design documents are written to `docs/specs/` rather than
  `docs/superpowers/specs/`.
- Visual companion session files live in `<project>/.brainstorm/` rather than
  `<project>/.superpowers/brainstorm/`.
- The companion's branding no longer loads a remote logo or phone home; the
  frame links to this repo.

The skill body itself is upstream's, near-verbatim. See [NOTICE.md](./NOTICE.md).

## License

MIT — see [LICENSE](./LICENSE).
