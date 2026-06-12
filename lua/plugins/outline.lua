-- return {
--   {
--     "hedyhli/outline.nvim",
--     lazy = true, -- 不延迟加载
--     config = function()
--       -- Example mapping to toggle outline
--       vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", {
--         desc = "Toggle Outline",
--       })
--
--       require("outline").setup({
--         -- Your setup opts here (leave empty to use defaults)
--       })
--     end,
--   },
-- }

-- 自动开启outline大纲视图配置代码

return {
  {
    "hedyhli/outline.nvim",
    lazy = false,
    keys = {
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle Outline" },
    },
    config = function()
      require("outline").setup()

      local group = vim.api.nvim_create_augroup("AutoOutline", { clear = true })
      vim.api.nvim_create_autocmd("BufEnter", {
        group = group,
        callback = function()
          local ft = vim.bo.filetype
          if vim.bo.buftype == "" and ft ~= "" and ft ~= "snacks_dashboard" then
            vim.schedule(function()
              local win = vim.api.nvim_get_current_win()
              vim.cmd("OutlineOpen")
              vim.schedule(function()
                vim.api.nvim_set_current_win(win)
              end)
            end)
            vim.api.nvim_del_augroup_by_id(group)
          end
        end,
        desc = "首次进入文件缓冲区时自动打开大纲视图",
      })
    end,
  },
}
