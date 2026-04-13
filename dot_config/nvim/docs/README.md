# Neovim Config

Neovim 0.12+ config managed by chezmoi. Uses lazy.nvim for plugin management.

## Prerequisites

Install these before opening nvim for the first time:

```bash
# Homebrew packages
brew install neovim ripgrep fd fzf

# Rust toolchain (needed for tree-sitter CLI and rust-analyzer)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup component add rust-analyzer

# tree-sitter CLI (compiles treesitter parsers from source)
cargo install tree-sitter-cli

# Node.js (needed for markdown-preview.nvim build step)
brew install node

# Optional: formatters and linters (Mason auto-installs most, but these are faster via brew)
brew install stylua
npm install -g prettierd
```

## First Launch

1. Open `nvim`. lazy.nvim bootstraps itself and installs all plugins.
2. Run `:Lazy sync` to ensure everything is up to date.
3. Treesitter parsers auto-install on first launch (requires `tree-sitter` CLI).
4. Mason auto-installs LSP servers and tools on first launch.
5. Run `:checkhealth` to verify everything is working.

## Directory Structure

```
~/.config/nvim/
  init.lua                    # Entry point, loads all modules
  lua/
    config/
      globals.lua             # Leader keys, global flags (loaded FIRST)
      options.lua             # Editor settings, auto-save, folding
      winbar.lua              # Custom winbar with git info + file path
      lazy.lua                # lazy.nvim bootstrap and setup
      keymaps.lua             # All non-plugin keymaps (via which-key)
    plugins/
      lsp.lua                 # LSP config, Mason, diagnostics
      cmp.lua                 # blink.cmp completion, lazydev, snippets
      nvim-treesitter.lua     # Parser management, incremental selection
      conform.lua             # Format on save (prettier, stylua, black)
      fzf.lua                 # fzf-lua fuzzy finder
      gitsigns.lua            # Git gutter, hunk staging, blame
      debug.lua               # DAP debugger (Go)
      oil.lua                 # File explorer
      neogit.lua              # Git UI with diffview
      markdown.lua            # markview, markdown-preview, img-clip
      claudecode.lua          # Claude Code nvim integration
      copilot.lua             # GitHub Copilot
      misc.lua                # Colorscheme, outline, autopairs, etc.
      mini.lua                # mini.icons, cursorword, statusline, indentscope
      flash.lua               # Jump/motion
      snacks.lua              # Input/notifier UI
      which-key.lua           # Keymap hints
      rust.lua                # rustaceanvim
      kitty-scrollback.lua    # Kitty terminal scrollback
      csview.lua              # CSV/TSV viewer
  after/
    ftplugin/
      markdown.lua            # Fix markdownError red highlights
      javascriptreact.lua     # JSX commentstring
      typescriptreact.lua     # TSX commentstring
      rust.lua                # Rust-specific keymaps (RustLsp)
  docs/                       # This documentation
  snippets/                   # Custom snippet files
  spell/                      # Spell dictionary
```

## Load Order

```
init.lua
  1. config.globals     -- mapleader = " " (MUST be before lazy)
  2. config.options      -- editor settings, auto-save
  3. config.winbar       -- custom winbar setup
  4. config.lazy         -- bootstrap lazy.nvim, load all plugins
  5. config.keymaps      -- global keymaps via which-key
```

The leader key must be set in `globals.lua` before `lazy.lua` runs, otherwise plugin keymaps using `<leader>` won't bind correctly.

## Plugin Manager

lazy.nvim auto-checks for updates (silently). Key commands:

- `:Lazy` - Open the lazy.nvim UI
- `:Lazy sync` - Install missing plugins, update existing, clean removed
- `:Lazy update` - Update all plugins
- `:Lazy health` - Check for issues

## Key Design Decisions

- **No mouse**: `opt.mouse = ""` disables mouse entirely
- **Auto-save**: Writes on `InsertLeavePre` and `TextChanged` with guards for modifiable, non-special buffers
- **Treesitter folding**: Uses `vim.treesitter.foldexpr()` with `foldlevel = 99` (all open by default)
- **Global statusline**: `laststatus = 3` with mini.statusline
- **Smooth scrolling**: `smoothscroll = true` with custom `<C-j>`/`<C-k>` scroll bindings
- **Spell checking**: Enabled globally with `camel` option for code identifiers
- **winborder**: Set globally to `"rounded"` so all floating windows get rounded borders
