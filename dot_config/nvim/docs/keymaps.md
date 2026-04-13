# Keymap Reference

Leader key: `<Space>` (both leader and localleader).

## Navigation

| Key | Mode | Action |
|-----|------|--------|
| `j` / `k` | n, x | Navigate by visual line (gj/gk) |
| `<C-j>` | n, x | Scroll down 5 lines |
| `<C-k>` | n, x | Scroll up 5 lines |
| `<C-u>` | n, x | Scroll up 10 lines |
| `<C-d>` | n, x | Scroll down 10 lines |
| `<C-l>` | n, x | Toggle search highlighting |

## Files and Buffers

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ww` | n, x | Write file |
| `<leader>wW` | n, x | Write file (no autocmds) |
| `<leader>wa` | n, x | Write all files |
| `<leader>bd` | n, x | Delete buffer |
| `<leader>bD` | n, x | Force delete buffer |
| `<leader>bo` | n, x | Delete all buffers except current |
| `<leader>ba` | n, x | Delete all buffers |
| `<leader>bp` | n, x | Copy relative path |
| `<leader>bP` | n, x | Copy absolute path |
| `<leader>bl` | n, x | Copy relative path:line |
| `<leader>bL` | n, x | Copy absolute path:line (or range) |
| `<leader>bn` | n, x | Copy file name |
| `<leader>bN` | n, x | Copy file name (no extension) |
| `<leader>br` | n, x | Reload buffer |
| `<leader>bO` | n, x | Open containing folder in Finder |

## Fuzzy Finder (fzf-lua)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ff` | n | Find files |
| `<leader>fF` | n | Find files (resume) |
| `<leader>fg` | n | Grep |
| `<leader>fG` | n | Grep (resume) |
| `<leader>fw` | n | Grep current word |
| `<leader>fv` | v | Grep visual selection |
| `<leader>fp` | n | Grep project |
| `<leader>fP` | n | Grep project (resume) |
| `<leader>fh` | n | Help tags |
| `<leader>fi` | n | fzf-lua builtins |
| `<leader>fk` | n | Keymaps |
| `<leader>fo` | n | Old files |
| `<leader>fd` | n | Document diagnostics |
| `<leader>fD` | n | Workspace diagnostics |
| `<leader>fm` | n | Marks |
| `<leader><leader>` | n | List buffers |
| `<leader>/` | n | Fuzzy search current buffer |
| `<leader>'` | n | Fuzzy search current buffer (resume) |

## LSP (set in LspAttach, buffer-local)

### Custom (fzf-lua overrides of defaults)

These override nvim 0.12 built-in LSP keymaps to use fzf-lua as the picker:

| Key | Mode | Action |
|-----|------|--------|
| `grr` | n | Goto references (fzf-lua) |
| `gri` | n | Goto implementation (fzf-lua) |
| `grd` | n | Goto definition (fzf-lua) |
| `gO` | n | Document symbols (fzf-lua) |
| `gW` | n | Workspace symbols (fzf-lua) |
| `grt` | n | Type definition (fzf-lua) |
| `gsd` | n | Search document diagnostics (fzf-lua) |
| `gsD` | n | Search workspace diagnostics (fzf-lua) |
| `<C-s>` | i | Signature help (registered for which-key) |
| `<leader>th` | n | Toggle inlay hints |

### Built-in Defaults (nvim 0.12, not overridden)

| Key | Mode | Action |
|-----|------|--------|
| `grn` | n | Rename symbol |
| `gra` | n, x | Code action |
| `gD` | n | Goto declaration |
| `grx` | n | Run code lens |
| `<C-s>` | i | Signature help |
| `[d` / `]d` | n | Previous/next diagnostic |

## Git (gitsigns)

| Key | Mode | Action |
|-----|------|--------|
| `]c` / `[c` | n | Next/previous git change |
| `<leader>hs` | n, v | Stage hunk |
| `<leader>hr` | n, v | Reset hunk |
| `<leader>hS` | n | Stage buffer |
| `<leader>hu` | n | Undo stage hunk |
| `<leader>hR` | n | Reset buffer |
| `<leader>hp` | n | Preview hunk |
| `<leader>hb` | n | Blame line |
| `<leader>hd` | n | Diff against index |
| `<leader>hD` | n | Diff against last commit |
| `<leader>tb` | n | Toggle blame line |
| `<leader>tD` | n | Toggle deleted (inline) |
| `<leader>gg` | n | Open Neogit |

