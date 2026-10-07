import { Plugin } from "@opencode/plugin/tui";
import { createEffect, createMemo, createSignal, Show, untrack } from "solid-js";
import { CodexQuota } from "./rpc.ts";
import { INTERVAL_MS, type Quota } from "./quota.ts";

export default Plugin.define({
  id: "local.codex-quota.tui",
  setup(ctx) {
    const rpc = ctx.client.rpc(CodexQuota);
    const [quota, setQuota] = createSignal<Quota>({ fiveHour: "—", weekly: "—", message: "Refreshing…" });
    let controller: AbortController | undefined;
    let generation = 0;
    let disposed = false;
    const visible = () => ctx.ui.model.current()?.providerID === "openai";
    function cancel() {
      generation++;
      controller?.abort();
      controller = undefined;
    }
    async function refresh() {
      if (disposed || !visible() || controller) return;
      const request = new AbortController();
      controller = request;
      const current = generation;
      try {
        const result = await rpc.refresh({}, {
          location: ctx.location ?? ctx.data.location.default(),
          signal: AbortSignal.any([request.signal, AbortSignal.timeout(15_000)]),
        }) as Quota;
        if (!disposed && current === generation && !request.signal.aborted) setQuota(result);
      } catch {
        if (!disposed && current === generation && !request.signal.aborted) {
          setQuota({ fiveHour: "—", weekly: "—", message: "Refresh failed" });
        }
      } finally {
        if (controller === request) controller = undefined;
      }
    }
    // This app contribution remains mounted even when the sidebar is closed.
    const stopApp = ctx.ui.slot({
      append: "app",
      render: () => {
        const selection = createMemo(() => {
          const model = ctx.ui.model.current();
          const location = ctx.location ?? ctx.data.location.default();
          return `${location.directory}:${location.workspaceID ?? ""}:${model?.providerID}/${model?.modelID}`;
        });
        createEffect(() => {
          // Track model and location, not quota updates or variant changes.
          selection();
          cancel();
          setQuota({ fiveHour: "—", weekly: "—", message: "Refreshing…" });
          void untrack(refresh);
        });
        return null;
      },
    });
    const stopSidebar = ctx.ui.slot({
      append: "sidebar.content",
      render: () => (
        <Show when={visible()}>
          <box flexDirection="column" marginTop={1} flexShrink={0}>
            <text fg={ctx.theme.text.base}><b>Codex quota</b></text>
            <Show when={!quota().message} fallback={<text fg={ctx.theme.text.muted}>{quota().message}</text>}>
              <box flexDirection="row">
                <text fg={ctx.theme.text.base} width={8} flexShrink={0}>5h</text>
                <text fg={ctx.theme.text.base}>{quota().fiveHour}</text>
              </box>
              <box flexDirection="row">
                <text fg={ctx.theme.text.base} width={8} flexShrink={0}>Weekly</text>
                <text fg={ctx.theme.text.base}>{quota().weekly}</text>
              </box>
            </Show>
          </box>
        </Show>
      ),
    });
    ctx.keymap.layer(() => ({
      mode: "global",
      commands: [{
        id: "local.codex-quota.refresh",
        title: "Refresh Codex quota",
        group: "Codex",
        palette: true,
        slash: { name: "codex-quota" },
        run: async () => {
          if (!visible()) {
            ctx.ui.toast.show({ message: "Select an OpenAI subscription model first", variant: "info" });
            return;
          }
          cancel();
          await refresh();
        },
      }],
    }));
    const stopCredentials = ctx.data.on("credential.switched", () => {
      cancel();
      setQuota({ fiveHour: "—", weekly: "—", message: "Refreshing…" });
      void refresh();
    });
    const timer = setInterval(() => { void refresh(); }, INTERVAL_MS);
    timer.unref();
    return () => {
      disposed = true;
      cancel();
      clearInterval(timer);
      stopCredentials();
      stopSidebar();
      stopApp();
    };
  },
});
