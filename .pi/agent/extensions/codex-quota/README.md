# Codex quota status for Pi

Shows **remaining quota** and **time until reset**:

```text
5h 94% left (2h 34m) · weekly 70% left (3d 5h)
```

## Setup

Place this folder in `~/.pi/agent/extensions/codex-quota/`, run `/reload`,
then `/login openai-codex` and select an `openai-codex` model with `/model`.
Requires **Node.js 22.19+**, no extra dependencies.

## Usage

- **Auto-refresh every 5 minutes**, also at startup and on model changes.
- **Manual refresh:** `/codex-quota`.
- Reset times are rounded up to minutes and update on refresh.
- Hidden for other providers. Missing quotas show `—`; missing reset times are omitted.
- **Disable:** remove the folder and run `/reload`.

## Limits and privacy

**Codex subscription login required; API keys are not supported.** Shows shared
5-hour and weekly quotas, not model-specific limits. Uses an undocumented endpoint
that may change. Credentials go only to `https://chatgpt.com/backend-api/wham/usage`;
redirects are blocked. No file access or credential logging.

## Tests

Run in this folder; no network or real credentials:

```bash
node --experimental-strip-types --test codex-quota.test.ts
```
