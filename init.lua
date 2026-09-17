--[[

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/


  And then you can explore or search through `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
-- Forward declaration.
-- Defined in the markdown hashtag section further down, but referenced by zen-mode's on_open hook inside the plugin spec below.
local sync_hashtag_match

require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim.
      -- Mason v2 lives under the mason-org account; the old williamboman/* paths still redirect but are no longer canonical.
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      --{ 'j-hui/fidget.nvim', opts = {} },
    },
  },

  -- Lua language support for editing Neovim config itself.
  -- Replaces neodev.nvim, which its author archived in favour of this.
  { 'folke/lazydev.nvim', ft = 'lua', opts = {} },

  -- Added by Jun
  'tpope/vim-surround',

  -- {
  --   -- Autocompletion
  --   'hrsh7th/nvim-cmp',
  --   dependencies = {
  --     -- Snippet Engine & its associated nvim-cmp source
  --     'L3MON4D3/LuaSnip',
  --     'saadparwaiz1/cmp_luasnip',
  --
  --     -- Adds LSP completion capabilities
  --     'hrsh7th/cmp-nvim-lsp',
  --
  --     -- Adds a number of user-friendly snippets
  --     'rafamadriz/friendly-snippets',
  --   },
  -- },

  -- Useful plugin to show you pending keybinds.
  -- Icons are off because they need a Nerd Font plus an icon-provider plugin, and render as tofu without one.
  {
    'folke/which-key.nvim',
    opts = {
      icons = { mappings = false },
    },
  },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },

  -- {
  --   -- Theme inspired by Atom
  --   'navarasu/onedark.nvim',
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme 'onedark'
  --   end,
  -- },

  {
    -- JUN
    -- Theme inspired by Atom
    --'navarasu/onedark.nvim',
    'rebelot/kanagawa.nvim',
    priority = 1000,
    lazy = false,
    -- The colorscheme is deliberately not set here.
    -- Which of kanagawa and glamour loads is decided in the colorscheme section further down, from the remembered choice.
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        theme = 'auto',  -- Auto-detect from colorscheme (kanagawa)
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },

  -- NOTE: "gc"/"gcc" commenting used to come from numToStr/Comment.nvim.
  -- Neovim ships it built in since 0.10, so the plugin was removed and the keymaps are unchanged.

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code.
    -- The `main` branch is the maintained rewrite; `master` is frozen and its queries no longer match the grammars Neovim 0.12 bundles.
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },

  -- install without yarn or npm
 {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
 },

 {
  "folke/zen-mode.nvim",
    opts = {
      -- The zen window is a second window onto the same buffer, and matchadd() is window-local.
      -- WinEnter should already cover this, but the hook is cheap insurance against the float ever being opened with autocmds suppressed.
      on_open = function()
        sync_hashtag_match()
      end,
    },
  }


}, {
  -- No plugin in this config is a luarocks package, and without this lazy.nvim
  -- reports a missing hererocks/luarocks install as a health error.
  rocks = { enabled = false },
}) -- done lazy setup call

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Remote-plugin providers.
-- Nothing in this config uses them, so turn them off rather than let :checkhealth keep reporting them as missing.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Output of `:!cmd` is tagged StderrMsg or StdoutMsg by stream, and StderrMsg links to ErrorMsg by default.
-- Git reports routine progress on stderr -- "To <remote>" and the ref update line after a successful push -- so a push that worked fine renders entirely in red.
-- Match plain message text instead; a command that actually failed still says so in its own output.
-- Re-applied on ColorScheme because loading a colorscheme resets highlight groups.
local function unred_stderr()
  vim.api.nvim_set_hl(0, 'StderrMsg', {})
end

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('JunStderrMsg', { clear = true }),
  callback = unred_stderr,
})

unred_stderr()

-- ============================================================================
-- Colorscheme
-- ============================================================================
-- Two themes are kept side by side: kanagawa, and glamour in colors/glamour.lua,
-- ported from the VS Code theme in ~/git/int/glamour-dark.
-- The choice is remembered in the state directory rather than in this file, since
-- it is a per-machine preference rather than part of the configuration.
local themes = { 'kanagawa', 'glamour' }
local theme_state = vim.fn.stdpath 'state' .. '/colorscheme.txt'

local function remembered_theme()
  local ok, saved = pcall(vim.fn.readfile, theme_state)
  if ok and saved and saved[1] and vim.tbl_contains(themes, saved[1]) then
    return saved[1]
  end
  return themes[1]
end

-- `remember` is false on startup so that merely opening Neovim never rewrites
-- the file, and true when the choice is an explicit one.
local function set_theme(name, remember)
  if not pcall(vim.cmd.colorscheme, name) then
    vim.notify('No colorscheme named ' .. name, vim.log.levels.WARN)
    return false
  end
  if remember then
    pcall(vim.fn.writefile, { name }, theme_state)
  end
  return true
end

set_theme(remembered_theme(), false)

vim.api.nvim_create_user_command('Theme', function(opts)
  if opts.args == '' then
    print(vim.g.colors_name)
  else
    set_theme(opts.args, true)
  end
end, {
  nargs = '?',
  complete = function()
    return themes
  end,
  desc = 'Show the current colorscheme, or switch to one and remember it',
})

vim.keymap.set('n', '<leader>ut', function()
  local current = vim.g.colors_name
  local next_theme = themes[1]
  for i, name in ipairs(themes) do
    if name == current then
      next_theme = themes[i % #themes + 1]
      break
    end
  end
  if set_theme(next_theme, true) then
    vim.notify('colorscheme: ' .. next_theme)
  end
end, { desc = '[U]I: cycle [t]heme' })

-- ============================================================================
-- Folding  (added/reworked by Jun)
-- ============================================================================
-- Start every window fully unfolded; folds are opt-in via za/zc/zM.
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

-- Default for code: Treesitter structural folding (functions, blocks, ...).
-- This is Neovim's own fold expression; `nvim_treesitter#foldexpr()` belonged to the plugin's frozen master branch and no longer exists.
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- Start Treesitter per buffer, and fall back to plain indent-based folding for filetypes that have no parser (plain text, some config formats, ...).
-- The `main` branch of nvim-treesitter starts nothing on its own, so highlighting and indent are turned on here.
-- Indent width for the fallback comes from the buffer's shiftwidth, which vim-sleuth auto-detects per file.
-- Markdown is excluded from the fallback because it has its own fold expression below.
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match) or args.match
    if pcall(vim.treesitter.start, args.buf, lang) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    elseif args.match ~= 'markdown' then
      vim.opt_local.foldmethod = 'indent'
    end
  end,
})

