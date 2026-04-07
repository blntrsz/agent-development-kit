import type { Agent } from "@mariozechner/pi-agent-core"
import { Cause, Effect, Queue, Stream, Terminal } from "effect"
import { Argument, Command } from "effect/unstable/cli"
import { AgentError } from "./error"

export const promptAgentCommand = Command.make(
  "prompt-agent",
  {
    prompt: Argument.string("prompt"),
  },
  Effect.fn(function*(input) {
    const terminal = yield* Terminal.Terminal
    const path = "/etc/adk/agent.ts"

    const agent: Agent = yield* Effect.tryPromise({
      try: () => import(path).then(m => m.default),
      catch: (error) => new AgentError({
        message: `Failed to import agent module. Create a file at ${path} that exports an agent instance as \`agent\` or default.`,
        cause: error
      }),
    })

    const stream = Stream.callback<string, AgentError>((queue) =>
      Effect.acquireRelease(
        Effect.sync(() => {
          const unsubscribe = agent.subscribe((event) => {
            if (
              event.type === "message_update" &&
              event.assistantMessageEvent.type === "text_delta"
            ) {
              Queue.offerUnsafe(queue, event.assistantMessageEvent.delta)
            }

            if (event.type === "agent_end") {
              Queue.endUnsafe(queue)
            }
          })

          void agent.prompt(input.prompt).catch((error) => {
            Queue.failCauseUnsafe(queue, Cause.fail(new AgentError({
              message: "Failed to prompt agent",
              cause: error
            })))
          })

          return unsubscribe
        }),
        (unsubscribe) => Effect.sync(() => {
          unsubscribe()
          agent.abort()
        })
      )
    )

    yield* stream.pipe(
      Stream.runForEach((chunk) => terminal.display(chunk))
    )
  })
).pipe(Command.withDescription("Prompt the agent"))
