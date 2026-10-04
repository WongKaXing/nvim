-- CodeCompanion：本地大模型 AI 助手（Ollama 远程 Debian；离线安装版）
-- :CodeCompanionChat 对话 | :CodeCompanionInline 内联生成
-- 注意：离线版目录必须放在 lazy 根目录（~/.local/share/nvim/lazy/）之外，
-- 否则 lazy 会把它当成受管插件，写 lazy-lock.json 时因为目录里没有 .git
-- 而中断，导致 lock 文件被截断成 "{"（2026-10-02 已修）。
return {
  {
    dir = "~/.local/share/nvim/codecompanion.nvim",
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
