# Workflow

## Overview
The Workflow slice defines runnable automation units under `.adk/workflows/`. It captures the workflow contract, the code entry point, and the sandbox the workflow asks ADK to run in.

## Boundaries
Included:
- Workflow registration from `.adk/workflows/*.ts`
- Workflow naming and local resolution rules
- Input and output validation
- Sandbox selection declared by the workflow

Excluded:
- Sandbox build and image lifecycle
- Runtime API behavior inside `run`
- CLI mode selection and remote deployment provisioning

## Main Concepts
The terms in this section are the ubiquitous language for the Workflow slice.

| Concept | Definition | Relationship |
| --- | --- | --- |
| Workflow | Executable unit declared with `defineWorkflow(...)`. | Invoked by `adk run` and executed inside a selected sandbox. |
| Workflow name | Stable workflow id. | Defaults to the file name and must match it when set explicitly. |
| Workflow contract | `input` and `output` schemas for a workflow. | Parsed before `run` starts and validated again before success is reported. |
| Run function | Async business logic in `run(adk, input)`. | Receives validated input and drives runtime calls. |
| Sandbox selection | Optional `sandbox` field on the workflow. | Chooses which sandbox artifact will host the workflow runtime. |

## Business Rules
- `.adk/workflows/` is a flat directory in v1.
- Workflow modules default-export `defineWorkflow(...)`.
- Workflow names default to file names; explicit names must match the file name.
- Input validation happens before `run`, and output validation happens before success.
- The local workflow file must exist even for remote runs.
- ADK resolves the sandbox from the local workflow definition.

## Features
- [Define workflow](features/define-workflow.feature)
- [Validate workflow input and output](features/validate-workflow-input-and-output.feature)
- [Resolve workflow locally](features/resolve-workflow-locally.feature)
- [Select sandbox from workflow](features/select-sandbox-from-workflow.feature)
