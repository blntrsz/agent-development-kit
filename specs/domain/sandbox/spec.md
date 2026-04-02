# Sandbox

## Overview
The Sandbox slice defines the execution environment for workflows. It describes how sandboxes are declared, how ADK chooses them, and how local sandbox images are built and reused.

## Boundaries
Included:
- Sandbox declaration from `.adk/sandbox/<name>/Dockerfile`
- Runtime boundary of a selected sandbox
- Local sandbox build-on-first-use behavior
- Local sandbox image reuse semantics

Excluded:
- Workflow registration and validation
- Runtime API semantics inside a running sandbox
- Remote deployment orchestration beyond publishing sandbox images

## Main Concepts
The terms in this section are the ubiquitous language for the Sandbox slice.

| Concept | Definition | Relationship |
| --- | --- | --- |
| Sandbox | Named workflow runtime defined by a Docker build context. | Selected by a workflow and used as the full execution environment. |
| Default sandbox | Special sandbox at `.adk/sandbox/default/`. | Used when a workflow does not name a sandbox. |
| Sandbox image | Built artifact for a sandbox. | Reused across local runs when the cache key matches. |
| Workspace materialization | Checked-out repository inside the sandbox. | Gives the workflow and runtime APIs access to project contents. |
| Local image cache key | Project-scoped identity for a local sandbox image. | Prevents collisions across different repositories that share sandbox names. |

## Business Rules
- Each sandbox is declared by a Dockerfile under `.adk/sandbox/<name>/`.
- The selected sandbox defines the whole workflow runtime, not only `adk.shell()` subprocesses.
- The checked-out repository is materialized inside the sandbox workspace before execution.
- Local runs auto-build a sandbox image on first use.
- Local sandbox reuse is keyed by absolute project root plus sandbox name.

## Features
- [Define sandbox](features/define-sandbox.feature)
- [Run workflow in selected sandbox](features/run-workflow-in-selected-sandbox.feature)
- [Build local sandbox on first use](features/build-local-sandbox-on-first-use.feature)
- [Reuse local sandbox image](features/reuse-local-sandbox-image.feature)
