# Build mode: plan-driven development across models

For building a project phase by phase from its plan. The main session is the lead: it plans, decides, integrates and verifies. Cheaper models do the parts that fit them, in subagents whose context is thrown away. Goal: the cheapest model that passes each task, and the least context carried by the lead.

## Before a phase

1. Read the "Local rules" and "Model fit" lines in the lessons file (path in SKILL.md). They override the routing table below.
2. Read the state file, then only the plan's section for this phase and the sections it names (contents table ranges). The binding rules doc in full only if code will be written.
3. Split the phase into tasks. Each task gets a file set, plan references (line ranges and IDs, not pasted text), an acceptance check (a command or an observable result) and a route from the table. Tasks that touch the same files go to one writer, in order.
4. Put the task list in the app's task list (`update_plan`), not in a new doc.

## Routing

| Work | Model | Effort | How |
|---|---|---|---|
| Bulk reading: API docs, reference or competitor projects, long logs | haiku | low | Agent, background, several at once; returns answers with source paths, or writes them into one named doc section |
| Code sweep: where is X, every caller of Y | haiku | low | Explore agent |
| Fixtures: sanitise real responses, build test data | haiku | medium | Agent; the lead spot-checks for leftover personal data |
| Well-specified unit from the plan (one class or function with its contract) plus its tests | sonnet | medium | Agent (general-purpose), one writer per file set |
| Admin screens, settings, i18n strings, readme and changelog drafts | sonnet | low | Agent |
| Lint and static-analysis fixes | sonnet | low | Agent, loop until clean |
| Architecture, data model, migrations, sync and idempotency, money or data-loss paths | lead | the session's own | here, not delegated |
| Security review, phase code review, acceptance check | opus | high | Agent with fresh context (not the author's); the lead itself when the lead is Opus and has not written the code |
| A failure the first route could not fix twice | see "After each task" | | |

Pass both with the Agent tool's `model` (`haiku`, `sonnet`, `opus`) and `effort` (`low`, `medium`, `high`, `xhigh`, `max`) parameters; `start_session` takes the same two. Effort is the cheaper dial: more thinking on the same model costs less than the next model up, so raise it first. Keep `xhigh` and `max` for the lead's own hardest calls, never for routine delegation.

## How to delegate

- **Read-only tasks:** Agent with `model` and `run_in_background: true`; run independent ones in parallel, at most about 5 at a time.
- **Writing tasks:** one at a time in the same checkout by default. Parallel writers only on disjoint files and only with `isolation: "worktree"` (needs git); the lead merges.
- **A large independent piece** (hours of work): propose a separate session (`start_session`, `model` set, own worktree). Start it only when the user asked for separate or parallel work.
- **Workflow tool:** only when the user says "use a workflow".
- **Too small to delegate:** anything that takes fewer tool calls than writing its brief. Do it here.

## Brief (every delegated task)

Subagents start cold and do not see memory, so the hard rules go in the brief and the docs are pointed to, not pasted.

```
Task: <one sentence>. Project index: <path> (short, read it first).
Read only: <file:start-end>, <file:start-end>. Rules that apply: <IDs>.
Change only: <files>. Touch nothing else.
Done when: <command passes / observable check>.
Constraints: <user rules from memory: no em dashes, prefixes, text domain, no live writes, ...>.
If the project has a code graph tool, query it before exploring; map files over 300 lines (lean-project map) and read ranges.
Return in under 15 lines: files changed, check result, open questions. No code dumps.
```

## After each task

- **Verify it yourself:** read only the changed hunks and run the check. A subagent's report is not proof.
- **Failed once:** the usual cause is a missing piece of context. Fix the brief and rerun on the same model.
- **Failed twice:** raise the effort one level on the same model (low to medium, medium to high) and rerun.
- **Failed three times:** move one model up (haiku to sonnet, sonnet to opus or the lead), starting again at medium effort.
- **Record model fit** in LESSONS.md as "Model fit: <task type>, <model> at <effort>, passed / failed because <reason>". When the same task type passes twice at a lower setting than the table says, or fails twice at the table's setting, add the corrected route to the "Local rules" in LESSONS.md.

## Phase gate

1. An Opus reviewer (or the lead, if it did not write the code) checks the phase's acceptance criteria and ticks them off in the plan.
2. Before any build is final: security review, code review and tests, using the stack's review and testing skills when installed.
3. Update the state file, refresh the code graph if the project has one, and end the session. The next phase starts fresh from the state file.

## Cost guards

- Subagent replies stay under 15 lines; never open their transcripts.
- Parallel only for independent tasks.
- The lead reads diffs and check output, not whole files a subagent wrote.
