import { Rpc } from "@opencode/plugin/rpc";

export const CodexQuota = Rpc.define({
  id: "local.codex-quota",
  methods: {
    refresh: {
      input: { type: "object", additionalProperties: false },
      output: {
        type: "object",
        properties: {
          fiveHour: { type: "string" },
          weekly: { type: "string" },
          message: { type: "string" },
        },
        required: ["fiveHour", "weekly", "message"],
        additionalProperties: false,
      },
    },
  },
  events: {},
});
