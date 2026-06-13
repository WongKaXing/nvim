return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- 禁用所有 LSP server 默认的 K → hover 绑定
        ["*"] = {
          keys = {
            { "K", false },
          },
        },
        ruff = {
          enabled = true,
          autostart = true,
          init_options = {
            settings = {
              fixAll = true, -- 启用自动修复
            },
          },
        },
        pyright = {
          -- 确保 pyright 以 pyproject.toml 所在目录作为工作区根目录
          root_markers = { "pyproject.toml" },
          settings = {
            python = {
              -- 让 pyright 在项目根目录查找 .venv
              pythonPath = ".venv/bin/python",
              venvPath = ".",
              venv = ".venv",
            },
          },
        },
      },
    },
  },
}
