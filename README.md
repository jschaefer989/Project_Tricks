Fix for 'undefined global love' diagnostic
=========================================

What I changed
--------------
- Added per-file annotations at the top of `main.lua` and `Chess.lua` to tell linters/LSP that `love` is a known global:
  - `-- luacheck: globals love`
  - `---@diagnostic disable: undefined-global`
- Added a workspace-level Luacheck config `.luacheckrc` declaring `love` as a global.
- Added a `.vscode/settings.json` with `"Lua.diagnostics.globals": ["love"]` so the Lua language server recognizes `love`.

Why
---
LÖVE provides the global `love` table at runtime. Static linters and language servers (luacheck / sumneko Lua) report `undefined global 'love'` when they don't know about LÖVE. The changes tell those tools that `love` is intentionally global, which removes the false-positive diagnostics.

Notes and next steps
--------------------
- If you still see the diagnostic in your editor, reload the window or restart the Lua language server so it picks up the new workspace settings.
- There are remaining diagnostics about duplicate `love.load` / `love.draw` / `love.mousepressed` (one per file). That's because multiple files define the same `love` callbacks. It's valid at runtime if you intend one file to be the entry, but the language server flags duplicates. To fix that cleanly, consider consolidating initializations into a single `love.*` entrypoint that requires other modules (recommended). I can do that refactor if you want.
