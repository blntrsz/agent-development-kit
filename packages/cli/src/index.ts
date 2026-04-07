import { Command } from "effect/unstable/cli";
import packageJson from "../package.json";
import { BunRuntime, BunServices } from "@effect/platform-bun";
import { Effect } from "effect";
import { promptAgentCommand } from "./command/agent/prompt-agent.command";
import { startSandboxCommand } from "./command/sandbox/start-sandbox";
import { promptSandboxCommand } from "./command/sandbox/prompt-sandbox";

export const command = Command.make("skipper").pipe(
  Command.withSubcommands([promptAgentCommand, startSandboxCommand, promptSandboxCommand]),
)

Command.run(command, {
  version: packageJson.version,
}).pipe(
  Effect.tapError((error) => Effect.logError(`Error: ${error.message}`)),
  Effect.tapDefect((error) => Effect.logError(`Error: ${JSON.stringify(error)}`)),
  Effect.provide(BunServices.layer),
  BunRuntime.runMain,
);
