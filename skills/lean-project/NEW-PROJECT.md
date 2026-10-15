# New-project mode

Goal: a project any fresh session can pick up for about 1 to 2k tokens: a short index, a plan with gates, a state file. Nothing else until the project needs it.

## 1. Ask once, or grill

**Loosely described** (an idea or a one-liner, or the user cannot yet say what done looks like, who it is for, or what the main pieces are): read `GRILL.md` and follow it instead of the single round below. Its settled decisions feed the plan in step 3.

Otherwise, one round of questions (the AskUserQuestion tool if available), skipping anything already known:

- What it is, who it is for, and what done looks like.
- Stack or platform, and how it ships (zip, package, container, site).
- What exists already: spec, code, designs, APIs and their docs, reference projects.
- Hard constraints: deadline, budget, must and never rules, who else works on it.

Unknowns become assumptions and decisions with defaults in the plan, so they never block the start.

## 2. Lay out the folder

```
<project>/
├── CLAUDE.md         index: status, folder map, reading rules by task, upkeep, ground rules
├── docs/
│   ├── PLAN.md       goal, assumptions, decisions, architecture, sources, phases with gates, risks
│   └── HANDOFF.md    state: now, in progress, next
└── <code>/           the stack's usual layout
```

- **Docs never ship.** When the deliverable is a folder that ships whole (a WordPress plugin, an npm package, a theme), put the shipped code in a subfolder (`plugin/`, `src/`, `package/`) or exclude `docs/` and `CLAUDE.md` from the build (export-ignore, `files`, `.npmignore`).
- **Copy the templates** from the `templates/` folder (path in SKILL.md; `INDEX.md` becomes `CLAUDE.md`; `PLAN.md` and `HANDOFF.md` go to `docs/`) and fill them. Delete template lines that do not apply; never leave placeholders.
- **Extras only when needed:** `templates/extras/RULES.md` once there are more than about 10 binding rules or several contributors; `INTEGRATIONS.md` when the project calls external APIs; `ARCHIVE.md` the first time text is replaced; `docs/GLOSSARY.md` when grilling settles the first term (format in `GRILL.md`).

## 3. Write the plan

- Keep it as short as the project allows. Stable IDs on everything (A1, D1, P1, R1) so a grep finds one line.
- Every decision gets a default, so work can start before the user answers.
- **Phases are gates.** Each phase lists its scope and acceptance checks that a command or a person can verify. The next phase starts only when every check is ticked in the plan.
- **Phase 0 verifies unknowns** (API behaviour, limits, data formats, access) when the project depends on anything external. Facts from unofficial sources are leads until checked.
- Optional per phase: which parts go to which model (see `BUILD.md`).

## 4. Version control

If the folder is not a repository, offer `git init` with a `.gitignore` for the stack. Ask before creating any remote or pushing.

## 5. Finish

Run `lean-project toc` on docs of 80+ lines and `lean-project cost <project>`. Report the session-start tokens (auto-loaded plus the state file), list the open decisions the user should answer, and record a lesson.
