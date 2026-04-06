import { HttpApi as EffectHttpApi } from "effect/unstable/httpapi";
import { AgentApi } from "./agent/api";

export const HttpApi = EffectHttpApi.make("adk-http").add(AgentApi);
