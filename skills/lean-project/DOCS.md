# Docs mode: audit and trim

Goal: the smallest auto-load and session-start cost with no information lost.

1. **Baseline:** `lean-project cost <project dir>`. Keep the output for the report. Back up as the backup setting in SKILL.md says, before the first edit.
2. **Index** (the project's CLAUDE.md, under about 60 lines): one-line status, pointer to the state file, a folder map with one line per file saying what it holds, reading rules by task ("for X open Y section Z"), upkeep rules, ground rules. Nothing that memory, a linked doc or the code already says. A CLAUDE.md in a parent folder loads too: keep it to a project table and workspace-wide rules.
3. **One home per rule.** Each DUPLICATE line from `cost` keeps one home (the index for process rules, the topic doc for facts); the other copies go or become a pointer. `cost` catches only exact lines, and real copies are usually paraphrases: compare MEMORY.md, the state file and any parent CLAUDE.md with the index by eye. The usual offender is the state-file upkeep rule; its home is the state file's first line.
4. **Memory:** one line per note in MEMORY.md (what to do, not why); the note file holds the why. Never cut a pointer to a standing rule: memory is how rules reach a fresh session.
5. **State file:** only "Now", "In progress", "Next"; under about 30 lines; no turn log once git exists; updated at the end of a work session. Findings go to the doc they belong in.
6. **Session rules** to write into the index when they apply: bulk reading in a cheap subagent that writes answers into a named doc with the source; one session per phase or milestone, restarted from the state file; maps before large files; page text before screenshots; real sanitised responses saved as fixtures early.
7. **Contents tables:** `lean-project toc` on every doc of 80+ lines. Headings specific enough that the table alone says which range to open; split sections over about 150 lines into `###` parts. Stable IDs (R1, P-01, D1) on rules, features and decisions so a grep lands on one line.
8. **Logs that keep growing** (changelogs, activity logs): keep the recent window (the file's own rule, else 3 months) and move older entries verbatim to `<name>-archive.md`, with a pointer line each way. Check that the line counts add up.
9. **Never delete content.** Trimmed text moves verbatim to an archive file (with a table, never read whole). Empty placeholders can go.
10. **Measure again** and report:

```
## lean-project docs: <project>
| | Before | After |
| Auto-loaded tokens | | |
| Session start (auto + state file) | | |
| Duplicate lines | | |
| Docs needing a table | | |
Changes: one line each.
Lesson recorded: <one line>.
```
