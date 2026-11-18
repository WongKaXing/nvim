return {
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    -- dependencies = { "folke/snacks.nvim", lazy = true },
    -- 这行命令导致snacks报错，现注释掉，为见到异样
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        "<leader>-",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "在当前文件中打开yazi",
      },
      {
        -- Open in the current working directory
        "<leader>cw",
        "<cmd>Yazi cwd<cr>",
        desc = "在nvim工作目录中打开文件管理器",
      },
      {
        "<c-up>",
        "<cmd>Yazi toggle<cr>",
        desc = "恢复上次yazi会话",
      },
    },
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    },
    -- 👇 if you use `open_for_directories=true`, this is recommended
    init = function()
      -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
      -- vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
  },
}
