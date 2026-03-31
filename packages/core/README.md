# core

`packages/core` now exposes an Effect-native sandbox slice.

Main exports:
- `Sandbox`: service tag for sandbox operations
- `DockerSandboxLayer()`: Docker-backed runtime layer
- schema-backed models from `src/sandbox/schema.ts`
- tagged errors from `src/sandbox/errors.ts`

Implementation patterns:
- operations return typed `Effect` values
- runtime wiring happens through `Layer`
- domain models use `Schema`
- Docker-owned resources use scoped cleanup patterns

Example:

```ts
import * as Effect from "effect/Effect"
import { DockerSandboxLayer, create, destroy, execute, start } from "./index.ts"

const program = Effect.gen(function*() {
  const sandbox = yield* create({
    image: "oven/bun:1",
    workingDirectory: "/workspace",
    mounts: [],
    command: ["sh", "-lc", "sleep infinity"]
  })

  yield* start(sandbox.id)
  const result = yield* execute(sandbox.id, { command: ["bun", "--version"] })
  yield* destroy(sandbox.id)

  return result
}).pipe(Effect.provide(DockerSandboxLayer()))
```

Run tests with:

```bash
bun test
```
