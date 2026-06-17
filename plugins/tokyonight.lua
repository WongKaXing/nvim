return {
  {
    "folke/tokyonight.nvim",
    lazy = false, -- 不延迟加载
    priority = 1000, -- 确保优先加载
    opts = {
      style = "moon", -- 默认主体变体
      terminal_colors = true, -- 同步终端颜色
    },
    -- config = function(_, opts)
    --   require("tokyonight").setup(opts)
    --   vim.cmd.colorscheme("tokyonight") -- 应用主题
    -- end,
  },
}
