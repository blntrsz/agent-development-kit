# Sandbox

**Sandbox** is an isolated environment where ADK can safely execute commands and prompts, and run coding agents without supervision. It provides a controlled runtime for potentially untrusted work without running it directly on the host.

Local sandbox execution uses Docker. Remote sandbox execution uses ECS. Both use the same Docker image.

## Ubiquitous Language

**Sandbox Definition** is a Dockerfile that defines a sandbox image. It is located at `<project-root>/.adk/sandbox/<sandbox-name>/Dockerfile`.

---

**Default Sandbox** is the fallback **Sandbox** defined at `<project-root>/.adk/sandbox/default/Dockerfile`.

---

**Running Sandbox** is a started **Sandbox** that is ready to accept commands and prompts.

## Business Rules

- When ADK resolves a sandbox by name, it should use `<project-root>/.adk/sandbox/<sandbox-name>/Dockerfile`.
- If a named sandbox is not found, ADK should use the **Default Sandbox**.
- If neither the named sandbox nor the **Default Sandbox** exists, ADK should fail with a clear error.
- Starting a sandbox should build its image first when needed.
- A **Running Sandbox** should accept commands and prompts for execution.
- A command passed to ADK for sandbox execution should execute inside the selected sandbox workspace.
- A prompt passed to ADK for sandbox execution should run inside the selected sandbox with the configured agent.
- A **Running Sandbox** should stop when execution finishes or when it is no longer needed.

## Features

- [Define sandbox](./features/define-sandbox.feature): define a named sandbox from a sandbox Dockerfile.
- [Define default sandbox](./features/define-default-sandbox.feature): define the fallback sandbox from the default sandbox Dockerfile.
- [Start sandbox](./features/start-sandbox.feature): start a sandbox from the selected sandbox Dockerfile, building it first when needed.
- [Stop sandbox](./features/stop-sandbox.feature): stop a running sandbox when execution finishes or it is no longer needed.
- [Execute command in sandbox](./features/execute-command-in-sandbox.feature): pass a command into the selected sandbox and execute it in the sandbox workspace.
- [Execute prompt in sandbox](./features/execute-prompt-in-sandbox.feature): run a prompt inside the selected sandbox with the configured agent.
