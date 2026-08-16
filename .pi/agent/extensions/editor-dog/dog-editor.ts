import {
	CustomEditor,
	type KeybindingsManager,
} from "@earendil-works/pi-coding-agent";
import type { EditorTheme, TUI } from "@earendil-works/pi-tui";
import {
	DOG_WIDTH,
	padRowsToDogWidth,
	RUN_FRAME_TAIL_RAISED_LEFT,
	RUN_FRAME_TAIL_RAISED_RIGHT,
	RUN_FRAME_TAIL_WAVING_LEFT,
	RUN_FRAME_TAIL_WAVING_RIGHT,
	SITTING_FRAME_EYES_CLOSED_LEFT,
	SITTING_FRAME_EYES_CLOSED_RIGHT,
	SITTING_FRAME_RESTING_LEFT,
	SITTING_FRAME_RESTING_RIGHT,
	SITTING_FRAME_TAIL_WAGGING_LEFT,
	SITTING_FRAME_TAIL_WAGGING_RIGHT,
} from "./dog-animation";

const RUN_INTERVAL = 90;
const SIT_INTERVAL = 700;
const RUN_CYCLE_LENGTH_FRAMES = 2;
const BLINK_INTERVAL_FRAMES = 10;
const SITTING_CYCLE_LENGTH_FRAMES = 4;
const SITTING_RESTING_FRAME_COUNT = 3;
const DIRECTION_CHANGE_PROBABILITY = 0.07;
const EDGE_MARGIN = 1;

enum Phase {
	Run = "run",
	Sitting = "sitting",
}

enum Direction {
	Left = -1,
	Right = 1,
}

export class DogEditor extends CustomEditor {
	private position = 0;
	private direction = Math.random() < 0.5 ? Direction.Right : Direction.Left;
	private frame = 0;
	private phase: Phase = Phase.Sitting;
	private timer: ReturnType<typeof setInterval> | undefined;
	private disposed = false;
	private maxPosition = 0;

	public constructor(
		tui: TUI,
		theme: EditorTheme,
		keybindings: KeybindingsManager,
	) {
		super(tui, theme, keybindings);

		this.restartTimer(SIT_INTERVAL);
	}

	public startRunning(): void {
		if (this.disposed || this.phase === Phase.Run) return;

		this.phase = Phase.Run;
		this.restartTimer(RUN_INTERVAL);
		this.tui.requestRender();
	}

	public sitDown(): void {
		if (this.disposed || this.phase === Phase.Sitting) return;

		this.phase = Phase.Sitting;
		this.restartTimer(SIT_INTERVAL);
		this.tui.requestRender();
	}

	private restartTimer(interval: number): void {
		if (this.timer) clearInterval(this.timer);
		this.timer = setInterval(() => this.tick(), interval);
	}

	private tick(): void {
		if (this.disposed) return;

		this.advanceAnimation();
		this.tui.requestRender();
	}

	private advanceAnimation(): void {
		this.frame++;
		if (this.phase === Phase.Run) {
			this.moveDog();
		} else {
			// Let the sitting dog occasionally look the other way too.
			this.maybeChangeDirection();
		}
	}

	private moveDog(): void {
		this.maybeChangeDirection();
		this.bounceAtEdges();
		this.position = this.getNextPosition();
	}

	private maybeChangeDirection(): void {
		if (Math.random() < DIRECTION_CHANGE_PROBABILITY) {
			this.direction =
				this.direction === Direction.Right
					? Direction.Left
					: Direction.Right;
		}
	}

	private bounceAtEdges(): void {
		if (
			this.direction === Direction.Right &&
			this.position >= this.maxPosition
		) {
			this.direction = Direction.Left;
		} else if (
			this.direction === Direction.Left &&
			this.position <= EDGE_MARGIN
		) {
			this.direction = Direction.Right;
		}
	}

	private getNextPosition(): number {
		const speed = this.getRandomSpeed();
		const nextPosition = this.position + this.direction * speed;

		return Math.max(
			EDGE_MARGIN,
			Math.min(this.maxPosition, nextPosition),
		);
	}

	private getRandomSpeed(): number {
		return 1 + Math.floor(Math.random() * 3);
	}

	private getCurrentFrame(): string[] {
		const isBlinkFrame = this.frame % BLINK_INTERVAL_FRAMES === 0;
		const isSittingRestingFrame =
			this.frame % SITTING_CYCLE_LENGTH_FRAMES <
			SITTING_RESTING_FRAME_COUNT;

		if (this.phase === Phase.Run) {
			const isTailWavingFrame =
				this.frame % RUN_CYCLE_LENGTH_FRAMES === 0;

			if (this.direction === Direction.Left) {
				if (isTailWavingFrame) {
					return RUN_FRAME_TAIL_WAVING_LEFT;
				}

				return RUN_FRAME_TAIL_RAISED_LEFT;
			}

			if (isTailWavingFrame) {
				return RUN_FRAME_TAIL_WAVING_RIGHT;
			}

			return RUN_FRAME_TAIL_RAISED_RIGHT;
		} else if (isBlinkFrame) {
			// Blink occasionally while sitting, independently of the tail wag.
			if (this.direction === Direction.Left) {
				return SITTING_FRAME_EYES_CLOSED_LEFT;
			}

			return SITTING_FRAME_EYES_CLOSED_RIGHT;
		} else if (isSittingRestingFrame) {
			if (this.direction === Direction.Left) {
				return SITTING_FRAME_RESTING_LEFT;
			}

			return SITTING_FRAME_RESTING_RIGHT;
		} else if (this.direction === Direction.Left) {
			return SITTING_FRAME_TAIL_WAGGING_LEFT;
		}

		return SITTING_FRAME_TAIL_WAGGING_RIGHT;
	}

	private getPaddedFrame(): string[] {
		return padRowsToDogWidth(this.getCurrentFrame());
	}

	private updatePositionLimits(contentWidth: number): boolean {
		// Keep a one-column margin on each side so the dog never touches the
		// window edges.
		this.maxPosition = Math.max(
			0,
			contentWidth - DOG_WIDTH - EDGE_MARGIN * 2,
		);
		this.position = Math.max(
			EDGE_MARGIN,
			Math.min(this.position, this.maxPosition),
		);

		return this.maxPosition >= EDGE_MARGIN + 1;
	}

	public renderDog(width: number): string[] {
		const paddingX = this.getPaddingX();
		const contentWidth = Math.max(1, width - paddingX * 2);

		if (!this.updatePositionLimits(contentWidth)) {
			return []; // terminal too narrow for the dog
		}

		// The animation is controlled only by agent lifecycle events. In
		// particular, editor focus and typing do not change the dog's phase.
		const frameRows = this.getPaddedFrame();
		return frameRows.map(
			(row) => " ".repeat(paddingX) + " ".repeat(this.position) + row,
		);
	}

	public dispose(): void {
		this.disposed = true;
		if (this.timer) {
			clearInterval(this.timer);
			this.timer = undefined;
		}
	}
}
