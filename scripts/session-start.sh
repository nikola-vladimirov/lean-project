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
fi
exit 0
