-- ============================================================================
-- glamour.lua -- "Golden-Hour Neo-Deco" for Neovim
-- ----------------------------------------------------------------------------
-- Ported from the Glamour Dark VS Code theme at ~/git/int/glamour-dark, which
-- is itself derived from ~/git/pub/roam_colors/glamour.md.
-- Palette names below are the canonical ones from glamour-dark.md section 3, so
-- a color can be traced back to its role in the design rather than being an
-- anonymous hex code.
--
-- Contrast was measured in the source theme against the surface each color
-- actually lands on, so prefer re-using a palette entry over inventing a new
-- shade when extending this file.
--
-- Load with `:colorscheme glamour`.
-- ============================================================================

vim.cmd 'highlight clear'
if vim.fn.exists 'syntax_on' == 1 then
  vim.cmd 'syntax reset'
end

vim.o.background = 'dark'
vim.g.colors_name = 'glamour'

-- ── Palette ────────────────────────────────────────────────────────────────
-- Canonical names from glamour-dark.md.
local p = {
  -- Surfaces, darkest to lightest.
  night_espresso = '#110F0E', -- deepest surfaces
  espresso_ink = '#171310', -- main editor background
  black_marble = '#242126', -- floats, statusline, secondary surfaces
  walnut_shadow = '#30241F', -- borders and subtle panels
  dark_walnut = '#412D24', -- warm structural brown, selected rows

  -- Foregrounds, lightest to dimmest.
  porcelain_ivory = '#F7F2E9', -- highest emphasis
  warm_ivory = '#EDE6DC', -- normal editor foreground
  whipped_crema = '#E8D8C3', -- secondary text and punctuation
  muted_taupe = '#9A8B7D', -- comments and low-priority text
  deep_taupe = '#786B61', -- line numbers and disabled text

  -- Accents.
  champagne_brass = '#C7A46A', -- types, focus, active structure
  dark_brass = '#9B7948', -- muted gold states
  blush_satin = '#E6B9B7', -- numbers, constants, soft emphasis
  cocktail_fuchsia = '#D94E8F', -- keywords, cursor, primary accent
  soft_sage = '#A8B39C', -- strings, additions, success
  velvet_teal = '#67AAA5', -- links, imports, special symbols
  executive_blue = '#7E9DB5', -- functions and information
  twilight_violet = '#9B86BE', -- decorators, attributes
  warm_coral = '#E07A7F', -- errors and destructive states
}

-- Working values used by the VS Code theme that the canonical table does not
-- name. Kept separate so the palette above stays authoritative.
local x = {
  operator_grey = '#D8CFC2', -- operators and punctuation; ANSI white (normal)
  sage_deep = '#89967E', -- string delimiters; ANSI green (normal)
  taupe_doc = '#A59688', -- documentation comments
  brass_light = '#D8B77E', -- type parameters
  walnut_hover = '#3A2F2C', -- hovered rows
}

-- Alpha-composited values. Neovim has no highlight transparency, so the
-- source theme's 8-digit colors were resolved against Espresso Ink by hand.
local blend = {
  selection = '#4B3F2F', -- #C7A46A40 over the editor background
  line_highlight = '#1C1815', -- #F7F2E90C
  find_match = '#5C2B42', -- #D94E8F55
  find_other = '#3A2F22', -- #C7A46A30
  diff_add = '#1F2A1C', -- #A8B39C20
  diff_delete = '#2E1A19', -- #E07A7F20
  diff_change = '#2A241A', -- #C7A46A20
}

local hl = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ── Core editor ────────────────────────────────────────────────────────────
hl('Normal', { fg = p.warm_ivory, bg = p.espresso_ink })
hl('NormalNC', { fg = p.warm_ivory, bg = p.espresso_ink })
hl('NormalFloat', { fg = p.warm_ivory, bg = p.black_marble })
hl('FloatBorder', { fg = p.dark_walnut, bg = p.black_marble })
hl('FloatTitle', { fg = p.champagne_brass, bg = p.black_marble, bold = true })

hl('Cursor', { fg = p.espresso_ink, bg = p.cocktail_fuchsia })
hl('lCursor', { link = 'Cursor' })
hl('TermCursor', { link = 'Cursor' })
hl('CursorLine', { bg = blend.line_highlight })
hl('CursorColumn', { link = 'CursorLine' })
hl('ColorColumn', { bg = p.night_espresso })

hl('LineNr', { fg = p.deep_taupe })
hl('CursorLineNr', { fg = p.champagne_brass, bold = true })
hl('SignColumn', { bg = p.espresso_ink })
hl('FoldColumn', { fg = p.deep_taupe, bg = p.espresso_ink })

