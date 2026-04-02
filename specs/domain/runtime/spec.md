# Runtime

## Overview
The Runtime slice defines the APIs a workflow uses while running. It covers shell execution, prompt execution, and skill execution from inside the selected sandbox.

## Boundaries
Included:
- `adk.shell()` behavior
- `adk.prompt()` behavior
- `adk.skill()` behavior
- Structured result validation for shell and skill execution

Excluded:
- Workflow registration and lifecycle
- Sandbox build and selection
- Skill file lookup rules and agent definition rules beyond runtime usage

## Main Concepts
The terms in this section are the ubiquitous language for the Runtime slice.

| Concept | Definition | Relationship |
| --- | --- | --- |
| Runtime API | The `adk` object passed to `run(adk, input)`. | Gives workflows controlled access to shell, prompt, and skill capabilities. |
| Shell call | Command execution through `adk.shell()`. | Runs from the checked-out project root in the selected sandbox. |
| Prompt call | Freeform model interaction through `adk.prompt()`. | Uses an explicit agent or the default agent. |
| Skill call | Skill execution through `adk.skill()`. | Uses resolved skill content plus an explicit or default agent. |
| Structured result | Parsed, validated output returned by `result` schemas. | Available for shell and skill calls. |

## Business Rules
- `adk.shell()` runs in the checked-out project root by default.
- Non-zero shell exit codes fail the call.
- Structured shell output uses `result`; there is no separate JSON mode.
- `adk.prompt()` and `adk.skill()` use the explicit agent when given, else the default agent.
- `adk.skill()` passes `options.args` through to the skill and may validate structured output.

## Features
- [Run shell command](features/run-shell-command.feature)
- [Return structured shell result](features/return-structured-shell-result.feature)
- [Run prompt with agent](features/run-prompt-with-agent.feature)
- [Run skill with agent](features/run-skill-with-agent.feature)
