-- return {
--   {
--     "hedyhli/outline.nvim",
--     lazy = true, -- 不延迟加载
--     config = function()
--       -- Example mapping to toggle outline
--       vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", {
--         desc = "切换大纲视图",
--       })
--
--       require("outline").setup({
--         -- Your setup opts here (leave empty to use defaults)
--       })
--     end,
--   },
-- }

return {
  {
    "hedyhli/outline.nvim",
    cmd = "Outline",
    keys = {
      {
        "<leader>o",
        function()
          local outline = require("outline")
          if outline.is_open() then
            outline.close()
            return
          end
          -- 检查是否有支持 documentSymbol 的 LSP 已 attach
          for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
            if c.server_capabilities.documentSymbolProvider then
              outline.open_outline()
              return
            end
          end
          -- LSP 还没就绪，延迟重试
          vim.defer_fn(function()
            for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
              if c.server_capabilities.documentSymbolProvider then
                require("outline").open_outline()
                return
              end
            end
            vim.notify("No LSP with document symbols available", vim.log.levels.WARN, { title = "Outline" })
          end, 1000)
        end,
        mode = "n",
        desc = "切换大纲视图",
      },
    },
    opts = {},
  },
}
