# Codex quota status for Pi

A small Pi extension that shows your remaining Codex subscription quota:

```text
5h 94% left · weekly 70% left
```

## Setup

1. Place this folder in `~/.pi/agent/extensions/codex-quota/`, with `index.ts`
   directly inside it.
2. Restart Pi or run `/reload`.
3. Log in with `/login openai-codex` and select an `openai-codex` model using
   `/model`.

No extra dependencies are needed. Requires Node.js 22.19 or newer; developed
against Pi 1.0.4.

## Usage

The status updates at startup, on model changes, and every five minutes,
including during long-running tasks. Run `/codex-quota` to refresh it manually.

Percentages show remaining quota, not working time. Missing windows show a dash.
The status is hidden when another provider is selected. Failed updates show an
error message and are retried at the next scheduled update.

To disable the extension, remove its folder and run `/reload`.

## Limitations and privacy

- Requires Codex subscription login. OpenAI API keys and native `openai` login
  are not supported.
- Shows the shared five-hour and weekly quotas, not additional model-specific
  quotas.
- Uses an undocumented OpenAI endpoint that may change.
- Gets credentials through Pi and sends them only to
  `https://chatgpt.com/backend-api/wham/usage`, without following redirects.
- Does not read files, log credentials, or change model requests or settings.
  Pi itself may refresh and store credentials as part of normal login handling.

## Tests

From this extension's folder, run:

```bash
node --experimental-strip-types --test codex-quota.test.ts
```

Tests use simulated responses, without network access or real credentials.
