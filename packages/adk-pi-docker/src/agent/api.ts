import { Schema } from "effect";
import {
  HttpApiEndpoint,
  HttpApiGroup,
  HttpApiSchema,
} from "effect/unstable/httpapi";
import { AgentError } from "./error";

export class AgentApi extends HttpApiGroup.make("agent").add(
  HttpApiEndpoint.post("PromptAgent", "/agent/prompt", {
    success: Schema.String.pipe(HttpApiSchema.asText()),
    payload: Schema.Struct({
      prompt: Schema.String,
    }),
    error: AgentError,
  })
) {}
