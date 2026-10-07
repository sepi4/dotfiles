import { test } from "node:test";
import assert from "node:assert/strict";
import { accountIdFromToken, ENDPOINT, fetchQuota, formatQuota } from "./quota.ts";

const token = (id = "account-123") => `x.${Buffer.from(JSON.stringify({
  "https://api.openai.com/auth": { chatgpt_account_id: id },
})).toString("base64url")}.x`;
const window = (seconds: number, used: number, reset = {}) => ({
  limit_window_seconds: seconds, used_percent: used, ...reset,
});
const data = (primary: unknown, secondary?: unknown) => ({ rate_limit: {
  primary_window: primary, secondary_window: secondary,
} });
const auth = async () => ({ access: token() });

test("window durations identify quotas regardless of primary/secondary ordering", () => {
  assert.deepEqual(formatQuota(data(window(604800, 18.2), window(18000, 29.6))), {
    fiveHour: "70% left", weekly: "82% left", message: "",
  });
});
test("missing, invalid, zero, and exhausted quotas stay distinct", () => {
  assert.equal(formatQuota(null).message, "Quotas unavailable");
  assert.equal(formatQuota(data(window(18000, 0), window(604800, 101))).fiveHour, "100% left");
  assert.equal(formatQuota(data(window(18000, 0), window(604800, 101))).weekly, "—");
  assert.equal(formatQuota(data(window(18000, 100))).fiveHour, "0% left");
  for (const used of [-1, NaN, Infinity, "50"]) {
    assert.equal(formatQuota(data({ limit_window_seconds: 18000, used_percent: used })).message, "Quotas unavailable");
  }
});
test("reset timestamps take precedence and use compact day/hour/minute durations", () => {
  const now = 1_800_000_000_000;
  assert.deepEqual(formatQuota(data(
    window(18000, 6, { reset_at: now / 1000 + 2 * 3600 + 34 * 60, reset_after_seconds: 1 }),
    window(604800, 30, { reset_at: now / 1000 + 3 * 86400 + 5 * 3600 }),
  ), now), { fiveHour: "94% left (2h 34m)", weekly: "70% left (3d 5h)", message: "" });
});
test("reset fallback, rounding, expiry, and malformed values", () => {
  const format = (reset: object) => formatQuota(data(window(18000, 0, reset)), 1000).fiveHour;
  assert.equal(format({ reset_after_seconds: 61 }), "100% left (2m)");
  assert.equal(format({ reset_after_seconds: 3600 }), "100% left (1h)");
  assert.equal(format({ reset_at: 0 }), "100% left (0m)");
  assert.equal(format({ reset_at: NaN, reset_after_seconds: 1 }), "100% left (1m)");
  for (const reset of [{}, { reset_at: "123" }, { reset_at: Infinity },
    { reset_after_seconds: -1 }, { reset_after_seconds: NaN }]) {
    assert.equal(format(reset), "100% left");
  }
});
test("account IDs reject malformed JWTs and header injection", () => {
  assert.equal(accountIdFromToken(token()), "account-123");
  assert.equal(accountIdFromToken(token("bad\r\nheader")), undefined);
  assert.equal(accountIdFromToken("invalid"), undefined);
});
test("requests only the official endpoint with redirects blocked", async () => {
  const fetcher: typeof fetch = async (url, options) => {
    assert.equal(url, ENDPOINT);
    assert.equal(options?.redirect, "error");
    assert.equal(options?.method, "GET");
    const headers = new Headers(options?.headers);
    assert.equal(headers.get("Authorization"), `Bearer ${token()}`);
    assert.equal(headers.get("ChatGPT-Account-Id"), "account-123");
    assert.ok(options?.signal);
    return Response.json(data(window(18000, 30)));
  };
  assert.equal((await fetchQuota(auth, undefined, fetcher)).fiveHour, "70% left");
});
test("missing auth and invalid account IDs never make a network request", async () => {
  const fetcher: typeof fetch = async () => { throw new Error("unexpected request"); };
  assert.equal((await fetchQuota(async () => undefined, undefined, fetcher)).message, "Subscription login required");
  assert.equal((await fetchQuota(async () => ({ access: token("bad\r\n") }), undefined, fetcher)).message, "Account ID unavailable");
});
test("metadata account ID can select the active organization", async () => {
  const fetcher: typeof fetch = async (_url, options) => {
    assert.equal(new Headers(options?.headers).get("ChatGPT-Account-Id"), "organization-456");
    return Response.json(data(window(18000, 10)));
  };
  assert.equal((await fetchQuota(async () => ({ access: token(), accountId: "organization-456" }), undefined, fetcher)).fiveHour, "90% left");
});
test("HTTP errors and exceptions never expose tokens or response bodies", async () => {
  for (const status of [401, 403, 429, 500]) {
    const result = await fetchQuota(auth, undefined, async () => new Response(token(), { status }));
    assert.equal(result.message, status === 401 || status === 403 ? "Please log in again" : `HTTP ${status}`);
    assert.ok(!JSON.stringify(result).includes(token()));
  }
  const result = await fetchQuota(auth, undefined, async () => { throw new Error(`secret ${token()}`); });
  assert.equal(result.message, "Refresh failed");
  assert.ok(!JSON.stringify(result).includes(token()));
  assert.equal((await fetchQuota(auth, undefined, async () => new Response("invalid json"))).message, "Refresh failed");
});
test("cancellation stops credential resolution and prevents network requests", async () => {
  const controller = new AbortController();
  let requests = 0;
  const result = fetchQuota(() => new Promise(() => {}), controller.signal, async () => {
    requests++;
    return Response.json({});
  });
  controller.abort();
  assert.equal((await result).message, "Refresh failed");
  assert.equal(requests, 0);
});
test("cancellation reaches an in-flight fetch", async () => {
  const controller = new AbortController();
  const result = fetchQuota(auth, controller.signal, async (_url, options) => {
    controller.abort();
    assert.equal(options?.signal?.aborted, true);
    throw new Error("aborted");
  });
  assert.equal((await result).message, "Refresh failed");
});
