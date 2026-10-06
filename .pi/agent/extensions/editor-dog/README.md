# Editor Dog for Pi

A small animated dog above the input editor. It runs while the agent is working
and sits down when the agent settles.

## Setup

1. Place this entire folder in `~/.pi/agent/extensions/editor-dog/`, or in
   `.pi/extensions/editor-dog/` for a single project.
2. Remove any old `editor-dog.ts` entry point from the extensions directory to
   avoid loading the extension twice.
3. Restart Pi or run `/reload`.

Pi automatically loads `index.ts`. Keep `dog-editor.ts` and `dog-animation.ts`
in the same folder. No extra dependencies are needed.

To try it from the dotfiles root without automatically loaded extensions:

```bash
pi -ne -e ./.pi/agent/extensions/editor-dog/index.ts
```

To disable it, remove its folder and run `/reload`.
