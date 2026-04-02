# ADK Interface Spec

Structured specs: [Specs Index](README.md)

## Goals

- Let a repo define agent behavior in code under `.adk/`.
- Keep the authoring model the same for local runs and AWS provisioning.
- Keep workflow code mostly plain TypeScript.

## Project Layout

```text
.agents/
  skills/
    triage/
      SKILL.md
    review/
      analyze.md
.adk/
  agents/
    default.ts
    triage-bot.ts
  sandbox/
    default/
      Dockerfile
    triage/
      Dockerfile
  workflows/
    triage.ts
    code-review.ts
```

- `.adk/` lives at the repo root.
- `.agents/skills/` is the skill root.
- `agents/*.ts` define reusable agents.
- `sandbox/*/Dockerfile` define named workflow sandboxes.
- `workflows/*.ts` define runnable workflows.
- Modules are standard ESM TypeScript and run on Bun.
- `.adk/agents/` and `.adk/workflows/` are flat in v1. Nested directories are not supported.
- Workflow ids come from the file name without the `.ts` extension.
- Agent ids come from `defineAgent({ name })`. The name should match the file name.
- Sandbox ids come from the directory name under `.adk/sandbox/`.

## Agent Definition

Agent modules default-export `defineAgent(...)`.

```ts
type SecretRef =
  | string
  | {
      secretsManager?: string
      localEnv?: string
    }

interface AgentConfig {
  name: string
  system: string
  model: string
  secret?: SecretRef
}

declare function defineAgent(config: AgentConfig): AgentConfig
```

| Field | Required | Notes |
| --- | --- | --- |
| `name` | yes | Stable agent id. Should match the file name. |
| `system` | yes | System prompt for the agent. |
| `model` | yes | Model id, eg `gpt-5.4`. |
| `secret` | no | Secret ref needed by the agent. |

Secret semantics:

- `secret: "GITHUB_TOKEN"` means `GITHUB_TOKEN` in local env and an existing AWS Secrets Manager secret named `GITHUB_TOKEN` in remote mode.
- Object form is for different local and remote names.
- Object form must set at least one of `secretsManager` or `localEnv`.
- ADK does not create agent secrets in v1. Remote runs expect those secrets to already exist.

Default agent rules:

- `.adk/agents/default.ts` is special.
- It is used when `adk.prompt()` or `adk.skill()` does not receive an explicit agent.
- If no default agent exists, implicit agent selection must fail with a clear error.
- Duplicate agent names must fail at load time.

Example:

```ts
// .adk/agents/triage-bot.ts

export default defineAgent({
  name: "triage-bot",
  system: "You are a helpful assistant that helps triage GitHub issues.",
  model: "gpt-5.4",
  secret: "GITHUB_TOKEN",
})
```

```ts
// .adk/agents/default.ts

export default defineAgent({
  name: "default",
  system: "You are a helpful assistant that helps with various tasks related to the codebase.",
  model: "gpt-5.4",
})
```

## Workflow Definition

Workflow modules default-export `defineWorkflow(...)`.

```ts
import type { StandardSchemaV1 } from "@standard-schema/spec"

type StandardSchema<I = unknown, O = I> = StandardSchemaV1<I, O>

interface AdkRuntime {
  shell(command: string, options?: ShellOptions): Promise<string>
  shell<T>(command: string, options: ShellResultOptions<T>): Promise<T>
  prompt(input: string, agent?: string): Promise<string>
  skill<T = string>(id: string, options?: SkillOptions<T>): Promise<T>
}

interface WorkflowConfig<Input = unknown, Output = void> {
  name?: string
  description?: string
  sandbox?: string
  input?: StandardSchema<unknown, Input>
  output?: StandardSchema<unknown, Output>
  run: (adk: AdkRuntime, input: Input) => Promise<Output>
}

declare function defineWorkflow<Input, Output = void>(
  config: WorkflowConfig<Input, Output>,
): WorkflowConfig<Input, Output>
```

Workflow rules:

- The default export is a workflow config created with `defineWorkflow(...)`.
- `name` defaults to the file name without the `.ts` extension.
- If `name` is set, it must match the file name.
- `description` is optional metadata for CLI and UI surfaces.
- `sandbox` selects a named sandbox under `.adk/sandbox/<name>/Dockerfile`.
- If `sandbox` is omitted, ADK uses the `default` sandbox.
- If the selected sandbox does not exist, workflow load must fail with a clear error.
- The workflow file must exist locally to start either a local or remote run.
- The CLI resolves the workflow and sandbox from the local workflow definition.
- In v1, `--branch` changes the repo contents executed inside the sandbox, but does not change the selected sandbox.
- External workflow input should be JSON-serializable.
- Workflows do not declare their own secrets in v1.
- If `input` is present, ADK validates and parses input before calling `run`.
- If `output` is present, ADK validates the resolved return value before marking success.
- If `input` validation fails, `run` is not called.
- Workflows run inside their selected sandbox as the whole runtime.
- Throwing or rejecting marks the workflow as failed.

