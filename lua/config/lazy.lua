local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import/override with your plugins
    -- 注意：lazy 的 import 不会自动进子目录（util.lua 的 lsmod 只在子目录有 init.lua 时才进），
    -- 所以每个分类目录都要在这里显式列一行。新增分类目录时记得补上。
    { import = "plugins" }, -- 顶层散装文件（留给临时试验）
    { import = "plugins.edit" }, -- 编辑与补全
    { import = "plugins.lsp" }, -- 语言支持（LSP / treesitter）
    { import = "plugins.markdown" }, -- Markdown 全家桶
    { import = "plugins.notes" }, -- 笔记
    { import = "plugins.tools" }, -- 外部工具集成
    { import = "plugins.ui" }, -- 外观与界面

    { import = "VeryLazyPlugins" }, -- 以下按「VeryLazy 加载」维度分组
    { import = "VeryLazyPlugins.markdown" },
    { import = "VeryLazyPlugins.tools" },
    { import = "VeryLazyPlugins.ui" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = false, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
