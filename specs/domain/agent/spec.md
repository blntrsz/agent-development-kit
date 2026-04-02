# Agent

## Overview
The Agent slice defines reusable agents under `.adk/agents/`. It gives workflows a stable way to choose a model, system instructions, and secret bindings in local and remote execution.

## Boundaries
Included:
- Agent registration from `.adk/agents/*.ts`
- Default agent selection for `adk.prompt()` and `adk.skill()`
- Secret reference resolution for local and remote runs

Excluded:
- Workflow definition and orchestration
- Skill file lookup
- Remote infrastructure provisioning and sandbox publication

## Main Concepts
The terms in this section are the ubiquitous language for the Agent slice.

| Concept | Definition | Relationship |
| --- | --- | --- |
| Agent | Reusable runtime persona declared with `defineAgent(...)`. | Selected explicitly by runtime calls or implicitly through the default agent. |
| Agent name | Stable identifier in the `name` field. | Must remain unique and should match the file name. |
| Default agent | Special agent declared in `.adk/agents/default.ts`. | Used when prompt or skill execution omits an explicit agent. |
| Secret reference | Mapping from an agent to credentials. | Resolves from local environment variables or AWS Secrets Manager depending on execution mode. |

## Business Rules
- `.adk/agents/` is a flat directory in v1.
- Agent modules default-export `defineAgent(...)`.
- Duplicate agent names fail at load time.
- Implicit agent resolution fails when `default.ts` is missing.
- ADK resolves remote secrets but does not create missing agent secrets.

## Features
- [Define agent](features/define-agent.feature)
- [Resolve default agent](features/resolve-default-agent.feature)
- [Resolve agent secret](features/resolve-agent-secret.feature)
