# Jun's NeoVim Configuration

A customized NeoVim setup based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) with personal enhancements for productivity.

## Installation

1. Clone this repository:

```bash
cd ~/.config/
git clone <<this repo>> nvim
```

2. Launch NeoVim - plugins will auto-install via lazy.nvim:

```bash
nvim
```

**Requirements:** NeoVim 0.9+ (newer than default on some Ubuntu/AWS instances)

## Key Features

### Plugin Manager
- **lazy.nvim** - Fast, modern plugin manager with lazy loading

### Language Support (LSP)
- **nvim-lspconfig** - LSP configurations
- **mason.nvim** - LSP/DAP/linter installer
- **mason-lspconfig** - Bridge between mason and lspconfig
- Currently configured: `lua_ls` (Lua Language Server)

### Syntax & Navigation
- **nvim-treesitter** - Advanced syntax highlighting and code understanding
- **telescope.nvim** - Fuzzy finder for files, buffers, grep, and more
- **telescope-fzf-native** - Native FZF sorter for better performance

### Git Integration
- **vim-fugitive** - Git commands in NeoVim
- **vim-rhubarb** - GitHub integration
- **gitsigns.nvim** - Git status in sign column with inline blame

### UI & Appearance
- **Theme:** kanagawa.nvim (dark theme inspired by Japanese art)
- **lualine.nvim** - Statusline with onedark theme
- **indent-blankline** - Indentation guides
- **which-key.nvim** - Keybinding popup helper

### Editing Enhancements
- **vim-surround** - Easily change/add/delete surrounding characters
- **Comment.nvim** - Toggle comments with `gc`
- **vim-sleuth** - Auto-detect indentation settings
- **zen-mode.nvim** - Distraction-free writing mode

### Markdown Support
- **markdown-preview.nvim** - Live markdown preview in browser
- **Custom hybrid folding** - Folds both headers (by level) AND lists/sublists (by indentation)
  - Use `za` to toggle folds on headers or list items
  - Headers fold all content until the next same/higher-level header
  - List items fold indented sublists
- Custom bullet list shortcuts

## Key Settings

### Leader Key
- Leader: `<Space>`
- Local Leader: `<Space>`

### Editor Behavior
- Line numbers enabled
- Mouse support enabled
- Clipboard synced with OS
- Undo history persisted
- Case-insensitive search (unless uppercase used)
- Shift width: 1 space
- Code folding:
  - Treesitter expressions for most files
  - Custom hybrid folding for markdown (headers by level + lists by indentation)
  - Fold level: 99 (all folds open by default)
- Word wrap: disabled by default (toggle with `<Alt-w>`)

### Font (for GUI like Neovide)
- JetBrains Mono / Fira Code, size 14

## Custom Keybindings

### General
- `<Space>` - Leader key
- `<Alt-w>` - Toggle word wrap
- `j/k` - Move by visual lines when wrapped

### Telescope (Fuzzy Finding)
- `<leader>?` - Recently opened files
- `<leader><space>` - Open buffers
- `<leader>/` - Search in current buffer
- `<leader>sf` - Search files
- `<leader>gf` - Search git files
- `<leader>sg` - Live grep
- `<leader>sG` - Live grep in git root
- `<leader>sw` - Search current word
- `<leader>sh` - Search help
- `<leader>sd` - Search diagnostics
- `<leader>sr` - Resume last search

### LSP (when attached)
- `gd` - Go to definition
- `gr` - Go to references
- `gI` - Go to implementation
- `gD` - Go to declaration
- `K` - Hover documentation
- `<C-k>` - Signature help
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code action
- `<leader>D` - Type definition
- `<leader>ds` - Document symbols
- `<leader>ws` - Workspace symbols

### Git
- `<leader>hp` - Preview git hunk
- `]c` - Next git hunk
- `[c` - Previous git hunk

### Treesitter Text Objects
- `af/if` - Around/inside function
- `ac/ic` - Around/inside class
- `aa/ia` - Around/inside parameter
- `]m/[m` - Next/previous function start
- `]]/[[` - Next/previous class start
- `<leader>a/<leader>A` - Swap parameter with next/previous

### Markdown Helpers
- `<Alt-b>` - Add bullet to current line (normal/visual)
- `<leader>-` - Prefix selected lines with " - " (visual)
- `<leader>*` - Prefix selected lines with " * " (visual)

### Neovide Scaling
- `<Cmd-=>` - Increase scale
- `<Cmd-->` - Decrease scale

### Editing & Folding
- `gc` - Toggle comment (Comment.nvim)
- `<C-space>` - Incremental selection (expand)
- `<M-space>` - Decremental selection (shrink)
- `za` - Toggle fold at cursor (works on headers and list items in markdown)
- `zR` - Open all folds
- `zM` - Close all folds

## File Structure

```
~/.config/nvim/
├── init.lua                          # Main configuration
├── lazy-lock.json                    # Plugin version lockfile
├── lua/
│   ├── kickstart/plugins/            # Optional kickstart plugins
│   │   ├── autoformat.lua
│   │   └── debug.lua
│   └── custom/plugins/               # Your custom plugins
│       └── init.lua
├── doc/                              # Documentation
├── .stylua.toml                      # Lua formatter config
└── README.md                         # This file
```

## Customization

### Adding Plugins
Edit `init.lua` and add to the `require('lazy').setup({...})` table.

### Enabling Autoformat/Debug
Uncomment lines 222-223 in `init.lua`:
```lua
require 'kickstart.plugins.autoformat',
require 'kickstart.plugins.debug',
```

### Adding Language Servers
Add to the `servers` table around line 550 in `init.lua`:
```lua
local servers = {
  lua_ls = {...},
  -- Add more here, e.g.:
  -- tsserver = {},
  -- pyright = {},
}
```

## Notes

- Completion (nvim-cmp) is currently commented out
- Diagnostic messages are disabled (keybinds commented out)
- Auto-install for treesitter parsers is disabled

## Resources

- `:help` - Built-in help
- `:Telescope help_tags` - Search help documentation
- `:checkhealth` - Verify installation health
- [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) - Original base configuration 
