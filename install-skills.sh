#!/usr/bin/env bash
# Install every skill in this repo into your personal Claude skills directory
# (~/.claude/skills) so Claude can use it from any project on this computer.
#
# Usage:  ./install-skills.sh
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
mkdir -p "$DEST"

shopt -s nullglob
found=0
for skill in "$DIR"/skills/*/; do
  [ -f "$skill/SKILL.md" ] || continue
  name="$(basename "$skill")"
  rm -rf "$DEST/$name"
  cp -R "$skill" "$DEST/$name"
  echo "✓ installed: $name  ->  $DEST/$name"
  found=1
done

if [ "$found" -eq 0 ]; then
  echo "No skills found under $DIR/skills/*/" >&2
  exit 1
fi
echo "Done. Restart Claude Code (or your Claude app) so it picks up the skill(s)."
