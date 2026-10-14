#!/usr/bin/env bash
# Link the skills in this repo into every harness found on this machine.
#
# Usage: ./install.sh [--force] [skill ...]
#
#   ./install.sh                      # every skill, every harness
#   ./install.sh systematic-debugging # just one skill
#   ./install.sh --force              # replace entries that already exist
#
# Targets (skipped when the parent harness directory does not exist):
#   pi        ~/.pi/agent/skills/<skill>
#   ZCode     ~/.zcode/skills/<skill>
#   OpenCode  ~/.config/opencode/skills/<skill>
#   shared    ~/.agents/skills/<skill>   (read by several agents)

set -euo pipefail

FORCE="false"
WANTED=()
for arg in "$@"; do
  case "$arg" in
    --force) FORCE="true" ;;
    -*) echo "error: unknown option $arg" >&2; exit 1 ;;
    *) WANTED+=("$arg") ;;
  esac
done

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="${REPO_DIR}/skills"

if [[ ${#WANTED[@]} -eq 0 ]]; then
  for dir in "$SKILLS_DIR"/*/; do
    [[ -f "${dir}SKILL.md" ]] || continue
    WANTED+=("$(basename "$dir")")
  done
fi

TARGET_ROOTS=(
  "${HOME}/.pi/agent/skills"
  "${HOME}/.zcode/skills"
  "${HOME}/.config/opencode/skills"
  "${HOME}/.agents/skills"
)

link() {
  local source="$1" target="$2" parent
  parent="$(dirname "$target")"

  if [[ ! -d "$parent" ]]; then
    echo "skip    ${target}  (no ${parent})"
    return 0
  fi

  if [[ -L "$target" ]]; then
    if [[ "$(readlink "$target")" == "$source" ]]; then
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

  ln -s "$source" "$target"
  echo "linked  ${target}"
}

for skill in "${WANTED[@]}"; do
  source="${SKILLS_DIR}/${skill}"
  if [[ ! -f "${source}/SKILL.md" ]]; then
    echo "error: no skill named '${skill}' in ${SKILLS_DIR}" >&2
    exit 1
  fi

  echo "== ${skill}"
  echo "   source  ${source}"
  for root in "${TARGET_ROOTS[@]}"; do
    link "$source" "${root}/${skill}"
  done
  echo
done

echo "done. Try brainstorming something, hand your agent a failing test, or run /skill:handoff."
