# LSP Configuration

## Architecture

```
nvim-lspconfig          -- Server configs and setup
  + mason.nvim          -- Auto-installs servers/tools
  + mason-lspconfig     -- Bridges mason and lspconfig
  + mason-tool-installer -- Ensures formatters/linters are installed
  + fidget.nvim         -- LSP progress UI
  + which-key.nvim      -- Keymap hints

blink.cmp               -- Completion engine
  -> broadcasts capabilities to all LSP servers
```

## Configured Servers

| Server | Languages | Settings |
|--------|-----------|----------|
| `clangd` | C, C++ | Defaults |
| `lua_ls` | Lua | callSnippet = "Replace" |
| `marksman` | Markdown | Defaults |
| `eslint` | JS/TS | workingDirectory mode = "auto" |
| `pyright` | Python | Defaults |
| `emmet_ls` | HTML, JSX, TSX, CSS, Sass, SCSS, Less, Svelte | Filetypes restricted |
| `vtsls` | TypeScript, JavaScript | Relative imports, function call completion |
| `svelte` | Svelte | Defaults |
| `somesass_ls` | SASS/SCSS | Defaults |
| `tailwindcss` | HTML, JSX, TSX, CSS, Sass, SCSS, Svelte | clsx/cn/cva class regex |
| `gdscript` | GDScript (Godot) | Not managed by Mason (`vim.lsp.enable`) |

## Mason Auto-Install List

These are installed automatically by mason-tool-installer:

**LSP servers**: All servers in the table above (except gdscript)

**Tools**:
- `stylua` (Lua formatter)
- `eslint_d` (ESLint daemon)
- `prettierd` (Prettier daemon)
- `isort` (Python import sorter)
- `black` (Python formatter)
- `gopls` (Go LSP)
- `tailwindcss-language-server`

## LSP Keymaps

All LSP keymaps are set in the `LspAttach` autocmd (buffer-local). See `docs/keymaps.md` for
the full list.

Key overrides of nvim 0.12 defaults:

| Default | Override | Reason |
|---------|----------|--------|
| `grr` -> `vim.lsp.buf.references()` | `fzf-lua.lsp_references` | fzf-lua picker UI |
| `gri` -> `vim.lsp.buf.implementation()` | `fzf-lua.lsp_implementations` | fzf-lua picker UI |
| `grt` -> `vim.lsp.buf.type_definition()` | `fzf-lua.lsp_typedefs` | fzf-lua picker UI |
| `gO` -> `vim.lsp.buf.document_symbol()` | `fzf-lua.lsp_document_symbols` | fzf-lua picker UI |

Defaults kept as-is: `grn` (rename), `gra` (code action), `gD` (declaration), `grx` (codelens), `<C-s>` (signature help).

`grd` (goto definition) is a custom keymap (not a default) using `fzf-lua.lsp_definitions`.

## Diagnostics

```lua
vim.diagnostic.config({
    severity_sort = true,
    float = { border = "rounded", source = "if_many" },
    underline = { severity = ERROR },
    signs = { text = { ERROR = "...", WARN = "...", INFO = "...", HINT = "..." } },
    virtual_text = { source = "if_many", spacing = 2 },
})
```

- Signs use Nerd Font icons
- Virtual text shows source only when multiple LSP servers provide diagnostics
- Underline only for errors
- Floating windows use rounded borders (via global `winborder` option)

## Inlay Hints

- Enabled by default for all servers that support them
- **Disabled for vtsls** (TypeScript) because they're too noisy
- Toggle with `<leader>th`

## Capabilities

blink.cmp capabilities are broadcast to all servers:

```lua
local capabilities = require("blink.cmp").get_lsp_capabilities(
    vim.lsp.protocol.make_client_capabilities()
)
```

This ensures servers advertise snippet support, additional text edits, and other features
that blink.cmp can handle.

## Formatting

Formatting is handled by conform.nvim, not LSP (except when no conform formatter exists,
it falls back to LSP via `lsp_format = "fallback"`).

| Filetype | Formatter |
|----------|-----------|
| Lua | stylua |
| Python | black |
| TS/JS/TSX/JSX/Svelte/MD/JSON/CSS/SCSS/HTML | prettierd, prettier (first available) |

Format on save is enabled for all filetypes except `.svx` files.

## Document Highlighting

When the cursor rests on a symbol, all references in the buffer are highlighted. This uses
`textDocument/documentHighlight` and is enabled for all servers that support it. Highlights
clear on cursor move.

## Adding a New Server

1. Add the server name to the `servers` table in `lua/plugins/lsp.lua`
2. Optionally add settings, filetypes, or capabilities overrides
3. The mason-lspconfig handler will auto-configure it
4. If the server needs a tool installed, add it to the `ensure_installed` list