-- ----------------------------------------------------------------------------
-- Markdown folding: headings nest by '#' depth, lists/nested lists nest by
-- indentation, and list items fold *inside* their enclosing heading. Fenced
-- code blocks are skipped so that '#' comments inside code aren't mistaken for
-- headings. Fold levels for the whole buffer are computed once per change and
-- cached (keyed by changedtick) so this stays O(n), not O(n^2).
-- ----------------------------------------------------------------------------
local md_fold_cache = {}

local function compute_markdown_fold_levels(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local levels = {}
  local in_fence = false
  local base = 0 -- fold level of the current enclosing heading (0 = none)
  for idx, line in ipairs(lines) do
    if line:match('^%s*```') or line:match('^%s*~~~') then
      -- Fence delimiter: stays in the current fold, then flips fence state.
      levels[idx] = base
      in_fence = not in_fence
    elseif in_fence then
      -- Inside a code block: keep flat, don't parse headings/lists.
      levels[idx] = base
    else
      local hashes = line:match('^(#+)%s')
      if hashes then
        base = #hashes
        levels[idx] = '>' .. #hashes -- start a new fold at this heading level
      elseif line:match('^%s*$') then
        levels[idx] = '=' -- blank lines inherit, so folds don't break on them
      else
        local indent = (line:match('^(%s*)') or ''):gsub('\t', '  ')
        local is_list = line:match('^%s*[-*+]%s') or line:match('^%s*%d+[.)]%s')
        if is_list or #indent > 0 then
          -- One extra fold level per 2 columns of indent, nested under `base`.
          levels[idx] = base + math.floor(#indent / 2) + 1
        else
          levels[idx] = base -- flush-left paragraph text sits at heading level
        end
      end
    end
  end
  return levels
end

function MarkdownFoldExpr(lnum)
  local bufnr = vim.api.nvim_get_current_buf()
  local tick = vim.api.nvim_buf_get_changedtick(bufnr)
  local cache = md_fold_cache[bufnr]
  if not cache or cache.tick ~= tick then
    cache = { tick = tick, levels = compute_markdown_fold_levels(bufnr) }
    md_fold_cache[bufnr] = cache
  end
  return cache.levels[lnum] or '0'
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr = 'v:lua.MarkdownFoldExpr(v:lnum)'
  end,
})

