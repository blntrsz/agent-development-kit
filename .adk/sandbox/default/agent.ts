import { Agent } from "@mariozechner/pi-agent-core";
import { getModel } from "@mariozechner/pi-ai";

export default new Agent({
  initialState: {
    systemPrompt: "You are a helpful assistant.",
    model: getModel("opencode-go", "kimi-k2.5"),
  },
});

