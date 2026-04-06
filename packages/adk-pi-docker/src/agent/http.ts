import { Agent } from "@mariozechner/pi-agent-core"
import { Cause, Effect, Queue, Stream } from "effect"
import { HttpServerResponse } from "effect/unstable/http"
import { HttpApiBuilder } from "effect/unstable/httpapi"
import { HttpApi } from "../api"
import { AgentError } from "./error"

export const AgentApiHandlers = HttpApiBuilder.group(
  HttpApi,
  "agent",
  Effect.fnUntraced(function*(handlers) {
    return handlers.handle(
      "PromptAgent",
      Effect.fn(function*({ payload }) {
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

              void agent.prompt(payload.prompt).catch((error) => {
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

        return HttpServerResponse.stream(Stream.encodeText(stream), {
          contentType: "text/plain; charset=utf-8",
        })
      })
    )
  })
)
