-- Obsidian 笔记库（Mac / Debian 通用写法）
-- 库路径按当前机器解析；如果这台机器上没有这个 vault，就直接禁用插件，
-- 避免打开 markdown 时报 "FileNotFoundError: /Users/soc/Documents/Notes"
-- （旧配置把 Mac 的绝对路径写死，Debian 上一开 md 就报错）。
local vault = vim.fn.expand("~/Documents/Notes")

return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  enabled = vim.fn.isdirectory(vault) == 1,
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = vault,
      },
    },

    -- 关键：不要在保存时自动改写 YAML frontmatter。
    -- obsidian.nvim 默认挂了 BufWritePre 钩子，每次 :w 都会往文件头部补
    -- `id:` / `aliases:` / `tags:`，会污染手写的 YAML，也会把 Excalidraw
    -- 绘图（.excalidraw.md）的 `excalidraw-plugin: parsed` 冲掉。
    -- 关掉后 nvim 完全不动 md 的 frontmatter。
    disable_frontmatter = true,

    -- see below for full list of options 👇
  },
}