## Claude Code

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ac` | n | Toggle Claude |
| `<leader>af` | n | Focus Claude |
| `<leader>ar` | n | Resume Claude |
| `<leader>aC` | n | Continue Claude |
| `<leader>am` | n | Select Claude model |
| `<leader>ab` | n | Add current buffer |
| `<leader>as` | v | Send selection to Claude |
| `<leader>aa` | n | Accept diff |
| `<leader>ad` | n | Deny diff |

## Flash (jump/motion)

| Key | Mode | Action |
|-----|------|--------|
| `s` | n, x, o | Flash jump |
| `S` | n, x, o | Flash treesitter |
| `r` | o | Remote flash |
| `R` | o, x | Treesitter search |
| `<C-s>` | c | Toggle flash in search |

## Treesitter Incremental Selection

| Key | Mode | Action |
|-----|------|--------|
| `<cr>` | n, v | Expand selection (init or grow to parent node) |
| `<s-cr>` | v | Shrink selection (to child node) |

## Debug (DAP)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>dc` | n | Start/continue |
| `<leader>dq` | n | Close debug UI |
| `<leader>di` | n | Step into |
| `<leader>do` | n | Step over |
| `<leader>dO` | n | Step out |
| `<leader>db` | n | Toggle breakpoint |
| `<leader>dB` | n | Set conditional breakpoint |
| `<leader>dD` | n | Toggle debug UI |

## Diagnostics and Lists

| Key | Mode | Action |
|-----|------|--------|
| `gl` | n | Open floating diagnostics |
| `<leader>qp` | n | Populate quickfix with diagnostics |
| `<leader>qq` | n | Toggle quickfix list |
| `<leader>lp` | n | Populate loclist with diagnostics |
| `<leader>ll` | n | Toggle loclist |

## Spelling

| Key | Mode | Action |
|-----|------|--------|
| `<leader>sf` | n | Fix spelling (first suggestion) |
| `<leader>sa` | n | Add word to dictionary |
| `<leader>sr` | n | Mark word as wrong |
| `<leader>su` | n | Undo add to dictionary |
| `<leader>ss` | n | Suggest spelling corrections |

## Misc

| Key | Mode | Action |
|-----|------|--------|
| `<leader>e` | n | Open Oil file explorer |
| `<leader>o` | n | Toggle symbol outline |
| `<leader>cf` | n | Format buffer (conform) |
| `<leader>y` | n, x | Copy to system clipboard |
| `<leader>p` | n, x | Paste from system clipboard |
| `<leader>P` | n, x | Paste before from system clipboard |
| `<leader>wp` | n, x | Wrap paragraph |
| `<leader>rn` | n, x | Toggle relative line numbers |
| `<leader>?` | n | Show buffer-local keymaps (which-key) |
| `<leader>mv` | n | Toggle Markview |
| `<leader>mp` | n | Markdown preview (browser) |
| `<leader>pi` | n | Paste image from clipboard |
| `<leader>cv` | n | Toggle CSV view |
| `jk` | i | Exit insert mode |
| `gx` | n | Open URL under cursor (built-in) |

## Rust (buffer-local, ft=rust)

| Key | Mode | Action |
|-----|------|--------|
| `gra` | n | Rust code action (overrides default) |
| `K` | n | Hover (Rust-specific) |
| `grR` | n | Rename (Rust-specific) |
| `<leader>rd` | n | Open Rust docs |
| `<leader>rr` | n | Run runnables |
| `<leader>re` | n | Expand macro |
| `<leader>rc` | n | Open Cargo.toml |
| `<leader>rp` | n | Parent module |
| `gro` | n | Open external docs |

## Oil (buffer-local)

| Key | Mode | Action |
|-----|------|--------|
| `gd` | n | Toggle file detail view |

## CSV (buffer-local)

| Key | Mode | Action |
|-----|------|--------|
| `<Tab>` | n, v | Jump to next field |
| `<S-Tab>` | n, v | Jump to previous field |
| `<Enter>` | n, v | Jump to next row |
| `<S-Enter>` | n, v | Jump to previous row |
| `if` / `af` | o, x | Inner/outer field text object |
