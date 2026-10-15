# lean-project

A Claude Code plugin that makes every session cheaper. Claude re-sends the whole conversation on every turn, and loads some files into every session, so tokens go to orientation and old context before any work happens. lean-project keeps that overhead small:

- **New projects** start with a short index, a plan whose phases are gates with acceptance checks, and a 20-line state file. Any fresh session can pick the project up for about 1 to 2k tokens.
- **Docs audits** measure what a session pays, remove duplicated rules, slim state files, and add contents tables so Claude opens one section instead of a whole file. Nothing is deleted: trimmed text moves to an archive.
- **File maps** give an outline with line ranges for large markdown and source files (PHP, JS/TS, Python, Go, Ruby, Rust, Java, Kotlin, C#, Swift, shell), so Claude reads the 40 lines it needs, not 1,000.
- **Build mode** works through the plan phase by phase and routes tasks by model: Haiku for bulk reading and fixtures, Sonnet for well-specified code, tests and lint fixes, Opus for review and acceptance, and the main session for design. Each task gets a short self-contained brief, and the main session verifies every result.
- **A shared board** lets parallel subagents and sessions talk while they work: cards move through todo, doing, blocked and done, and agents post one-line facts their siblings need (a contract, a format, a gotcha). It is one append-only file, so parallel writers never overwrite each other, and the lead reads a compact view instead of waiting on replies.
- **A fresh-session reminder** (a hook) speaks up once the conversation passes a context limit (default 300k tokens): update the state file, then start over from it.
- **It learns.** Each run records a lesson in your own data folder; a lesson seen twice becomes a local rule that outranks the defaults.

## Install

In Claude Code:

```
/plugin marketplace add nikola-vladimirov/lean-project
/plugin install lean-project@lean-project
```

Requires bash: built in on macOS and Linux, and Git Bash on Windows (which Claude Code uses there). No other dependencies.

## Use

Ask in plain words, or run the skill directly (`/lean-project:lean-project`):

- "Start a new project for ..." creates the folder, the index, the plan and the state file after one round of questions.
- "Audit the docs in this project for token use" measures, trims and reports before and after.
- "Build phase 2 from the plan" routes the phase's tasks across models and checks the phase's gate.

The `lean-project` command is on Claude's PATH while the plugin is enabled:

```
lean-project map <file>          # outline with line ranges
lean-project map <dir> [min]     # files of min+ lines (default 300)
lean-project toc <file>...       # build or refresh contents tables in markdown
lean-project cost [dir]          # tokens loaded every session, every doc with flags, duplicated lines
lean-project board [id]          # shared board: all cards, or one card's history
lean-project board add|move|note <id> ...
lean-project selftest
```

## Settings

`/config` shows four options:

| Option | Default | What it does |
|---|---|---|
| Context limit | 300,000 tokens | When the fresh-session reminder first speaks up |
| Remind again every | 50,000 tokens | How often it repeats after that |
| Always back up docs before editing | off | On: copy every doc to a dated backup folder before lean-project edits it. Off: back up only when the project is not under version control |
| Backup folder | `backups` | Where backups go, relative to the project folder |

## Where your data lives

Lessons go to the plugin's data folder (`~/.claude/plugins/data/lean-project-*/LESSONS.md`), which survives plugin updates. Nothing leaves your machine.

## License

MIT
