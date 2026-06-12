# Neovim Config Improvements — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Three small config changes: auto-open file explorer on startup, simplify dashboard to header + startup time only, and cleanup stale keymaps.

**Architecture:** Pure configuration changes to existing LazyVim setup. Modify 3 files: `autocmds.lua` (add auto-open), `snacks.lua` (dashboard simplification), `keymaps.lua` (remove stale NvimTreeToggle binding). No new files or plugins.

**Tech Stack:** Lua, Neovim, LazyVim, snacks.nvim

---

### Task 1: Auto-open file explorer on startup

**Files:**
- Modify: `lua/config/autocmds.lua` — append new autocmd

- [ ] **Step 1: Add VimEnter autocmd**

Append to `lua/config/autocmds.lua`:

```lua
-- 启动时自动打开文件树
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("snacks").explorer()
  end,
  desc = "启动时自动打开文件资源管理器",
})
```

- [ ] **Step 2: Verify the edit**

Read `lua/config/autocmds.lua` to confirm the autocmd is present at end of file.

---

### Task 2: Simplify dashboard — remove menu items, keep header + startup time

**Files:**
- Modify: `lua/plugins/snacks.lua:8` — replace `dashboard = { enabled = true }`

- [ ] **Step 1: Replace dashboard config**

In `lua/plugins/snacks.lua`, change line 8 from:
```lua
dashboard = { enabled = true },
```
to:
```lua
dashboard = {
  enabled = true,
  preset = {
    header = [[
    ⠀
    ⠀
    ⠀
    ⠀
          ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
          ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
          ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
          ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
          ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           
          ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           
    ]],
    keys = {},
  },
},
```

- [ ] **Step 2: Verify the edit**

Read `lua/plugins/snacks.lua` to confirm the dashboard config is correct and the file is valid Lua.

---

### Task 3: Remove stale NvimTreeToggle keymap

**Files:**
- Modify: `lua/config/keymaps.lua:43` — remove outdated keymap

- [ ] **Step 1: Remove the NvimTreeToggle line**

In `lua/config/keymaps.lua`, delete line 43:
```lua
keymap.set("n", "<leader>E", ":NvimTreeToggle<CR>", { desc = "打开/关闭文件树" })
```

- [ ] **Step 2: Verify the edit**

Read `lua/config/keymaps.lua` to confirm the line is removed. The `-- nvim-tree` comment on line 42 can also be removed.

---

### Task 4: Restart nvim and verify

- [ ] **Step 1: Restart nvim and check dashboard**

Open nvim with no file arguments. Verify:
- Dashboard shows LazyVIM ASCII header centered/offset down
- No menu items (Find File, etc.) visible
- Startup time shown at bottom

- [ ] **Step 2: Verify auto-open file tree**

Confirm file explorer opens automatically on the left side.

- [ ] **Step 3: Verify hidden files toggle**

In the explorer, press `a` to toggle hidden files. Confirm dotfiles appear/disappear.
