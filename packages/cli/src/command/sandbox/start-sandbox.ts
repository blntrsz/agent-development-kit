import { Console, Effect, Path, Stream } from "effect";
import { Command, Flag } from "effect/unstable/cli";
import {
  ChildProcess,
  ChildProcessSpawner
} from "effect/unstable/process";

export const startSandboxCommand = Command.make(
  "start-sandbox",
  {
    name: Flag.string("name").pipe(Flag.withDescription("Sandbox name")),
  },
  (input) =>
    Effect.gen(function*() {
      const { string, streamLines } = yield* ChildProcessSpawner.ChildProcessSpawner
      const path = yield* Path.Path

      const projectRoot = yield* ChildProcess.make`git rev-parse --show-toplevel`.pipe(string)

      const projectName = path.basename(projectRoot.trim())

      const dockerId = yield* ChildProcess.make`docker ps -q --filter ancestor=${projectName}-${input.name}`.pipe(string)

      if (dockerId.trim()) {
        yield* Console.log(`Sandbox ${input.name} is already running with container ID ${dockerId.trim()}`)
        return
      }

      yield* ChildProcess.make({
        cwd: path.join(projectRoot.trim(), ".adk", "sandbox", input.name)
      })`docker build -t ${projectName}-${input.name} .`.pipe(streamLines,
        Stream.runForEach((line) => Console.log(line))
      )

      yield* ChildProcess.make({
        cwd: path.join(projectRoot.trim(), ".adk", "sandbox", input.name)
      })`docker run -d --env-file .env ${projectName}-${input.name}`.pipe(streamLines,
        Stream.runForEach((line) => Console.log(line))
      )
    }),
).pipe(Command.withDescription("Start the sandbox environment"));

