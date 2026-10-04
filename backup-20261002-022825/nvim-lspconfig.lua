return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      -- 禁用 LSP 进度提示（右下角不再弹 basedpyright）
      vim.lsp.handlers["$/progress"] = function() end
    end,
    opts = {
      -- 覆盖 LazyVim 默认的诊断配置：只显示 error 和 warning，隐藏 hint
      diagnostics = {
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
          severity = { min = vim.diagnostic.severity.WARN },
        },
      },
      servers = {
        ["*"] = {
          keys = {
            { "K", false },                                          -- 禁用默认 K hover
            { "<leader>K", vim.lsp.buf.hover, desc = "悬停信息" },     -- hover 移到 <leader>K
          },
        },
        -- cspell_ls: 指定 node 路径，修复 macOS GUI app PATH 继承问题
        cspell_ls = {
          cmd = { "/Users/soc/.nvm/versions/node/v22.14.0/bin/node", vim.fn.stdpath("data") .. "/mason/packages/cspell-lsp/node_modules/@vlabo/cspell-lsp/dist/cspell-lsp.js", "--stdio" },
        },
        ruff = {
          enabled = true,
          autostart = true,
          init_options = {
            settings = {
              fixAll = true, -- 启用自动修复
              -- 关键配置：禁用Ruff的Lint 功能
              lint = { enabled = false },
            },
          },
        },
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "off", -- 只报错，不报 hint 警告
                inlayHints = {
                  functionReturnTypes = false, -- 不显示 -> None 等返回类型
                  callArgumentNames = false, -- 不显示参数名提示
                  variableTypes = false, -- 不显示变量类型提示
                },
              },
            },
          },
        },
      },
    },
  },
}
