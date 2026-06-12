# Neovim Config Improvements Design

## Overview

Three configuration changes to the LazyVim-based Neovim setup:
1. Document hidden files toggle shortcut in file explorer
2. Auto-open file tree on startup
3. Simplify startup dashboard to show only ASCII header + startup time

## Files to Change

### 1. `lua/config/autocmds.lua` — Auto-open file tree

Add autocmd to open snacks explorer on VimEnter:

```lua
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("snacks").explorer()
  end,
  desc = "Auto-open file explorer on startup",
})
```

### 2. `lua/plugins/snacks.lua` — Simplified dashboard

Override dashboard preset in the snacks opts table. Replace the existing `dashboard = { enabled = true }` line (line 8) with:

```lua
dashboard = {
  enabled = true,
  preset = {
    header = [[
    ...
    (LazyVim ASCII art with 4 blank lines above for vertical centering)
    ...
    ]],
    keys = {},
  },
},
```

Effect: No menu items displayed, only LazyVim pixel header and startup time at bottom.

### 3. `lua/config/keymaps.lua` — Cleanup stale keymap

Remove the `NvimTreeToggle` keymap (lines 43) since nvim-tree is not installed. The file explorer is already mapped to `<leader>e` in snacks.lua.

## Hidden Files Shortcut

Snacks explorer built-in: press `a` inside the explorer to toggle hidden (dot) files. No config change needed.

## Design Decisions

- **No new plugins**: All changes use existing snacks.nvim capabilities
- **Empty keys = clean dashboard**: Setting `keys = {}` in the dashboard preset removes menu items while keeping header and footer
- **Header padding**: Blank lines above ASCII art push it down for visual balance; user can adjust count later
