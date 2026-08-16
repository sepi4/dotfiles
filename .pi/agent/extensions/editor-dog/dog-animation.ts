import { visibleWidth } from "@earendil-works/pi-tui";

export const RUN_FRAME_TAIL_WAVING_RIGHT = [
	"  /\\_/\\",
	"~( o.o )",
	"  v v",
];
export const RUN_FRAME_TAIL_WAVING_LEFT = [
	" /\\_/\\  ",
	"( o.o )~",
	"   v v  ",
];
export const RUN_FRAME_TAIL_RAISED_RIGHT = [
	"  /\\_/\\",
	"^( o.o )",
	"  u u",
];
export const RUN_FRAME_TAIL_RAISED_LEFT = [
	" /\\_/\\  ",
	"( o.o )^",
	"   u u  ",
];

export const SITTING_FRAME_RESTING_RIGHT = [
	"  /\\_/\\",
	" ( o.o )",
	"  > ^ <",
];
export const SITTING_FRAME_RESTING_LEFT = [
	"  /\\_/\\",
	" ( o.o )",
	"  > ^ < ",
];
export const SITTING_FRAME_TAIL_WAGGING_RIGHT = [
	"   /\\_/\\",
	" ~( o.o )",
	"  > ^ <",
];
export const SITTING_FRAME_TAIL_WAGGING_LEFT = [
	" /\\_/\\  ",
	"( o.o )~",
	"  > ^ < ",
];
export const SITTING_FRAME_EYES_CLOSED_RIGHT = [
	"  /\\_/\\",
	" ( -.- )",
	"  > ^ <",
];
export const SITTING_FRAME_EYES_CLOSED_LEFT = [
	"  /\\_/\\",
	" ( -.- )",
	"  > ^ < ",
];

const allFrames = [
	...RUN_FRAME_TAIL_WAVING_RIGHT,
	...RUN_FRAME_TAIL_WAVING_LEFT,
	...RUN_FRAME_TAIL_RAISED_RIGHT,
	...RUN_FRAME_TAIL_RAISED_LEFT,
	...SITTING_FRAME_RESTING_RIGHT,
	...SITTING_FRAME_RESTING_LEFT,
	...SITTING_FRAME_TAIL_WAGGING_RIGHT,
	...SITTING_FRAME_TAIL_WAGGING_LEFT,
	...SITTING_FRAME_EYES_CLOSED_RIGHT,
	...SITTING_FRAME_EYES_CLOSED_LEFT,
];

export const DOG_WIDTH = Math.max(
	...allFrames.map((row) => visibleWidth(row)),
);

export function padRowsToDogWidth(rows: string[]): string[] {
	return rows.map((row) => {
		const padding = Math.max(0, DOG_WIDTH - visibleWidth(row));
		return row + " ".repeat(padding);
	});
}
