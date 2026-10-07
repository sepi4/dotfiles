import { Plugin } from "@opencode/plugin";
import { CodexQuota } from "./rpc.ts";
import { fetchQuota, validAccountId } from "./quota.ts";

export default Plugin.define({
  id: "local.codex-quota",
  async setup(ctx) {
    const shutdown = new AbortController();
    await ctx.rpc.register(CodexQuota, {
      refresh: async (_input, request) => fetchQuota(async () => {
        const connection = await ctx.integration.connection.active("openai");
        if (!connection) return undefined;
        const credential = await ctx.integration.connection.resolve(connection);
        if (credential?.type !== "oauth" || ![
          "chatgpt-token-sharing", "chatgpt-browser", "chatgpt-headless",
        ].includes(credential.methodID)) return undefined;
        const id = credential.metadata?.accountId;
        return { access: credential.access, accountId: validAccountId(id) ? id : undefined };
      }, AbortSignal.any([shutdown.signal, request.signal])),
    });
    return () => shutdown.abort();
  },
});
