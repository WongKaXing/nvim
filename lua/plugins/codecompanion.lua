-- CodeCompanion：本地大模型 AI 助手（Ollama 远程 Debian；离线安装版）
-- :CodeCompanionChat 对话 | :CodeCompanionInline 内联生成
return {
  {
    dir = "~/.local/share/nvim/lazy/codecompanion.nvim",
    name = "codecompanion.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      adapters = {
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            env = { url = "http://100.67.58.98:11434" },
            model = "qwen2.5-coder:14b",
          })
        end,
      },
      strategies = {
        chat = { adapter = "ollama" },
        inline = { adapter = "ollama" },
      },
    },
    keys = {
      { "<leader>ac", "<cmd>CodeCompanionChat<CR>", desc = "CodeCompanion 对话" },
      { "<leader>ai", "<cmd>CodeCompanionInline<CR>", desc = "CodeCompanion 内联生成" },
    },
  },
}