-- Folds are a working surface in this config rather than a rarity, so a closed
-- fold reads as a raised panel instead of dimmed-out text.
hl('Folded', { fg = p.champagne_brass, bg = p.walnut_shadow, italic = true })

hl('Visual', { bg = blend.selection })
hl('VisualNOS', { link = 'Visual' })

hl('Search', { fg = p.porcelain_ivory, bg = blend.find_other })
hl('IncSearch', { fg = p.espresso_ink, bg = p.cocktail_fuchsia, bold = true })
hl('CurSearch', { link = 'IncSearch' })
hl('Substitute', { fg = p.espresso_ink, bg = p.warm_coral })
hl('MatchParen', { fg = p.champagne_brass, bg = blend.find_other, bold = true })

hl('StatusLine', { fg = p.whipped_crema, bg = p.black_marble })
hl('StatusLineNC', { fg = p.deep_taupe, bg = p.night_espresso })
hl('WinSeparator', { fg = p.walnut_shadow })
hl('VertSplit', { link = 'WinSeparator' })

hl('Pmenu', { fg = p.whipped_crema, bg = p.black_marble })
hl('PmenuSel', { fg = p.porcelain_ivory, bg = p.dark_walnut, bold = true })
hl('PmenuSbar', { bg = p.walnut_shadow })
hl('PmenuThumb', { bg = p.deep_taupe })
hl('PmenuKind', { fg = p.champagne_brass, bg = p.black_marble })
hl('PmenuExtra', { fg = p.muted_taupe, bg = p.black_marble })

hl('TabLine', { fg = p.deep_taupe, bg = p.night_espresso })
hl('TabLineFill', { bg = p.night_espresso })
hl('TabLineSel', { fg = p.champagne_brass, bg = p.espresso_ink, bold = true })
hl('WinBar', { fg = p.whipped_crema, bg = p.espresso_ink })
hl('WinBarNC', { fg = p.deep_taupe, bg = p.espresso_ink })

hl('NonText', { fg = p.walnut_shadow })
hl('Whitespace', { fg = p.walnut_shadow })
hl('SpecialKey', { fg = p.dark_brass })
hl('EndOfBuffer', { fg = p.espresso_ink })
hl('Conceal', { fg = p.deep_taupe })
hl('Directory', { fg = p.champagne_brass, bold = true })
hl('Title', { fg = p.porcelain_ivory, bold = true })
hl('Question', { fg = p.soft_sage })
hl('MoreMsg', { fg = p.soft_sage })
hl('ModeMsg', { fg = p.whipped_crema, bold = true })
hl('ErrorMsg', { fg = p.warm_coral, bold = true })
hl('WarningMsg', { fg = p.champagne_brass })
hl('MsgArea', { fg = p.warm_ivory })
hl('MsgSeparator', { fg = p.walnut_shadow, bg = p.black_marble })
hl('QuickFixLine', { bg = p.dark_walnut, bold = true })
hl('WildMenu', { link = 'PmenuSel' })

-- StdoutMsg and StderrMsg are left undefined on purpose.
-- init.lua clears StderrMsg on every ColorScheme event so that a successful
-- git push does not come back red, and setting them here would fight that.

-- Prose lives in this config as much as code does, so spelling marks are
-- undercurls in palette colors rather than the default harsh red.
hl('SpellBad', { sp = p.warm_coral, undercurl = true })
hl('SpellCap', { sp = p.champagne_brass, undercurl = true })
hl('SpellLocal', { sp = p.velvet_teal, undercurl = true })
hl('SpellRare', { sp = p.twilight_violet, undercurl = true })

-- ── Legacy syntax groups ───────────────────────────────────────────────────
hl('Comment', { fg = p.muted_taupe, italic = true })
hl('SpecialComment', { fg = x.taupe_doc, italic = true })
hl('Todo', { fg = p.espresso_ink, bg = p.champagne_brass, bold = true })
hl('Error', { fg = p.warm_coral })

hl('Constant', { fg = p.blush_satin })
hl('String', { fg = p.soft_sage })
hl('Character', { fg = p.soft_sage })
hl('Number', { fg = p.blush_satin })
hl('Boolean', { fg = p.blush_satin })
hl('Float', { fg = p.blush_satin })

hl('Identifier', { fg = p.warm_ivory })
hl('Function', { fg = p.executive_blue })

