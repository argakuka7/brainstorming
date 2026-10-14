#!/usr/bin/env bash
# Link the brainstorming skill into every harness found on this machine.
#
# Usage: ./install.sh [--force]
#
# Targets (skipped when the parent harness directory does not exist):
#   pi        ~/.pi/agent/skills/brainstorming
#   ZCode     ~/.zcode/skills/brainstorming
#   OpenCode  ~/.config/opencode/skills/brainstorming
#   shared    ~/.agents/skills/brainstorming   (read by several agents)

set -euo pipefail

FORCE="false"
[[ "${1:-}" == "--force" ]] && FORCE="true"

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE="${REPO_DIR}/skills/brainstorming"

if [[ ! -f "${SOURCE}/SKILL.md" ]]; then
  echo "error: ${SOURCE}/SKILL.md not found" >&2
  exit 1
fi

link() {
  local target="$1" parent
  parent="$(dirname "$target")"

  if [[ ! -d "$parent" ]]; then
    echo "skip    ${target}  (no ${parent})"
    return 0
  fi

  if [[ -L "$target" ]]; then
    if [[ "$(readlink "$target")" == "$SOURCE" ]]; then
      echo "ok      ${target}  (already linked)"
      return 0
    fi
    if [[ "$FORCE" != "true" ]]; then
      echo "exists  ${target}  (points elsewhere — rerun with --force)"
      return 0
    fi
    rm "$target"
  elif [[ -e "$target" ]]; then
    if [[ "$FORCE" != "true" ]]; then
      echo "exists  ${target}  (real file/dir — rerun with --force)"
      return 0
    fi
    mv "$target" "${target}.bak-$(date +%Y%m%d-%H%M%S)"
    echo "backed  ${target} -> ${target}.bak-*"
  fi

  ln -s "$SOURCE" "$target"
  echo "linked  ${target}"
}

echo "source  ${SOURCE}"
echo
link "${HOME}/.pi/agent/skills/brainstorming"
link "${HOME}/.zcode/skills/brainstorming"
link "${HOME}/.config/opencode/skills/brainstorming"
link "${HOME}/.agents/skills/brainstorming"
echo
echo "done. Ask your agent to brainstorm something and check it opens with one question."
