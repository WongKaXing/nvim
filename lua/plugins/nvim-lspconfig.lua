return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff = {
          enabled = true,
          autostart = true,
          init_options = {
            settings = {
              fixAll = true, -- 启用自动修复
            },
          },
        },
      },
    },
  },
}
