import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

// No dependencies, file access, subprocesses, or persistent credential storage.
const ENDPOINT = "https://chatgpt.com/backend-api/wham/usage";
const INTERVAL_MS = 5 * 60 * 1000;
const STATUS_KEY = "local-codex-quota";

type RecordValue = Record<string, unknown>;
function record(value: unknown): RecordValue | undefined {
  return value !== null && typeof value === "object" && !Array.isArray(value)
    ? value as RecordValue : undefined;
}

export function formatQuota(data: unknown): string {
  const limits = record(record(data)?.rate_limit);
  const windows = [limits?.primary_window, limits?.secondary_window];
  const values = new Map<number, number>();
  for (const candidate of windows) {
    const window = record(candidate);
    const seconds = window?.limit_window_seconds;
    const used = window?.used_percent;
    if (typeof seconds === "number" && typeof used === "number" &&
        Number.isFinite(used) && used >= 0 && used <= 100) {
      values.set(seconds, Math.round(100 - used));
    }
  }
  const fiveHour = values.get(5 * 60 * 60);
  const weekly = values.get(7 * 24 * 60 * 60);
  if (fiveHour === undefined && weekly === undefined) {
    return "codex: quotas unavailable";
  }
  return `5h ${fiveHour === undefined ? "—" : `${fiveHour}% left`} · weekly ${weekly === undefined ? "—" : `${weekly}% left`}`;
}

export function accountIdFromToken(token: string): string | undefined {
  try {
    const payload = record(JSON.parse(Buffer.from(token.split(".")[1], "base64url").toString("utf8")));
    const id = record(payload?.["https://api.openai.com/auth"])?.chatgpt_account_id;
    return typeof id === "string" && /^[a-zA-Z0-9_-]{1,200}$/.test(id) ? id : undefined;
  } catch {
    return undefined;
  }
}

function officialUrl(value: string): boolean {
  try {
    const url = new URL(value);
    return url.origin === "https://chatgpt.com" && !url.username && !url.password;
  } catch {
    return false;
  }
}

export default function (pi: ExtensionAPI) {
  let timer: ReturnType<typeof setInterval> | undefined;
  let context: ExtensionContext | undefined;
  let controller: AbortController | undefined;
  let generation = 0;

  function cancel() {
    generation++;
    controller?.abort();
    controller = undefined;
  }

  async function refresh(ctx: ExtensionContext) {
    if (ctx.mode !== "tui" || controller) return;
    if (ctx.model?.provider !== "openai-codex") {
      ctx.ui.setStatus(STATUS_KEY, undefined);
      return;
    }
    const model = ctx.model;
    const request = new AbortController();
    controller = request;
    const currentGeneration = generation;
    const timeout = setTimeout(() => request.abort(), 10_000);
    const show = (text: string) => {
      if (currentGeneration === generation && !request.signal.aborted) {
        ctx.ui.setStatus(STATUS_KEY, text);
      }
    };
    show("codex: refreshing…");
    try {
      if (!officialUrl(model.baseUrl) || !ctx.modelRegistry.isUsingOAuth(model)) {
        show("codex: official subscription login required");
        return;
      }
      const auth = await ctx.modelRegistry.getApiKeyAndHeaders(model);
      if (request.signal.aborted || currentGeneration !== generation) return;
      if (!auth.ok || !auth.apiKey || (auth.baseUrl && !officialUrl(auth.baseUrl))) {
        show("codex: authentication unavailable");
        return;
      }
      const accountId = accountIdFromToken(auth.apiKey);
      if (!accountId) {
        show("codex: account ID unavailable");
        return;
      }
      const response = await fetch(ENDPOINT, {
        method: "GET",
        // Never follow redirects with subscription credentials.
        redirect: "error",
        signal: request.signal,
        headers: {
          Authorization: `Bearer ${auth.apiKey}`,
          "ChatGPT-Account-Id": accountId,
          Accept: "application/json",
        },
      });
      if (!response.ok) {
        await response.body?.cancel();
        show(response.status === 401 || response.status === 403
          ? "codex: please log in again" : `codex: HTTP ${response.status}`);
        return;
      }
      show(formatQuota(await response.json()));
    } catch {
      // Do not print errors: they may include credentials or response bodies.
      if (currentGeneration === generation) {
        ctx.ui.setStatus(STATUS_KEY, "codex: refresh failed");
      }
    } finally {
      clearTimeout(timeout);
      if (controller === request) controller = undefined;
    }
  }

  pi.on("session_start", (_event, ctx) => {
    cancel();
    if (timer) clearInterval(timer);
    context = ctx;
    if (ctx.mode !== "tui") return;
    void refresh(ctx);
    timer = setInterval(() => { if (context) void refresh(context); }, INTERVAL_MS);
    timer.unref();
  });
  pi.on("model_select", (_event, ctx) => {
    cancel();
    context = ctx;
    void refresh(ctx);
  });
  pi.registerCommand("codex-quota", {
    description: "Refresh remaining Codex subscription quota",
    handler: async (_args, ctx) => { await refresh(ctx); },
  });
  pi.on("session_shutdown", () => {
    if (timer) clearInterval(timer);
    timer = undefined;
    context = undefined;
    cancel();
  });
}
