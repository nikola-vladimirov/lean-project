---
name: lean-project
description: Run a project with the fewest tokens per session. Start a new project (plan with phase gates, folders, state file), grill a loose idea or fuzzy change into decisions, adopt a project already under way, audit or trim CLAUDE.md, handoffs and docs, add contents tables, map large files to read only the needed lines, and build from a plan with tasks routed to Haiku, Sonnet or Opus and coordinated on a shared board. Learns from each run.
---

# lean-project

One goal: the fewest tokens a session spends to get oriented, stay oriented and get the work done, without losing information.

## Pick the mode, read only its guide

| The user wants to | Read |
|---|---|
| Start a new project | `NEW-PROJECT.md` (it sends loose ideas through `GRILL.md`) |
| Take over a project already under way that has no phased plan | `NEW-PROJECT.md`, "Adopting a project" |
| Sharpen a fuzzy change, feature or design in an existing project | `GRILL.md` (with docs) |
| Organize, audit or trim docs, CLAUDE.md, memory or handoffs | `DOCS.md` |
| Build from the plan (a phase, a feature, a release) | `BUILD.md` |

## Paths and settings (the guides refer here)

- Guides and `templates/`: `${CLAUDE_PLUGIN_ROOT}/skills/lean-project/`
- Lessons: `${CLAUDE_PLUGIN_DATA}/LESSONS.md`
- **Docs folder:** wherever the project's index keeps its docs (`docs/` for projects this skill started). Plan, state file, glossary, board and archive all go there, under the project's own file names when it has them. Never inside a folder that ships (a plugin, package or theme folder that is zipped or published whole): check the index and the build or ignore rules first.
- Always back up docs before editing: `${user_config.backup_docs}`. Backup folder: `${user_config.backup_dir}`.
  - `true`: before the first edit, copy every file you will touch to `<project>/<backup folder>/docs-<YYYY-MM-DD>/`.
  - `false`: do that only when the project is not under version control.
  - Add the backup folder to `.gitignore` when the project uses git.

If any value above shows as an unfilled `${...}`: plugin files are under `~/.claude/plugins/`, data under `~/.claude/plugins/data/` in the folder whose name starts with `lean-project`, backups `false`, folder `backups`.

## Before any mode: lessons

Read the lessons file if it exists. Its "Local rules" section outranks the defaults in these guides.

## Cost model

- **Auto-loaded** on every turn of every session: the CLAUDE.md chain (the working folder and every parent, plus `~/.claude/CLAUDE.md`), the project's MEMORY.md, every installed skill's description. The most expensive bytes there are.
- **Read files** are paid once and then carried for every later turn. A 5k-token file read at turn 3 of a 40-turn session is processed about 37 times. Read ranges, not files.
- **Subagent reads** vanish when the subagent ends. Bulk reading belongs there, on a cheap model, returning only the answer.
- **Session length** dominates everything else. Every turn re-sends the whole conversation, so a fresh session that starts from a 30-line state file beats a long one.

## The tool

`lean-project` is on the Bash PATH while the plugin is enabled (fallback: `bash "${CLAUDE_PLUGIN_ROOT}/bin/lean-project"`). Bash and POSIX awk only.

- `lean-project map <file>`: outline with line ranges (markdown headings; classes and functions in PHP, JS/TS, Python, Go, Ruby, Rust, Java, Kotlin, C#, Swift, shell).
- `lean-project map <dir> [min]`: files of `min`+ lines (default 300).
- `lean-project toc <file>... [--force]`: build or refresh contents tables in markdown (files under 80 lines are skipped).
- `lean-project cost [dir]`: auto-loaded tokens, every doc with flags (NEEDS TOC, STALE TOC, STATE FILE OVER 60 LINES), duplicated lines.
- `lean-project board [id]` and `board add|move|note <id> ...`: shared task board so parallel subagents and sessions exchange facts while they run (how: `BUILD.md`, "Board").
- `lean-project selftest`.

## Reading rules (every mode, every project)

1. Never read a file over about 300 lines whole. Get its map (or its contents table), then `Read` with `offset` and `limit`.
2. Find before reading: `Grep -n` for an ID or symbol, then read that range. Use the project's code graph tool first if it has one.
3. Do not `cat` whole files in Bash or re-read a file still in context.
4. Large tool output (logs, test runs, search results): filter it (`tail`, `grep`, `head`) before it enters the conversation.
5. Screenshots only for visual checks; page text or the accessibility tree otherwise.

## Session hygiene

- A hook nudges once the conversation passes the context limit (default 300k tokens, then every 50k; the user can change both in `/config`). When it fires: finish the current step, update the state file, and tell the user to start a new session from it. Do not start large work.
- End a session at every phase or milestone boundary anyway, after updating the state file.

## After any mode: improve

Append one entry to the lessons file (create it with a "Local rules" section on top and an "Entries" section below): date, project, mode, before and after tokens where measured, what saved the most, what in these guides was wrong or wasted effort. A lesson seen twice becomes a line in "Local rules" and its entries go. Keep the file under 60 lines. If a lesson would help every user, offer to draft an issue for the plugin's repository, and post only if the user says yes.

## Precedence

The user's own rules (CLAUDE.md, memory) outrank this skill. Never delete content: replaced text moves verbatim to an archive file. Confirm before anything outward-facing (pushing, creating remotes, posting).