## Sandbox Definition

Sandboxes are Docker build contexts under `.adk/sandbox/<name>/`.

Minimum layout:

```text
.adk/
  sandbox/
    default/
      Dockerfile
```

Rules:

- Each sandbox must contain a `Dockerfile`.
- Sandbox Dockerfiles should include ADK, typically via `FROM ghcr.io/adk/runtime:latest`.
- `default` is special and is used when a workflow does not set `sandbox`.
- Additional sandboxes may be defined, eg `.adk/sandbox/triage/Dockerfile`.
- Sandbox names are the directory names under `.adk/sandbox/`.
- ADK runs each workflow inside its selected sandbox.
- The sandbox defines the whole workflow runtime, not just `adk.shell()`.
- The project repository is materialized inside the sandbox workspace before execution.
- Local sandboxes auto-build on first use and are then reused.
- Local sandbox image cache keys are based on absolute project root plus sandbox name.
- Automatic sandbox rebuild and invalidation rules are deferred in v1.

Example:

```dockerfile
# .adk/sandbox/default/Dockerfile
FROM ghcr.io/adk/runtime:latest

RUN apt-get update && apt-get install -y git gh && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
```

## Skill Resolution

Skills resolve from `.agents/skills/` at the checked-out project root.

Rules:

- `adk.skill("triage")` resolves to `.agents/skills/triage/SKILL.md`.
- `adk.skill("review/analyze.md")` resolves to `.agents/skills/review/analyze.md`.
- Skill ids must stay within `.agents/skills/` after path resolution.
- Missing skills must fail with a clear error.
- Built-in or remote skill resolution is not part of v1.

## Runtime API

```ts
import type { StandardSchemaV1 } from "@standard-schema/spec"

type StandardSchema<I = unknown, O = I> = StandardSchemaV1<I, O>

interface ShellOptions {
  stdin?: string
  cwd?: string
  env?: Record<string, string>
}

interface ShellResultOptions<T = unknown> extends ShellOptions {
  result: StandardSchema<unknown, T>
}

interface SkillOptions<T = string> {
  args?: Record<string, unknown>
  agent?: string
  result?: StandardSchema<unknown, T>
}
```

`adk.shell()`:

- Runs a shell command in the checked-out project root inside the sandbox by default.
- Returns stdout as a string.
- Throws on non-zero exit.
- Pipes `stdin` into the process when provided.
- With `result`, parses stdout as JSON and validates it before returning it.
- There is no separate `{ json: true }` mode.

`adk.prompt()`:

- Runs a freeform prompt against an agent.
- Returns plain text.
- Uses the named agent if provided.
- Uses the default agent otherwise.

`adk.skill()`:

- Runs a named or path-like skill.
- Receives template or skill args through `options.args`.
- Uses the named agent if provided.
- Uses the default agent otherwise.
- Returns text by default.
- With `result`, returns validated structured output.

Notes:

- Workflow `input` and `output`, `skill(..., { result })`, and `shell(..., { result })` use the Standard Schema V1 protocol.
- Examples below use a generic validator namespace called `v` as shorthand for any Standard Schema V1-compatible schema library.

## Execution Model

`adk run` has two execution modes.

Local mode:

- Local mode is the default.
- Local mode runs in Docker.
- ADK loads `.adk/workflows/<workflow>.ts` from the local project root and resolves the sandbox from that file.
- If the local git worktree has staged, unstaged, or untracked changes, the command fails before starting the container.
- ADK copies the current repository into the container, including `.git/`.
- Inside the container, ADK checks out a clean target ref before running the workflow.
- Without `--branch`, the target ref is local `HEAD`.
- With `--branch <name>`, ADK checks out that branch inside the copied repository.
- If the selected branch does not exist in the copied repository, the command fails.
- Git submodules are not initialized or updated in v1.

Remote mode:

- Remote mode is selected with `--remote`.
- Remote mode runs on ECS.
- `adk run --remote` requires a prior `adk deploy remote`.
- ADK still loads `.adk/workflows/<workflow>.ts` from the local project root and resolves the sandbox from that local file.
- ADK uses the local repository `origin` URL as the clone source.
- ECS clones the repository fresh for each run.
- Without `--branch`, ECS checks out the current local `HEAD` commit SHA.
- If that SHA is not available in the remote repository, the command fails.
- With `--branch <name>`, ECS checks out that branch in the fresh clone.
- The target branch may change workflow code and `.adk` contents, but it does not change the sandbox chosen for that run.
- Remote runs use deployed sandbox images only. `adk run --remote` does not build or deploy remote infrastructure.
- Git submodules are not initialized or updated in v1.

