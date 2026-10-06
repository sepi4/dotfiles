import { test } from "node:test";
import assert from "node:assert/strict";
import extension, { accountIdFromToken, formatQuota } from "./index.ts";

test("formatting uses window duration, not primary/secondary ordering", () => {
  assert.equal(formatQuota({ rate_limit: {
    primary_window: { limit_window_seconds: 604800, used_percent: 18.2 },
    secondary_window: { limit_window_seconds: 18000, used_percent: 29.6 },
  } }), "codex: 5h 30% | viikko 18% käytetty");
});
test("missing, invalid, and zero quotas are not confused", () => {
  assert.equal(formatQuota(null), "codex: kiintiöt eivät saatavilla");
  assert.equal(formatQuota({ rate_limit: {
    primary_window: { limit_window_seconds: 18000, used_percent: 0 },
    secondary_window: { limit_window_seconds: 604800, used_percent: 101 },
  } }), "codex: 5h 0% | viikko — käytetty");
});
test("JWT account extraction rejects malformed tokens and header injection", () => {
  const token = (id: string) => `x.${Buffer.from(JSON.stringify({
    "https://api.openai.com/auth": { chatgpt_account_id: id },
  })).toString("base64url")}.x`;
  assert.equal(accountIdFromToken(token("account-123")), "account-123");
  assert.equal(accountIdFromToken(token("bad\r\nheader")), undefined);
  assert.equal(accountIdFromToken("invalid"), undefined);
});
test("requests only the official endpoint, suppresses errors, and clears on model change", async () => {
  const handlers = new Map();
  const statuses: unknown[] = [];
  let command: any;
  extension({
    on: (name: string, handler: unknown) => handlers.set(name, handler),
    registerCommand: (_name: string, spec: unknown) => { command = spec; },
  } as any);
  const token = `x.${Buffer.from(JSON.stringify({
    "https://api.openai.com/auth": { chatgpt_account_id: "account-123" },
  })).toString("base64url")}.x`;
  const ctx: any = {
    mode: "tui",
    model: { provider: "openai-codex", baseUrl: "https://chatgpt.com/backend-api" },
    ui: { setStatus: (_key: string, text: unknown) => statuses.push(text) },
    modelRegistry: {
      isUsingOAuth: () => true,
      getApiKeyAndHeaders: async () => ({ ok: true, apiKey: token }),
    },
  };
  const originalFetch = globalThis.fetch;
  let requests = 0;
  try {
    globalThis.fetch = (async (url: string, options: any) => {
      requests++;
      assert.equal(url, "https://chatgpt.com/backend-api/wham/usage");
      assert.equal(options.redirect, "error");
      assert.equal(options.headers["ChatGPT-Account-Id"], "account-123");
      return new Response(JSON.stringify({ rate_limit: {
        primary_window: { limit_window_seconds: 18000, used_percent: 30 },
      } }));
    }) as any;
    await command.handler("", ctx);
    assert.equal(statuses.at(-1), "codex: 5h 30% | viikko — käytetty");
    ctx.model.baseUrl = "https://untrusted.example";
    await command.handler("", ctx);
    assert.equal(requests, 1);
    ctx.model.baseUrl = "https://chatgpt.com";
    globalThis.fetch = (async () => { throw new Error(`secret ${token}`); }) as any;
    await command.handler("", ctx);
    assert.equal(statuses.at(-1), "codex: päivitys epäonnistui");
    assert.ok(!JSON.stringify(statuses).includes(token));
    ctx.model.provider = "openai";
    await handlers.get("model_select")({}, ctx);
    assert.equal(statuses.at(-1), undefined);
  } finally {
    globalThis.fetch = originalFetch;
    handlers.get("session_shutdown")();
  }
});
