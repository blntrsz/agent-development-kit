import { Command } from "effect/unstable/cli";
import packageJson from "../package.json";
import { BunRuntime, BunServices } from "@effect/platform-bun";
import { runWorkspaceCommand } from "./command/workspace/run-workspace.command";
import { Effect } from "effect";

export const command = Command.make("skipper").pipe(
  Command.withSubcommands([runWorkspaceCommand]),
)

Command.run(command, {
  version: packageJson.version,
}).pipe(
  Effect.provide(BunServices.layer),
  BunRuntime.runMain,
);
