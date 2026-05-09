return {
  {
    "hedyhli/outline.nvim",
    lazy = true, -- 不延迟加载
    config = function()
      -- Example mapping to toggle outline
      vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", {
        desc = "Toggle Outline",
      })

      require("outline").setup({
        -- Your setup opts here (leave empty to use defaults)
      })
    end,
  },
}

-- 自动开启outline大纲视图配置代码

-- return {
--   {
--     "hedyhli/outline.nvim",
--     -- LazyVim 默认已配置快捷键, 你可以选择清空它们
--     keys = {},
--     config = function()
--       -- 必须调用 setup 函数
--       require("outline").setup()
--
--       -- 使用 autocmd 自动打开大纲
--       local augroup = vim.api.nvim_create_augroup("OpenOutlineOnStartup", {})
--       vim.api.nvim_create_autocmd("VimEnter", {
--         group = augroup,
--         callback = function()
--           vim.cmd("OutlineOpen")
--         end,
--         desc = "在 Neovim 启动后自动打开大纲视图",
--       })
--     end,
--   },
-- }