-- Drop cached fold levels when a buffer is wiped out.
vim.api.nvim_create_autocmd('BufWipeout', {
  callback = function(args)
    md_fold_cache[args.buf] = nil
  end,
})

-- ----------------------------------------------------------------------------
-- Markdown hashtags: a '#' followed directly by a word, like #project or #todo/next.
-- The markdown parser has no node for these (they are ordinary paragraph text), so a regex match is used instead of a treesitter query.
-- The '#' must be at the start of the line or after whitespace, which keeps `C#` and `a#b` out, and it must be followed immediately by a word character, which keeps `# Heading` out.
-- matchadd() is window-local and outlives the buffer shown in the window, so this both adds the match for markdown and removes it again when the window moves on to something else.
-- It has to run on WinEnter as well as FileType and BufWinEnter: BufWinEnter only fires when a buffer goes from hidden to displayed, not when a buffer that is already on screen is shown in a second window, which is exactly what :split and zen-mode do.
-- The MarkdownHashtag group is defined by colors/glamour.lua; for any other colorscheme it falls back to Special.
-- ----------------------------------------------------------------------------
local hashtag_pattern = [[\v(^|\s)\zs#[[:alnum:]_][[:alnum:]_/-]*>]]

-- Bring the current window's match in line with the filetype of the buffer it shows.
-- Declared as a local near the top of this file so that zen-mode's on_open hook can call it.
sync_hashtag_match = function()
  local is_markdown = vim.bo.filetype == 'markdown'
  local id = vim.w.markdown_hashtag_match
  if is_markdown and not id then
    vim.w.markdown_hashtag_match = vim.fn.matchadd('MarkdownHashtag', hashtag_pattern)
  elseif not is_markdown and id then
    pcall(vim.fn.matchdelete, id)
    vim.w.markdown_hashtag_match = nil
  end
end

vim.api.nvim_create_autocmd({ 'FileType', 'BufWinEnter', 'WinEnter' }, {
  group = vim.api.nvim_create_augroup('JunMarkdownHashtag', { clear = true }),
  callback = sync_hashtag_match,
})

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('JunMarkdownHashtagHl', { clear = true }),
  callback = function()
    vim.api.nvim_set_hl(0, 'MarkdownHashtag', { default = true, link = 'Special' })
  end,
})




-- [[ Basic Keymaps ]]



-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
--
-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


