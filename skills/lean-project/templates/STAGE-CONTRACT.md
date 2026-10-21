# Stage contract: <stage name>

Use one per stage of a multi-stage workflow. Keep it to these three sections.

## Inputs

| Source | File and section | Why |
|---|---|---|
| <previous stage output or reference> | <path, then the heading or line range to read> | <one line> |

Load only these rows. Anything else is out of scope for this stage.

## Process

1. <step>
2. <step>

## Outputs

| Artifact | Location | Format |
|---|---|---|
| <name> | <path under this stage's output/> | <markdown, code, etc.> |

Rule: references point outward only. A stage may read earlier stages and shared references. No earlier file may point back at this stage.
