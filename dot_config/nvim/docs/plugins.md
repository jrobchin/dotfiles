# Plugin Inventory

27 plugins total, managed by lazy.nvim. Last updated: 2026-04-11.

## AI

| Plugin | Source | Loading | Purpose |
|--------|--------|---------|---------|
| claudecode.nvim | `coder/claudecode.nvim` | Keys (`<leader>a*`) | Claude Code terminal integration |
| copilot.vim | `github/copilot.vim` | VeryLazy | GitHub Copilot ghost text completions |

## Completion and Snippets

| Plugin | Source | Loading | Purpose |
|--------|--------|---------|---------|
| blink.cmp | `saghen/blink.cmp` | Auto (completion) | Main completion engine with Rust fuzzy matcher |
| blink.compat | `saghen/blink.compat` | Lazy (on demand) | nvim-cmp source compat layer for blink |
| blink-emoji.nvim | `moyiz/blink-emoji.nvim` | Via blink.cmp | Emoji completions in markdown/gitcommit |
| friendly-snippets | `rafamadriz/friendly-snippets` | Via blink.cmp | Community snippet collection |
| lazydev.nvim | `folke/lazydev.nvim` | ft=lua | Lua LSP completions for nvim API (vim.uv, etc.) |

**Interactions**: blink.cmp sources include `lsp`, `path`, `snippets`, `buffer`, `lazydev`, `emoji`. Ghost text is enabled. lazydev gets highest score_offset (100) so nvim API completions rank first in Lua files.

## LSP and Diagnostics

| Plugin | Source | Loading | Purpose |
|--------|--------|---------|---------|
| nvim-lspconfig | `neovim/nvim-lspconfig` | Auto | LSP server configuration |
| mason.nvim | `mason-org/mason.nvim` | Via lspconfig | LSP/tool auto-installer |
| mason-lspconfig.nvim | `mason-org/mason-lspconfig.nvim` | Via lspconfig | Mason-LSP bridge |
| mason-tool-installer | `WhoIsSethDaniel/mason-tool-installer.nvim` | Via lspconfig | Auto-install formatters/linters |
| fidget.nvim | `j-hui/fidget.nvim` | Via lspconfig | LSP progress indicator |

## Treesitter

| Plugin | Source | Loading | Purpose |
|--------|--------|---------|---------|
| nvim-treesitter | `nvim-treesitter/nvim-treesitter` | Eager (lazy=false) | Parser manager (main branch, repo archived) |
| nvim-treesitter-context | `nvim-treesitter/nvim-treesitter-context` | Auto | Sticky function/class context at top of buffer |

**Interactions**: Treesitter highlighting is disabled for markdown (markview handles rendering). nvim-treesitter depends on markview.nvim to ensure markview loads first.

## Navigation and Search

| Plugin | Source | Loading | Purpose |
|--------|--------|---------|---------|
| fzf-lua | `ibhagwan/fzf-lua` | Keys (`<leader>f*`) | Fuzzy finder for files, grep, LSP symbols |
| flash.nvim | `folke/flash.nvim` | VeryLazy | Jump to any visible location with `s`/`S` |
| oil.nvim | `stevearc/oil.nvim` | Eager (lazy=false) | File explorer as a buffer |

## Git

| Plugin | Source | Loading | Purpose |
|--------|--------|---------|---------|
| gitsigns.nvim | `lewis6991/gitsigns.nvim` | Auto | Git gutter signs, hunk staging, blame |
| neogit | `NeogitOrg/neogit` | Keys (`<leader>gg`) | Git UI (magit-like) |
| diffview.nvim | `sindrets/diffview.nvim` | Via neogit | Side-by-side diff viewer |

## Formatting

| Plugin | Source | Loading | Purpose |
|--------|--------|---------|---------|
| conform.nvim | `stevearc/conform.nvim` | Eager (lazy=false) | Format on save with per-filetype formatters |

## UI and Appearance

| Plugin | Source | Loading | Purpose |
|--------|--------|---------|---------|
| vague.nvim | `vague2k/vague.nvim` | Eager (priority=1000) | Colorscheme |
| mini.nvim | `echasnovski/mini.nvim` | Auto | Icons, cursorword, statusline, indentscope |
| snacks.nvim | `folke/snacks.nvim` | Auto | Input and notifier UI modules |
| which-key.nvim | `folke/which-key.nvim` | VeryLazy | Keymap popup hints |
| todo-comments.nvim | `folke/todo-comments.nvim` | Auto | Highlight TODO/FIXME/HACK in code |
| guttermarks.nvim | `dimtion/guttermarks.nvim` | BufReadPost | Show marks in the sign column |

## Language-Specific

| Plugin | Source | Loading | Purpose |
|--------|--------|---------|---------|
| rustaceanvim | `mrcjkb/rustaceanvim` | Auto (ft detection) | Rust LSP enhancements (code actions, runnables) |
| ts-autotag.nvim | `tronikelis/ts-autotag.nvim` | VeryLazy | Auto close/rename HTML/JSX tags |

## Markdown

| Plugin | Source | Loading | Purpose |
|--------|--------|---------|---------|
| markview.nvim | `OXY2DEV/markview.nvim` | Eager (lazy=false) | Markdown rendering in-buffer (preview disabled) |
| markdown-preview.nvim | `iamcco/markdown-preview.nvim` | Cmd/ft | Browser-based markdown preview |
| img-clip.nvim | `HakonHarnes/img-clip.nvim` | VeryLazy, ft=markdown | Paste images from clipboard |

**Interactions**: markview requires treesitter highlighting disabled for markdown. The `after/ftplugin/markdown.lua` forces `markdownError` highlight to `Normal` to prevent red underscore highlights from vim's built-in syntax.

## Debug

| Plugin | Source | Loading | Purpose |
|--------|--------|---------|---------|
| nvim-dap | `mfussenegger/nvim-dap` | Keys (`<leader>d*`) | Debug adapter protocol client |
| nvim-dap-ui | `rcarriga/nvim-dap-ui` | Via dap | Debug UI panels |
| nvim-nio | `nvim-neotest/nvim-nio` | Via dap-ui | Async IO (dap-ui dependency) |
| mason-nvim-dap | `jay-babu/mason-nvim-dap.nvim` | Via dap | Auto-install debug adapters |
| nvim-dap-go | `leoluz/nvim-dap-go` | Via dap | Go debugger (delve) |

## Misc

| Plugin | Source | Loading | Purpose |
|--------|--------|---------|---------|
| outline.nvim | `hedyhli/outline.nvim` | VeryLazy, keys | Symbol outline sidebar |
| guess-indent.nvim | `NMAC427/guess-indent.nvim` | Auto | Auto-detect file indent settings |
| nvim-autopairs | `windwp/nvim-autopairs` | InsertEnter | Auto-close brackets/quotes |
| kitty-scrollback.nvim | `mikesmithgh/kitty-scrollback.nvim` | Cmd/Event | View kitty terminal scrollback in nvim |
| csvview.nvim | `hat0uma/csvview.nvim` | ft=csv,tsv | CSV/TSV column-aligned viewer |
| nvim-ts-context-commentstring | (removed) | -- | Was for JSX comments, now handled by ftplugin |