-- Maps Alt-b in normal and visual mode to add bullets to lines
vim.keymap.set('n', '<A-b>', ':s/^\\(\\s*\\)\\zs/\\* /<CR>:noh<CR>', { silent = true })
vim.keymap.set('v', '<A-b>', ':s/^\\(\\s*\\)\\zs/\\* /<CR>:noh<CR>', { silent = true })

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == "" then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    print("Not a git repository. Searching on current working directory")
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep({
      search_dirs = {git_root},
    })
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`.
-- On the `main` branch this module only installs parsers; highlighting, indent and folds are switched on by the FileType autocmd in the folding section above.
-- Neovim bundles parsers for c, lua, markdown, query, vim and vimdoc, so the rest are fetched here.
local ts_langs = {
  'bash',
  'c',
  'cpp',
  'go',
  'javascript',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'rust',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
}

-- Only fetch what is actually missing.
-- `install()` is not a no-op for already-installed parsers, so calling it unconditionally would re-download them on every startup.
local installed = require('nvim-treesitter.config').get_installed 'parsers'
local missing = vim.tbl_filter(function(lang)
  return not vim.tbl_contains(installed, lang)
end, ts_langs)

if #missing > 0 then
  require('nvim-treesitter').install(missing)
end

-- NOTE: the `<c-space>` incremental-selection maps that used to live here are gone.
-- The `main` branch dropped that feature and Neovim ships no equivalent.

-- [[ Configure LSP ]]
-- These keymaps are attached per buffer, once a language server actually connects to it.
-- The old `on_attach` callback plumbing is gone: Neovim 0.11+ fires LspAttach for this.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('JunLspAttach', { clear = true }),
  callback = function(event)
    local nmap = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc and 'LSP: ' .. desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(event.buf, 'Format', function(_)
      vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
  end,
})

-- document existing key chains
local wk = require('which-key')
wk.add {
  { '<leader>c', group = '[C]ode' },
  { '<leader>d', group = '[D]ocument' },
  { '<leader>g', group = '[G]it' },
  { '<leader>h', group = 'More git' },
  { '<leader>r', group = '[R]ename' },
  { '<leader>s', group = '[S]earch' },
  { '<leader>u', group = '[U]I' },
  { '<leader>w', group = '[W]orkspace' },
}

-- Enable the following language servers.
-- Settings go through `vim.lsp.config`, which is the 0.11+ replacement for `require('lspconfig')[name].setup{}`.
-- mason-lspconfig v2 then enables every server it has installed, so there is no setup loop any more.
local servers = { 'lua_ls' }

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = servers,
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
-- local cmp = require 'cmp'
-- local luasnip = require 'luasnip'
-- require('luasnip.loaders.from_vscode').lazy_load()
-- luasnip.config.setup {}
--
-- cmp.setup {
--   snippet = {
--     expand = function(args)
--       luasnip.lsp_expand(args.body)
--     end,
--   },
--   completion = {
--     completeopt = 'menu,menuone,noinsert'
--   },
--   mapping = cmp.mapping.preset.insert {
--     ['<C-n>'] = cmp.mapping.select_next_item(),
--     ['<C-p>'] = cmp.mapping.select_prev_item(),
--     ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete {},
--     ['<CR>'] = cmp.mapping.confirm {
--       behavior = cmp.ConfirmBehavior.Replace,
--       select = true,
--     },
--     ['<Tab>'] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_next_item()
--       elseif luasnip.expand_or_locally_jumpable() then
--         luasnip.expand_or_jump()
--       else
--         fallback()
--       end
--     end, { 'i', 's' }),
--     ['<S-Tab>'] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_prev_item()
--       elseif luasnip.locally_jumpable(-1) then
--         luasnip.jump(-1)
--       else
--         fallback()
--       end
--     end, { 'i', 's' }),
--   },
--   sources = {
--     { name = 'nvim_lsp' },
--     { name = 'luasnip' },
--   },
-- }
--
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et


-- JUN soft wrap shortcut 
--vim.api.nvim_set_keymap(
vim.keymap.set(
  'n',               -- Normal mode
  '<M-w>',           -- Alt + w as the trigger
  ':set wrap!<CR>',  -- Toggle wrap
  {noremap = true}   -- Options: no remap
)

-- Increase scale  (guard against nil: neovide_scale_factor is unset in the terminal)
vim.keymap.set("n", "<D-=>", function()
  vim.g.neovide_scale_factor = (vim.g.neovide_scale_factor or 1) + 0.1
  print("Scale factor: " .. vim.g.neovide_scale_factor)
end)

-- Decrease scale
vim.keymap.set("n", "<D-->", function()
  vim.g.neovide_scale_factor = math.max(0.1, (vim.g.neovide_scale_factor or 1) - 0.1)
  print("Scale factor: " .. vim.g.neovide_scale_factor)
end)


vim.keymap.set("x", "<leader>-", [[:<C-u>'<,'>normal! I - <CR>]], {
  desc = "Prefix selected lines with ' - '"
})

vim.keymap.set("x", "<leader>*", [[:<C-u>'<,'>normal! I * <CR>]], {
  desc = "Prefix selected lines with ' * '"
})
-- add italic and bold support for Neovide (doesn't matter for iTerm)
-- In 'guifont' a comma separates fallback fonts and a colon introduces an option, so "A:B:h14" asks for font A with an option named B.
-- This used to read "JetBrains Mono:Fira Code:h14", which Neovide rejected wholesale before falling back to SF Mono, a font not installed here.
-- Menlo is the fallback because it ships with macOS; JetBrains Mono supplies the bold and italic faces.
vim.opt.guifont = "JetBrains Mono,Menlo:h14"
