# Codex quota

Shows remaining subscription quota and time until reset in the session sidebar:

```text
Codex quota
5h      94% left (2h 34m)
Weekly  70% left (3d 5h)
```

## Setup

Requires OpenCode V2 and a ChatGPT subscription login. Place or symlink this folder
at `~/.config/opencode/plugins/codex-quota/`, then install its dependency:

```sh
npm install --omit=dev --ignore-scripts --package-lock=false
```

Restart OpenCode, sign in through `/connect` → **OpenAI** → **Sign in with ChatGPT**,
and select an OpenAI model with `/models`.

## Usage

- Refreshes automatically every five minutes and when the model or account changes.
- Run `/codex-quota` to refresh manually.
- Only appears for OpenAI models; API-key connections are not supported.

Uses ChatGPT's undocumented usage endpoint, which may change. Quotas are shared
subscription limits, not API billing totals. Credentials are sent only to ChatGPT;
quota data is not stored persistently.

## Tests

With Node.js 22.19+:

```sh
npm test
```
