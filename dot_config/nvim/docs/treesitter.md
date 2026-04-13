# Treesitter Configuration

## Background

The `nvim-treesitter/nvim-treesitter` repository was **archived on April 3, 2026**. The plugin
was restructured into a parser-only manager. The old `master` branch still has the legacy API
but is stale. This config uses the `main` branch.

## What Changed

The `main` branch removed the entire "modules" system:

| Old API (master) | New API (main) | Notes |
|------------------|----------------|-------|
| `require("nvim-treesitter.configs").setup({...})` | `require("nvim-treesitter").setup()` | Only accepts `install_dir` |
| `ensure_installed = {...}` | Manual diff + `install()` | See below |
| `highlight = { enable = true, disable = ... }` | Built-in (nvim 0.12 default) | Use `vim.treesitter.stop(buf)` to disable |
| `incremental_selection = {...}` | Custom implementation | Using native `vim.treesitter` API |
| `auto_install = true` | Not available | Use the manual install approach |

## How Parser Auto-Install Works

The desired parser list is defined at the top of `lua/plugins/nvim-treesitter.lua`. On startup:

```lua
local installed = require("nvim-treesitter.config").get_installed()
local missing = vim.tbl_filter(function(p)
    return not vim.list_contains(installed, p)
end, ensure_installed)
if #missing > 0 then
    require("nvim-treesitter.install").install(missing, { summary = true })
end
```

To add a new language, add it to the `ensure_installed` table and restart nvim.

## tree-sitter CLI Requirement

The `main` branch compiles parsers from source using `tree-sitter build`. This requires the
**tree-sitter CLI** (a Rust binary):

```bash
cargo install tree-sitter-cli
```

The Homebrew `tree-sitter` package (`brew install tree-sitter`) is the **C library**, not the
CLI. Without the CLI, parser installation fails with:

```
Error during "tree-sitter build": ENOENT: no such file or directory
```

A C compiler is also required (Xcode Command Line Tools on macOS: `xcode-select --install`).

## Markdown Highlighting

Treesitter highlighting is **disabled for markdown** to avoid conflicts with markview.nvim.
This is done via a `FileType` autocmd:

```lua
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function(args)
        vim.treesitter.stop(args.buf)
    end,
})
```

Vim's built-in markdown syntax is used instead. The `after/ftplugin/markdown.lua` file forces
`markdownError` highlight to `Normal` to prevent red backgrounds on underscores in words like
`some_variable`.

## Incremental Selection

The old `incremental_selection` module is reimplemented using native `vim.treesitter`:

- `<cr>` in normal mode: Get treesitter node at cursor, enter visual mode selecting it
- `<cr>` in visual mode: Expand selection to parent node
- `<s-cr>` in visual mode: Shrink selection to child node at cursor position

Edge cases handled:
- No treesitter parser for buffer: `<cr>` is a no-op
- Cursor at root node: expansion stops (no parent)
- No named child at cursor: shrinking stops

## Available Commands

| Command | Action |
|---------|--------|
| `:TSInstall <lang>` | Install a parser |
| `:TSInstall! <lang>` | Force reinstall a parser |
| `:TSUpdate` | Update all installed parsers |
| `:TSUninstall <lang>` | Remove a parser |
| `:TSLog` | View install/compile log |

## Installed Parsers

Current list (defined in `lua/plugins/nvim-treesitter.lua`):

c, cpp, lua, query, markdown, markdown_inline, json, go, gomod, gosum,
typescript, tsx, csv, dockerfile, svelte, yaml, html, xml, javascript,
scss, css, bash, jsdoc, rust, python, toml
