# nvim config audit — TODO

Audit of `~/.config/nvim` against Neovim **0.11.1** and the currently-installed
(pinned) plugin versions. Line numbers refer to `init.lua` at audit time.

Status legend: `[ ]` open · `[~]` in progress · `[x]` done · `[-]` deferred

---

## A. Footguns & deprecations (safe, mechanical) — DONE ✅

- [x] **#1 Neovide scale keymaps crash in terminal** — `init.lua:741,747`
  Guarded with `(vim.g.neovide_scale_factor or 1)`. Verified the terminal
  nil-arithmetic error is gone.

- [x] **#2 `capabilities` was an undefined nil global** — resolved with #6:
  now `local capabilities = vim.lsp.protocol.make_client_capabilities()`.
  Verified no global `capabilities` leaks.

- [x] **#3 `vim.highlight.on_yank` deprecated** → `vim.hl.on_yank` (`init.lua:414`).

- [x] **#4 `vim.loop.fs_stat` deprecated** → `vim.uv.fs_stat` (`init.lua:37`).

## B. Fragility: `:Lazy update` would silently break these — DONE ✅

Installed versions are OLD: which-key is **v2** (no `.add`), nvim-lspconfig is
pre-`lsp/` (no native `vim.lsp.enable` server configs). So rather than force a
risky plugin-update cascade, the config was made **forward-compatible**.

- [x] **#5 which-key** — now uses `wk.add {}` (v3 spec) when `.add` exists, else
  falls back to `wk.register {}`. Verified the v2 fallback path is taken and
  loads clean; will auto-use `.add()` after an update to v3.

- [x] **#6 mason-lspconfig `setup_handlers`** — replaced with a direct
  per-server `lspconfig[...].setup{}` loop. mason-lspconfig is now used only for
  `ensure_installed`, so this works on installed v1 and survives an update to
  v2. Verified `lua_ls` actually attaches to a real `.lua` buffer.

## C. Productivity opportunities — DEFERRED (need user decision)

- [-] **#7 No completion engine.** nvim-cmp is commented out; only omni-completion
  (`<C-x><C-o>`) works. Options: `vim.lsp.completion.enable()` (0-plugin, built
  into 0.11, confirmed available) / `blink.cmp` / re-enable nvim-cmp.

- [-] **#8 Markdown treesitter half-installed.** `markdown.so` present but
  `markdown_inline` missing, and neither is in `ensure_installed` (`init.lua:503`).
  Add `'markdown', 'markdown_inline'` for full inline highlighting.

- [-] **#9 Overlapping bullet mappings.** `<A-b>` (`422–423`) vs `<leader>*`/`<leader>-`
  (`753–759`) do near-identical things three ways, unscoped to filetype.
  Consider consolidating + scoping to markdown.

## D. Dead / unused code — DEFERRED (cleanup only)

- [-] `lua/kickstart/plugins/autoformat.lua` & `debug.lua` — never `require`d
  (init.lua:222–223 commented). Inert. autoformat.lua also references the
  renamed `tsserver` (now `ts_ls`).
- [-] ~70 lines of commented-out nvim-cmp (`87–101`, `676–725`) and onedark
  theme (`144–156`).
- [-] `lua/custom/plugins/init.lua` returns `{}`; its importer (`init.lua:231`)
  is commented out — mechanism wired to nothing.

## Notes (no action)

- Commented-out `[d`/`]d`/hover/rename diagnostic keymaps (`404–407`) are now
  **built-in defaults in Neovim 0.11** — nothing lost by leaving them off.
- Plugins `which-key` and `mason-lspconfig` track `branch = main` in
  `lazy-lock.json`; the lockfile protects you until an explicit `:Lazy update`.
