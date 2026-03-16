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
