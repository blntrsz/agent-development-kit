import { Effect, Path, Stream, Terminal } from "effect"
import { Command, Flag } from "effect/unstable/cli"
import {
  ChildProcess,
  ChildProcessSpawner
} from "effect/unstable/process"

export const promptSandboxCommand = Command.make(
  "prompt-sandbox",
  {
    name: Flag.string("name").pipe(Flag.withDescription("Sandbox name")),
  },
  (input) =>
    Effect.gen(function*() {
      const terminal = yield* Terminal.Terminal
      const { string, streamString } = yield* ChildProcessSpawner.ChildProcessSpawner
      const path = yield* Path.Path

      const projectRoot = yield* ChildProcess.make`git rev-parse --show-toplevel`.pipe(string)

      const projectName = path.basename(projectRoot.trim())

      const dockerId = yield* ChildProcess.make`docker ps -q --filter ancestor=${projectName}-${input.name}`.pipe(string)

      console.log(`Docker ID: ${dockerId.trim()}`)

      yield* ChildProcess.make("docker", [
        "exec",
        "-t",
        dockerId.trim(),
        "bun",
        "adk",
        "prompt-agent",
        "hello"
      ]).pipe(streamString,
        Stream.runForEach((chunk) => terminal.display(chunk))
      )
    }),
).pipe(Command.withDescription("Start the sandbox environment"))
