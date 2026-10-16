# lean-project

A Claude Code plugin that makes every session cheaper. Claude re-sends the whole conversation on every turn and loads some files into every session, so tokens go to orientation and old context before any work happens. lean-project keeps that overhead small, and keeps the work organised while it does.

## Features

**Planning**

- **New projects** start with a short index, a plan whose phases are gates with acceptance checks, and a 20-line state file. Any fresh session can pick the project up for about 1 to 2k tokens.
- **Decision frontier.** `lean-project frontier` lists the open decisions whose prerequisites are settled, so each grilling round asks exactly those, and shows what waits on them (`needs D<n>` in a decision).
- **Grilling for loose ideas.** A loosely described project is interviewed in rounds: every question that can be asked now, numbered, each with a recommended answer that "yes" accepts. Facts are looked up by a cheap subagent instead of asked; questions only a prototype can answer become prototype tasks. It ends when every decision is settled and you confirm.
- **Grilling with docs for fuzzy changes** in an existing project: the same interview, checked against the code. Vague or clashing words are challenged, settled terms go into a glossary the moment they settle, and every decision lands in the plan, with the reasons for the hard-to-reverse ones.
- **Projects already under way** get a plan reconstructed from their code, git tags and docs: released versions become finished phases, current work becomes the open ones, and only real gaps are asked about. Existing file names and doc locations stay, and nothing lands in a folder that ships.

**Reading less**

