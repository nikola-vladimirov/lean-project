#!/usr/bin/env bash
# PostToolUse on Write/Edit: when Claude edits a doc or a test file, point it at the matching guard, once per session.
# Silent for every other file, and for the reference copies themselves.
input=$(cat)
field() { printf '%s' "$input" | tr -d '\n' | sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p"; }
f=$(field file_path | sed 's/\\\\/\//g' | tr 'A-Z' 'a-z')
session=$(field session_id | tr -cd 'A-Za-z0-9-')
[ -n "$f" ] && [ -n "$session" ] || exit 0

case "$f" in
  */reference/*) exit 0 ;;
  *.md) kind=docs ;;
  *test_*.py|*_test.go|*test.php|*.test.ts|*.test.tsx|*.test.js|*.spec.js|*.spec.ts|*/tests/*|*/__tests__/*|*/spec/*) kind=test ;;
  *) exit 0 ;;
esac

state_dir=${CLAUDE_PLUGIN_DATA:-${TMPDIR:-/tmp}/lean-project}
mkdir -p "$state_dir" 2>/dev/null || exit 0
find "$state_dir" -name 'guard-*' -mtime +7 -exec rm -f {} + 2>/dev/null
marker="$state_dir/guard-$kind-$session"
[ -f "$marker" ] && exit 0
touch "$marker"

ref="${CLAUDE_PLUGIN_ROOT:-$(dirname "$0")/..}/skills/lean-project/reference/guard-skills"
if [ "$kind" = docs ]; then
  msg="lean-project: you are editing docs. Before you finish, check every function, flag, endpoint and config key they name against the code. Read only $ref/docs-guard.md for the method."
else
  msg="lean-project: you are editing tests. Before you finish, check them against the test rules. Read only $ref/test-guard.md for the method."
fi
printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"%s"}}\n' "$msg"
exit 0