hl('Statement', { fg = p.cocktail_fuchsia })
hl('Conditional', { fg = p.cocktail_fuchsia })
hl('Repeat', { fg = p.cocktail_fuchsia })
hl('Label', { fg = p.cocktail_fuchsia })
hl('Operator', { fg = x.operator_grey })
hl('Keyword', { fg = p.cocktail_fuchsia })
hl('Exception', { fg = p.cocktail_fuchsia })

hl('PreProc', { fg = p.twilight_violet })
hl('Include', { fg = p.velvet_teal })
hl('Define', { fg = p.twilight_violet })
hl('Macro', { fg = p.twilight_violet })
hl('PreCondit', { fg = p.twilight_violet })

hl('Type', { fg = p.champagne_brass })
hl('StorageClass', { fg = p.cocktail_fuchsia })
hl('Structure', { fg = p.champagne_brass })
hl('Typedef', { fg = p.champagne_brass })

hl('Special', { fg = p.velvet_teal })
hl('SpecialChar', { fg = p.velvet_teal })
hl('Tag', { fg = p.cocktail_fuchsia })
hl('Delimiter', { fg = x.operator_grey })
hl('Debug', { fg = p.warm_coral })
hl('Underlined', { fg = p.velvet_teal, underline = true })
hl('Ignore', { fg = p.deep_taupe })

-- ── Treesitter ─────────────────────────────────────────────────────────────
hl('@comment', { link = 'Comment' })
hl('@comment.documentation', { fg = x.taupe_doc, italic = true })
hl('@comment.error', { fg = p.warm_coral, bold = true })
hl('@comment.warning', { fg = p.champagne_brass, bold = true })
hl('@comment.todo', { link = 'Todo' })
hl('@comment.note', { fg = p.velvet_teal, bold = true })

hl('@string', { fg = p.soft_sage })
hl('@string.documentation', { fg = x.taupe_doc, italic = true })
hl('@string.escape', { fg = p.velvet_teal })
hl('@string.regexp', { fg = p.velvet_teal })
hl('@string.special', { fg = p.velvet_teal })
hl('@string.special.url', { fg = p.velvet_teal, underline = true })
hl('@character', { fg = p.soft_sage })
hl('@character.special', { fg = p.velvet_teal })

hl('@number', { fg = p.blush_satin })
hl('@number.float', { fg = p.blush_satin })
hl('@boolean', { fg = p.blush_satin })
hl('@constant', { fg = p.blush_satin })
hl('@constant.builtin', { fg = p.blush_satin })
hl('@constant.macro', { fg = p.twilight_violet })

hl('@function', { fg = p.executive_blue })
hl('@function.call', { fg = p.executive_blue })
hl('@function.builtin', { fg = p.executive_blue })
hl('@function.macro', { fg = p.twilight_violet })
hl('@function.method', { fg = p.executive_blue })
hl('@function.method.call', { fg = p.executive_blue })
hl('@constructor', { fg = p.champagne_brass })

hl('@variable', { fg = p.warm_ivory })
hl('@variable.builtin', { fg = p.warm_ivory, italic = true })
hl('@variable.parameter', { fg = p.whipped_crema })
hl('@variable.member', { fg = p.warm_ivory })
hl('@property', { fg = p.warm_ivory })
hl('@field', { fg = p.warm_ivory })

hl('@keyword', { fg = p.cocktail_fuchsia })
hl('@keyword.function', { fg = p.cocktail_fuchsia })
hl('@keyword.operator', { fg = p.cocktail_fuchsia })
hl('@keyword.return', { fg = p.cocktail_fuchsia })
hl('@keyword.conditional', { fg = p.cocktail_fuchsia })
hl('@keyword.repeat', { fg = p.cocktail_fuchsia })
hl('@keyword.exception', { fg = p.cocktail_fuchsia })
hl('@keyword.import', { fg = p.velvet_teal })
hl('@keyword.directive', { fg = p.twilight_violet })

hl('@type', { fg = p.champagne_brass })
hl('@type.builtin', { fg = p.champagne_brass })
hl('@type.definition', { fg = p.champagne_brass })
hl('@type.qualifier', { fg = p.cocktail_fuchsia })
hl('@attribute', { fg = p.twilight_violet })
hl('@module', { fg = p.velvet_teal })
hl('@namespace', { fg = p.velvet_teal })
hl('@label', { fg = p.cocktail_fuchsia })

hl('@operator', { fg = x.operator_grey })
hl('@punctuation.delimiter', { fg = x.operator_grey })
hl('@punctuation.bracket', { fg = x.operator_grey })
hl('@punctuation.special', { fg = p.dark_brass })

hl('@tag', { fg = p.cocktail_fuchsia })
hl('@tag.attribute', { fg = p.champagne_brass })
hl('@tag.delimiter', { fg = x.operator_grey })

