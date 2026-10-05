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

    -- see below for full list of options 👇
  },
}
