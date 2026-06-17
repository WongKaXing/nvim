-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- 当保存任何文件时，自动执行 LSP 格式化
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*", -- 对所有文件类型生效（可改成 "*.py" 仅对 Python 生效）
  callback = function()
    pcall(vim.lsp.buf.format, { async = false })
  end,
  desc = "保存文件前自动格式化代码",
})

-- 启动时自动打开文件树
if vim.fn.argc() == 0 then
  vim.schedule(function()
    Snacks.explorer()
  end)
end