## Examples

Issue triage workflow:

```ts
// .adk/workflows/triage.ts

export default defineWorkflow({
  description: "Triage a GitHub issue and post a summary comment.",
  sandbox: "triage",
  input: v.object({
    issueNumber: v.number(),
  }),
  async run(adk, { issueNumber }) {
    const details = await adk.shell(`gh issue view ${issueNumber} --json number,title,body,comments`, {
      result: v.object({
        number: v.number(),
        title: v.string(),
        body: v.unknown(),
        comments: v.array(v.unknown()),
      }),
    })

    const result = await adk.skill("triage", {
      args: { issue: details },
    })

    const comment = await adk.prompt(
      `Summarize the triage for issue #${issueNumber}: ${result}`,
      "triage-bot",
    )

    await adk.shell(`gh issue comment ${issueNumber} --body-file -`, {
      stdin: comment,
    })
  },
})
```

Code review workflow:

```ts
// .adk/workflows/code-review.ts

export default defineWorkflow({
  description: "Analyze a pull request and publish a GitHub review.",
  input: v.object({
    prNumber: v.number(),
  }),
  async run(adk, { prNumber }) {
    await adk.shell(`gh pr checkout ${prNumber}`)

    const details = await adk.shell(`gh pr view ${prNumber} --json number,title,body,comments`, {
      result: v.object({
        number: v.number(),
        title: v.string(),
        body: v.unknown(),
        comments: v.array(v.unknown()),
      }),
    })

    const review = await adk.skill("review/analyze.md", {
      args: { details },
      result: v.object({
        comments: v.array(v.object({ path: v.string(), line: v.number(), body: v.string() })),
        body: v.string(),
      }),
    })

    await adk.shell(`gh api repos/{owner}/{repo}/pulls/${prNumber}/reviews --method POST --input -`, {
      stdin: JSON.stringify({
        event: "COMMENT",
        body: review.body,
        comments: review.comments,
      }),
    })
  },
})
```

## CLI

Run a workflow by its file name:

```bash
adk run triage
adk run triage --args '{"issueNumber":123}'
adk run triage --branch feature/triage-improvements
adk run triage --remote --branch main
adk run code-review --args '{"prNumber":456}'
```

CLI rules:

- `adk` commands are run from the project root.
- In v1, ADK does not search parent directories for a project root.
- The current working directory must contain `.adk/`.
- `adk run <workflow>` loads `.adk/workflows/<workflow>.ts`.
- Local mode is the default. `--remote` selects ECS.
- `--args` accepts a JSON object string.
- If `--args` is omitted, ADK passes `{}` as the workflow input.
- `--branch <name>` selects the branch to check out inside the sandbox workspace.
- Without `--branch`, ADK uses `HEAD`.
- The `--args` payload is validated against the workflow `input` schema before `run` executes.
- The parsed input is passed as the second argument to `run`.
- Skill resolution uses `<projectRoot>/.agents/skills/`.
- ADK resolves the workflow sandbox before execution.
- If the workflow does not set `sandbox`, ADK uses `.adk/sandbox/default/`.
- If `.adk/sandbox/default/Dockerfile` does not exist and a default sandbox is needed, the command fails with a clear error.
- Local runs fail if the git worktree is dirty.
- Remote runs require a configured `origin` remote and a prior `adk deploy remote`.
- The workflow runs inside the selected sandbox.
- The CLI should surface validation errors, missing workflow errors, missing sandbox errors, branch checkout errors, clone errors, and auth errors clearly.

## Remote Deploy

Provision remote execution once per repository, AWS account, and AWS region.

```bash
adk deploy remote --profile my-aws-profile
```

Rules:

- `adk deploy remote` runs from the project root.
- `--profile` selects the AWS profile used for deployment.
- The AWS account and region come from that profile.
- v1 supports one remote deployment per repository per AWS account and region.
- The repository must have an `origin` remote.
- The deploy command prompts for a GitHub token used for fresh repository clones on ECS.
- ADK stores that repository clone token in AWS Secrets Manager.
- Agent secrets are not prompted for and are not created by ADK.
- Remote agent secrets referenced by `.adk/agents/*.ts` must already exist in AWS Secrets Manager.
- ADK builds and publishes all sandboxes under `.adk/sandbox/`.
- Remote sandbox images are published before any remote run.
- ADK registers sandboxes only.
- ADK does not pre-register workflows or agents for remote execution.
