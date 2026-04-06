import { BunHttpServer } from "@effect/platform-bun"
import { Layer } from "effect"
import { HttpRouter } from "effect/unstable/http"
import { HttpApiBuilder } from "effect/unstable/httpapi"
import { AgentApiHandlers } from "./agent/http"
import { HttpApi } from "./api"

export const HttpApiLayer = HttpApiBuilder.layer(HttpApi).pipe(
  Layer.provide(AgentApiHandlers)
)

export const HttpServerLayer = HttpRouter.serve(HttpApiLayer).pipe(
  Layer.provide(BunHttpServer.layer({ port: 3000, idleTimeout: 120 }))
)
