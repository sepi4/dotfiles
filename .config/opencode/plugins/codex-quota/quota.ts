// Credentials stay in memory on the server. No files, subprocesses, or logging.
export const ENDPOINT = "https://chatgpt.com/backend-api/wham/usage";
export const INTERVAL_MS = 5 * 60 * 1000;
type RecordValue = Record<string, unknown>;
export type Quota = { fiveHour: string; weekly: string; message: string };

function record(value: unknown): RecordValue | undefined {
  return value !== null && typeof value === "object" && !Array.isArray(value)
    ? value as RecordValue : undefined;
}

function resetCountdown(window: RecordValue, now: number): string {
  const resetAt = window.reset_at;
  const resetAfter = window.reset_after_seconds;
  const seconds = typeof resetAt === "number" && Number.isFinite(resetAt) && resetAt >= 0
    ? resetAt - now / 1000
    : typeof resetAfter === "number" && Number.isFinite(resetAfter) && resetAfter >= 0
      ? resetAfter : undefined;
  if (seconds === undefined) return "";
  const minutes = Math.ceil(Math.max(0, seconds) / 60);
  const days = Math.floor(minutes / 1440);
  const hours = Math.floor(minutes % 1440 / 60);
  const parts = [days ? `${days}d` : "", hours ? `${hours}h` : "",
    minutes % 60 || minutes === 0 ? `${minutes % 60}m` : ""].filter(Boolean);
  return ` (${parts.join(" ")})`;
}

export function formatQuota(data: unknown, now = Date.now()): Quota {
  const limits = record(record(data)?.rate_limit);
  const values = new Map<number, string>();
  for (const candidate of [limits?.primary_window, limits?.secondary_window]) {
    const window = record(candidate);
    const seconds = window?.limit_window_seconds;
    const used = window?.used_percent;
    if (window && typeof seconds === "number" && typeof used === "number" &&
        Number.isFinite(used) && used >= 0 && used <= 100) {
      values.set(seconds, `${Math.round(100 - used)}% left${resetCountdown(window, now)}`);
    }
  }
  const fiveHour = values.get(18000);
  const weekly = values.get(604800);
  return {
    fiveHour: fiveHour ?? "—",
    weekly: weekly ?? "—",
    message: fiveHour === undefined && weekly === undefined ? "Quotas unavailable" : "",
  };
}

export function validAccountId(value: unknown): value is string {
  return typeof value === "string" && /^[a-zA-Z0-9_-]{1,200}$/.test(value);
}

export function accountIdFromToken(token: string): string | undefined {
  try {
    const payload = record(JSON.parse(Buffer.from(token.split(".")[1], "base64url").toString("utf8")));
    const id = record(payload?.["https://api.openai.com/auth"])?.chatgpt_account_id;
    return validAccountId(id) ? id : undefined;
  } catch {
    return undefined;
  }
}

export type SubscriptionAuth = { access: string; accountId?: string };
const failure = (message: string): Quota => ({ fiveHour: "—", weekly: "—", message });

export async function fetchQuota(
  resolveAuth: () => Promise<SubscriptionAuth | undefined>,
  signal?: AbortSignal,
  fetcher: typeof fetch = fetch,
): Promise<Quota> {
  const bounded = AbortSignal.any([AbortSignal.timeout(10_000), ...(signal ? [signal] : [])]);
  try {
    // Bound credential resolution too; its underlying refresh is owned by OpenCode.
    const auth = await new Promise<SubscriptionAuth | undefined>((resolve, reject) => {
      const abort = () => reject(new Error("cancelled"));
      if (bounded.aborted) return abort();
      bounded.addEventListener("abort", abort, { once: true });
      resolveAuth().then(resolve, reject).finally(() => bounded.removeEventListener("abort", abort));
    });
    bounded.throwIfAborted();
    if (!auth?.access) return failure("Subscription login required");
    const accountId = auth.accountId ?? accountIdFromToken(auth.access);
    if (!validAccountId(accountId)) return failure("Account ID unavailable");
    const response = await fetcher(ENDPOINT, {
      method: "GET",
      redirect: "error",
      signal: bounded,
      headers: {
        Authorization: `Bearer ${auth.access}`,
        "ChatGPT-Account-Id": accountId,
        Accept: "application/json",
      },
    });
    if (!response.ok) {
      await response.body?.cancel();
      return failure(response.status === 401 || response.status === 403
        ? "Please log in again" : `HTTP ${response.status}`);
    }
    return formatQuota(await response.json());
  } catch {
    // Never expose exceptions, tokens, or raw response bodies to the UI/RPC.
    return failure("Refresh failed");
  }
}
