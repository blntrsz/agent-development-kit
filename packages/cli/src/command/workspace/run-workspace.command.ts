import { Effect } from "effect";
import { Command } from "effect/unstable/cli";

export const runWorkspaceCommand = Command.make(
  "run-workspace",
  {
  },
  () =>
    Effect.gen(function*() {
      console.log("Running workspace...");
    }),
).pipe(Command.withDescription("Run the workspace"));