hl('@diff.plus', { fg = p.soft_sage })
hl('@diff.minus', { fg = p.warm_coral })
hl('@diff.delta', { fg = p.champagne_brass })

-- ── Markup: markdown, and prose generally ──────────────────────────────────
-- Capture names verified against the bundled markdown and markdown_inline
-- parsers rather than assumed, since the two split block and inline structure
-- between them.
--
-- Headings: Champagne Brass for h1 and h2, Whipped Crema below that.
-- This deliberately diverges from the source theme, which gives h1 Porcelain
-- Ivory; in a long Neovim buffer the brass reads better as "outline" than the
-- near-white does, so the top two levels share it.
hl('@markup.heading.1', { fg = p.champagne_brass, bold = true })
hl('@markup.heading.2', { fg = p.champagne_brass, bold = true })
hl('@markup.heading.3', { fg = p.whipped_crema, bold = true })
hl('@markup.heading.4', { fg = p.whipped_crema })
hl('@markup.heading.5', { fg = p.whipped_crema })
hl('@markup.heading.6', { fg = p.whipped_crema })

-- Emphasis takes Cocktail Fuchsia, the theme's primary accent, rather than the
-- source theme's ivory and crema. Another deliberate divergence: with headings
-- now in brass, emphasis needs its own hue to stay visible inside a paragraph.
hl('@markup.strong', { fg = p.cocktail_fuchsia, bold = true })
hl('@markup.italic', { fg = p.cocktail_fuchsia, italic = true })
hl('@markup.strikethrough', { fg = p.deep_taupe, strikethrough = true })
hl('@markup.underline', { underline = true })

-- Inline code and fenced blocks both read as Soft Sage, matching strings.
hl('@markup.raw', { fg = p.soft_sage })
hl('@markup.raw.block', { fg = p.soft_sage })
hl('@markup.raw.delimiter', { fg = p.muted_taupe })

hl('@markup.link', { fg = p.velvet_teal })
hl('@markup.link.label', { fg = p.blush_satin })
hl('@markup.link.url', { fg = p.velvet_teal, underline = true })

-- List bullets take Executive Blue so a nested list's structure stands out
-- from the prose, while blockquote bars stay Dark Brass via @punctuation.special
-- and recede behind the text they mark up. A heading's '#' is captured as part
-- of the heading itself and takes its color.
-- The blue is a deliberate divergence from the source theme's Dark Brass.
hl('@markup.list', { fg = p.executive_blue })
hl('@markup.list.checked', { fg = p.soft_sage })
hl('@markup.list.unchecked', { fg = p.deep_taupe })
hl('@markup.quote', { fg = p.dark_brass, italic = true })
hl('@markup.math', { fg = p.blush_satin })

-- Hashtags like #project are matched by a regex in init.lua, not by treesitter,
-- because the markdown parser has no node for them.
hl('MarkdownHashtag', { fg = p.blush_satin })
hl('@markup.environment', { fg = p.champagne_brass })
hl('@markup.environment.name', { fg = p.champagne_brass })

-- ── Latex ──────────────────────────────────────────────────────────────────
-- Environments take Champagne Brass as structural, citations and references
-- take Velvet Teal as links, and braces stay Whipped Crema so the argument
-- scaffolding does not compete with the prose inside it.
hl('@function.macro.latex', { fg = p.cocktail_fuchsia })
hl('@module.latex', { fg = p.champagne_brass })
hl('@markup.link.label.latex', { fg = p.velvet_teal })
hl('@punctuation.bracket.latex', { fg = p.whipped_crema })
hl('@punctuation.delimiter.latex', { fg = p.whipped_crema })
hl('@markup.math.latex', { fg = p.blush_satin })

