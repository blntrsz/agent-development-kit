# Run

## Overview
The Run slice defines the `adk run` user journey. It covers how a workflow run starts from the CLI, how execution mode is chosen, and how repository contents are selected for execution.

## Boundaries
Included:
- Project-root requirements for `adk run`
- Local vs remote mode selection
- Workflow args parsing and delivery
- Branch-based repository content selection

Excluded:
- Workflow and sandbox definition semantics
- Remote deployment provisioning
- Runtime API behavior after the workflow starts running

## Main Concepts
The terms in this section are the ubiquitous language for the Run slice.

| Concept | Definition | Relationship |
| --- | --- | --- |
| Run command | CLI entry point `adk run <workflow>`. | Starts a workflow in local or remote mode. |
| Project root | Current directory containing `.adk/`. | Required context for locating workflows, skills, and sandboxes. |
| Execution mode | Local Docker mode or remote ECS mode. | Local is default; remote is explicit with `--remote`. |
| Workflow args | JSON object supplied with `--args`. | Parsed and validated against the workflow input schema. |
| Target ref | Branch or `HEAD` selected for repository contents. | Changes checked-out contents inside the sandbox without changing sandbox selection. |

## Business Rules
- `adk run` must be started from the project root and does not search upward in v1.
- Local execution is the default; `--remote` selects ECS.
- Missing `--args` defaults to `{}`.
- `--args` must be parsed and validated before `run` is called.
- `--branch` changes repository contents inside the run environment.
- Branch selection does not change the sandbox selected from the local workflow definition.

## Features
- [Run from project root](features/run-from-project-root.feature)
- [Default to local execution](features/default-to-local-execution.feature)
- [Pass workflow args](features/pass-workflow-args.feature)
- [Select branch contents](features/select-branch-contents.feature)
