import { BunRuntime } from "@effect/platform-bun"
import { Layer } from "effect"
import { HttpServerLayer } from "./http"

const main = Layer.launch(HttpServerLayer)

BunRuntime.runMain(main)