-- ── LSP semantic tokens ────────────────────────────────────────────────────
-- These map one-to-one onto the source theme's semanticTokenColors.
hl('@lsp.type.namespace', { fg = p.velvet_teal })
hl('@lsp.type.type', { fg = p.champagne_brass })
hl('@lsp.type.class', { fg = p.champagne_brass })
hl('@lsp.type.enum', { fg = p.champagne_brass })
hl('@lsp.type.interface', { fg = p.champagne_brass })
hl('@lsp.type.struct', { fg = p.champagne_brass })
hl('@lsp.type.typeParameter', { fg = x.brass_light })
hl('@lsp.type.parameter', { fg = p.whipped_crema })
hl('@lsp.type.variable', { fg = p.warm_ivory })
hl('@lsp.type.property', { fg = p.warm_ivory })
hl('@lsp.type.enumMember', { fg = p.blush_satin })
hl('@lsp.type.event', { fg = p.twilight_violet })
hl('@lsp.type.function', { fg = p.executive_blue })
hl('@lsp.type.method', { fg = p.executive_blue })
hl('@lsp.type.macro', { fg = p.twilight_violet })
hl('@lsp.type.decorator', { fg = p.twilight_violet })
hl('@lsp.type.comment', { fg = p.muted_taupe, italic = true })
hl('@lsp.type.string', { fg = p.soft_sage })
hl('@lsp.type.number', { fg = p.blush_satin })
hl('@lsp.type.regexp', { fg = p.velvet_teal })
hl('@lsp.type.operator', { fg = x.operator_grey })
hl('@lsp.type.keyword', { fg = p.cocktail_fuchsia })
hl('@lsp.mod.declaration', { fg = p.porcelain_ivory })
hl('@lsp.mod.readonly', { fg = p.blush_satin })
hl('@lsp.mod.deprecated', { fg = p.deep_taupe, strikethrough = true })

hl('LspReferenceText', { bg = p.dark_walnut })
hl('LspReferenceRead', { bg = p.dark_walnut })
hl('LspReferenceWrite', { bg = p.dark_walnut, underline = true })
hl('LspSignatureActiveParameter', { fg = p.champagne_brass, bold = true })
hl('LspInlayHint', { fg = p.deep_taupe, bg = p.walnut_shadow, italic = true })

-- ── Diagnostics ────────────────────────────────────────────────────────────
hl('DiagnosticError', { fg = p.warm_coral })
hl('DiagnosticWarn', { fg = p.champagne_brass })
hl('DiagnosticInfo', { fg = p.executive_blue })
hl('DiagnosticHint', { fg = p.velvet_teal })
hl('DiagnosticOk', { fg = p.soft_sage })

hl('DiagnosticUnderlineError', { sp = p.warm_coral, undercurl = true })
hl('DiagnosticUnderlineWarn', { sp = p.champagne_brass, undercurl = true })
hl('DiagnosticUnderlineInfo', { sp = p.executive_blue, undercurl = true })
hl('DiagnosticUnderlineHint', { sp = p.velvet_teal, undercurl = true })
hl('DiagnosticUnderlineOk', { sp = p.soft_sage, undercurl = true })

hl('DiagnosticVirtualTextError', { fg = p.warm_coral, bg = blend.diff_delete })
hl('DiagnosticVirtualTextWarn', { fg = p.champagne_brass, bg = blend.diff_change })
hl('DiagnosticVirtualTextInfo', { fg = p.executive_blue, bg = p.walnut_shadow })
hl('DiagnosticVirtualTextHint', { fg = p.velvet_teal, bg = p.walnut_shadow })
hl('DiagnosticDeprecated', { fg = p.deep_taupe, strikethrough = true })
hl('DiagnosticUnnecessary', { fg = p.deep_taupe })

-- ── Diff ───────────────────────────────────────────────────────────────────
hl('DiffAdd', { bg = blend.diff_add })
hl('DiffChange', { bg = blend.diff_change })
hl('DiffDelete', { fg = p.warm_coral, bg = blend.diff_delete })
hl('DiffText', { fg = p.porcelain_ivory, bg = p.dark_walnut, bold = true })
hl('Added', { fg = p.soft_sage })
hl('Changed', { fg = p.champagne_brass })
hl('Removed', { fg = p.warm_coral })

-- ── Terminal ───────────────────────────────────────────────────────────────
-- The ANSI pairs recommended by glamour-dark.md section 10, so `:terminal`
-- output reads as part of the editor rather than a separate retro palette.
vim.g.terminal_color_0 = p.espresso_ink
vim.g.terminal_color_8 = p.deep_taupe
vim.g.terminal_color_1 = '#C76167'
vim.g.terminal_color_9 = p.warm_coral
vim.g.terminal_color_2 = x.sage_deep
vim.g.terminal_color_10 = p.soft_sage
vim.g.terminal_color_3 = '#A98650'
vim.g.terminal_color_11 = p.champagne_brass
vim.g.terminal_color_4 = '#637F95'
vim.g.terminal_color_12 = p.executive_blue
vim.g.terminal_color_5 = '#B54777'
vim.g.terminal_color_13 = p.cocktail_fuchsia
vim.g.terminal_color_6 = '#4F8A87'
vim.g.terminal_color_14 = p.velvet_teal
vim.g.terminal_color_7 = x.operator_grey
vim.g.terminal_color_15 = p.porcelain_ivory
