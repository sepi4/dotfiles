/**
 * Editor Dog 🐕 — a little dog that runs above the input editor.
 *
 * Install: put this file in `.pi/extensions/` (project) or
 * `~/.pi/agent/extensions/` (global), then run `/reload`.
 * Quick test: `pi -e ./editor-dog.ts`
 */

import {
	type ExtensionAPI,
	type KeybindingsManager,
} from "@earendil-works/pi-coding-agent";
import type { EditorTheme, TUI } from "@earendil-works/pi-tui";
import { DogEditor } from "./editor-dog/dog-editor";

let dog: DogEditor | undefined;

export default function (pi: ExtensionAPI): void {
	pi.on("session_start", (_event, ctx) => {
		ctx.ui.setEditorComponent(
			(tui: TUI, theme: EditorTheme, keybindings: KeybindingsManager) => {
				dog = new DogEditor(tui, theme, keybindings);
				return dog;
			},
		);

		ctx.ui.setWidget("editor-dog", () => ({
			render: (width: number) => dog?.renderDog(width) ?? [],
			invalidate: () => {},
		}));
	});

	pi.on("agent_start", () => {
		dog?.startRunning();
	});

	pi.on("agent_settled", () => {
		dog?.sitDown();
	});

	pi.on("session_shutdown", () => {
		dog?.dispose();
		dog = undefined;
	});
}