- **File maps** give an outline with line ranges for large markdown and source files (PHP, JS/TS, Python, Go, Ruby, Rust, Java, Kotlin, C#, Swift, shell), so Claude reads the 40 lines it needs, not 1,000.
- **Predicted reads.** `lean-project map predict <file>` lists the files that changed in the same commits as a file over the last 10, with their maps, so a change to one is read with its usual partners.
- **Code waste.** `lean-project audit waste` finds comment blocks, debug logs and repeated hooks; `--apply` moves comment blocks verbatim into `docs/ARCHIVE.md`.
- **Contents tables** inside long docs, with line ranges, refreshed by one command.
- **Shipping check.** `lean-project cost` warns when a project's `docs/` (and `GLOSSARY.md`) would reach users in a build.
- **Docs audits** measure what a session pays, remove duplicated rules, slim the index and state file, split growing logs, and add contents tables. Nothing is deleted: trimmed text moves to an archive.

**Building**

- **Build mode** works through the plan phase by phase and routes tasks by model and effort: Haiku for bulk reading and fixtures, Sonnet for well-specified code, tests and lint fixes, Opus for review and acceptance, the main session for design. Each task gets a short self-contained brief, the main session verifies every result, and a failing task climbs effort before it climbs models.
- **A shared board** lets parallel subagents and sessions talk while they work: cards move through todo, doing, blocked and done, and agents post one-line facts their siblings need (a contract, a format, a gotcha). It is one append-only file, so parallel writers never overwrite each other, and the lead reads a compact view instead of waiting on replies. At each phase gate, lasting notes move into the plan and the board is archived.
- **Phase gates**: acceptance checks ticked by a fresh reviewer, plus security review, code review and tests before a build is final.
- **A gate on done.** Moving a card to `done` runs `lean-project check gate`: PHP syntax and, when installed, WordPress coding standards on the card's files. A failure sends the card back to `todo` with the output on the card.
- **Always on, WordPress aware.** A session-start hook applies the rules to every project. In a WordPress project it points to `skills/lean-project/WORDPRESS.md`: how to read the docs and check changelogs, best practices for plugins, WooCommerce, Bricks and the block editor, and a security checklist with fixes. `lean-project audit security` scans the code for the common anti-patterns.
- **Handoff draft.** `lean-project handoff` drafts the state file from the branch, the next open tasks and the cards in flight, for review before a reset.
- **Builder skills on demand.** The 108 Bricks and BricksExtras skills live inside this one skill, in `builder/`. `builder/INDEX.md` routes a task to the one skill it needs, so nothing loads unless a plan step names a Bricks element, template or query. Their generated JSON schema data stays out of the plugin.
- **Reverse engineering on demand.** The REA guide lives in `reverse/` and loads only for reverse-engineering tasks. REA's MCP server stays off by default (startup cost) and is switched on per folder.

**Session hygiene**

- **A fresh-session reminder** (a hook) speaks up once the conversation passes a context limit: update the state file, then start over from it.
- **It learns.** Each run records a lesson in your own data folder, including which model passed which kind of task; a lesson seen twice becomes a local rule that outranks the defaults.

## Install

In Claude Code:

```
/plugin marketplace add nikola-vladimirov/lean-project
/plugin install lean-project@lean-project
```

Requires bash: built in on macOS and Linux, and Git Bash on Windows (which Claude Code uses there). No other dependencies.

## Use

Ask in plain words, or run the skill directly (`/lean-project:lean-project`):

| Say | What happens |
|---|---|
| "Start a new project for ..." | One round of questions (or grilling, if the idea is loose), then the folder, index, plan and state file |
| "Grill me on this idea" / "Help me pin down this feature" | Rounds of questions until every decision is settled; with code present, a glossary and decisions in the plan |
| "Take over this project" / "Give this project a plan" | A plan reconstructed from code, git and docs; questions only about the gaps |
| "Audit the docs in this project for token use" | Measures, trims and reports before and after |
| "Build phase 2 from the plan" | Splits the phase into tasks, routes them across models, coordinates them on the board, checks the gate |

## Commands

The `lean-project` command is on Claude's PATH while the plugin is enabled (you can run it too: `bash <plugin folder>/bin/lean-project`).

| Command | What it does |
|---|---|
| `lean-project map <file>` | Outline with line ranges: markdown headings, or classes and functions in code |
| `lean-project map <dir> [min]` | Files of `min`+ lines (default 300), largest first: map those before reading them |
| `lean-project toc <file>... [--force]` | Build or refresh a contents table between `<!-- toc -->` markers. Files under 80 lines are skipped unless `--force` |
| `lean-project cost [dir]` | Tokens auto-loaded every session, the startup baseline (first-reply size from recent sessions, skill listing by group), every doc with flags (`NEEDS TOC`, `STALE TOC`, `STATE FILE OVER 60 LINES`), and lines duplicated across files |
| `lean-project board` | The shared board: cards by column (doing, blocked, todo, done) and the latest 10 notes |
| `lean-project board <id>` | One card's full history |
| `lean-project board add <id> <title>` | Add a card (id: letters, digits, `.`, `_`, `-`, like `T3`) |
| `lean-project board move <id> <status> [why]` | Status is `todo`, `doing`, `blocked` or `done`; a reason after `blocked` shows on the card |
| `lean-project board note <id> <text>` | Post a one-line fact for the other tasks |
| `lean-project map predict <file>` | The files that changed with it in the last 10 commits, with their maps |
| `lean-project board files <id> <paths>` | Record the files a card changes; the gate checks them when it moves to `done` |
| `lean-project check gate <id> [files]` | Run the gate by hand: `php -l` and WordPress coding standards |
| `lean-project audit waste [dir] [--apply]` | Find comment blocks, debug logs and repeated hooks; `--apply` archives comment blocks |
| `lean-project frontier [docs/PLAN.md]` | The decisions to ask now, and what waits on them |
| `lean-project lesson "<text>" [--mode M] [--project P]` | Record a lesson; a second sighting becomes a local rule |
| `lean-project lessons` | Show the local rules and where the lessons file is |
| `lean-project audit security [dir]` | Read-only scan of PHP and JS for WordPress anti-patterns (unescaped output, unprepared SQL, missing nonce or capability checks, dangerous functions) |
| `lean-project handoff [docs/PLAN.md]` | Draft of the state file: branch, next tasks, cards in flight (prints only) |
| `lean-project selftest` | Check the tool on this machine |

Board environment variables: `LEAN_BOARD` is the board file (default `docs/BOARD.md`; agents always pass an absolute path, since a worktree has its own copy of the docs folder) and `LEAN_AS` is the writer's name (default `lead`).

## Settings

`/config` shows four options:

| Option | Default | What it does |
|---|---|---|
| Context limit | 300,000 tokens | When the fresh-session reminder first speaks up |
| Remind again every | 50,000 tokens | How often it repeats after that |
| Always back up docs before editing | off | On: copy every doc to a dated backup folder before lean-project edits it. Off: back up only when the project is not under version control |
| Backup folder | `backups` | Where backups go, relative to the project folder |

## What a project gets

```
<project>/
├── CLAUDE.md          index: status, folder map, reading rules by task, upkeep, ground rules
├── docs/
│   ├── PLAN.md        goal, assumptions A#, decisions D#, sources, phases with gates, risks R#, decision log
│   ├── HANDOFF.md     state: now, in progress, next
│   ├── GLOSSARY.md    the project's own terms (once grilling settles one)
│   ├── BOARD.md       shared board (during a build phase)
│   └── ARCHIVE.md     replaced text, verbatim (once something is replaced)
└── <code>/
```

Projects already under way keep their own names and doc folder. Docs never go inside a folder that ships.

## Where your data lives

Lessons go to the plugin's data folder (`~/.claude/plugins/data/lean-project-*/LESSONS.md`), which survives plugin updates. Nothing leaves your machine.

## Credits

Grilling is adapted from Matt Pocock's [grilling, grill-with-docs and domain-modeling skills](https://github.com/mattpocock/skills) (MIT; notice in `LICENSE`).

## License

MIT
