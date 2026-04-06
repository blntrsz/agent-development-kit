---
name: architecture
description: Describe the architectural guidelines for organizing code in ADK packages. The recommended approach is to structure code as vertical slices by business capability, with each slice following a hexagonal architecture pattern. This promotes separation of concerns, maintainability, and testability across the codebase.
---

## Goals

- Organize code by business capability, not by technical layer at package root.
- Keep business rules isolated from infrastructure and framework details.
- Make dependencies point inward toward the business rules.
- Give every slice the same internal shape so code is easier to navigate.

## Source Layout

ADK packages should prefer this layout:

```text
packages/
  <package>/
    src/
      <slice>/
        index.ts
        domain/
        use-case/
        port/
        adapter/
```

Rules:

- A slice owns one business capability, such as `agent`, `workflow`, `sandbox`, or `run`.
- New code should be added inside a slice instead of package-wide technical folders.
- Each slice should expose a small public API through `<slice>/index.ts`.
- Existing code can migrate toward this layout incrementally.

## Slice Responsibilities

| Folder | Responsibility |
| --- | --- |
| `domain/` | Entities, value objects, business rules, and invariants. Keep it pure and free of I/O concerns. |
| `use-case/` | Application actions that coordinate domain logic through ports. |
| `port/` | Boundary contracts for the slice, such as repositories, gateways, clocks, and event publishers. |
| `adapter/` | Infrastructure and delivery code that implements or invokes ports, such as Docker, AWS, CLI, or persistence code. |

`port/` holds all boundary contracts for the slice. If a slice needs more structure, it may split that folder into `port/in/` and `port/out/`, but `port/` remains the top-level layer.

## Dependency Rules

- `domain/` must not depend on `use-case/`, `port/`, or `adapter/`.
- `use-case/` may depend on `domain/` and `port/`, but never on `adapter/`.
- `port/` defines contracts for the slice boundary and may reference `domain/` types when useful.
- `adapter/` may depend on `use-case/`, `port/`, `domain/`, and external libraries.
- `domain/`, `use-case/`, and `port/` must never import from `adapter/`.
- One slice must not import another slice's internals; cross-slice usage should go through the other slice's public API.

## Example Slice

```text
packages/core/src/sandbox/
  index.ts
  domain/
    sandbox.ts
    sandbox-id.ts
    sandbox-status.ts
  use-case/
    create-sandbox.ts
    start-sandbox.ts
    execute-command.ts
    destroy-sandbox.ts
  port/
    container-runtime.ts
    sandbox-store.ts
  adapter/
    docker-container-runtime.ts
    in-memory-sandbox-store.ts
```

## Composition Rules

- Compose concrete adapters at the slice entry point or package runtime boundary.
- Keep `domain/`, `use-case/`, and `port/` testable with fakes or stubs.
- Runtime wiring, Effect layers, and other framework-specific setup belong in `adapter/` or the slice entry point, not in `domain/`.

