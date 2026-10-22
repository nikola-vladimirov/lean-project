#!/usr/bin/env bash
# SessionStart: lean-project is always on. Prints the standing rules for every session, and the WordPress
# pointer when the working folder is a WordPress project (plugin, theme or WordPress install).
cat <<'EOF'
lean-project (always on): read the project's index and state file before editing. Use `lean-project map <file>` and read only the ranges you need. Keep the state file current. Before calling code done, run `lean-project audit security <folder>` on WordPress, WooCommerce, Bricks or block-editor code.
EOF

wp=""
grep -qs 'Plugin Name:' ./*.php && wp=1
grep -qs 'Theme Name:' style.css && wp=1
[ -f wp-config.php ] || [ -f wp-config-sample.php ] && wp=1
grep -qs 'wordpress\|woocommerce' composer.json && wp=1
if [ -n "$wp" ]; then
  echo "WordPress project detected. Before changing code, read ${CLAUDE_PLUGIN_ROOT:-.}/skills/lean-project/WORDPRESS.md: how to read the docs, check changelogs, best practices, and the security checklist and fixes."
  echo "For WordPress.org submission, read ${CLAUDE_PLUGIN_ROOT:-.}/skills/lean-project/reference/wordpress-agent-skills/wp-plugin-directory-guidelines.md. For static analysis, read reference/wordpress-agent-skills/wp-phpstan.md. Read only the one the task needs."
fi
woo=""
grep -qs 'WooCommerce' ./*.php && woo=1
grep -qs 'woocommerce' composer.json && woo=1
if [ -n "$woo" ]; then
  echo "WooCommerce code detected. For order, product, checkout or payment code, read ${CLAUDE_PLUGIN_ROOT:-.}/skills/lean-project/reference/guard-skills/woo-guard.md first."
fi
# First run in a project (or one started before this option): ask once where delegated work goes.
if [ ! -f .lean-project ] && { [ -f CLAUDE.md ] || [ -d docs ] || [ -f README.md ]; }; then
  echo "lean-project: no delegation choice for this project yet. Ask the user once with AskUserQuestion: none (do all work here), llama (local llama.cpp server), or opencode (free OpenCode models). Then run: lean-project delegate set runner <none|llama|opencode>, and for llama or opencode check the endpoint or model with lean-project delegate check."
fi
exit 0
