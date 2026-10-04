-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- 保存文件时自动格式化：只调用「已附加且支持格式化」的 LSP。
-- 没有 LSP 的文件（txt / conf / 没装服务器的语言）直接静默跳过，
-- 不会弹出 "no active clients" / "LSP 不存在" 之类的提示。
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    if not vim.api.nvim_buf_is_valid(args.buf) or vim.bo[args.buf].buftype ~= "" then
      return
    end
    local clients = vim.lsp.get_clients({ bufnr = args.buf, method = "textDocument/formatting" })
    if #clients == 0 then
      return
    end
    pcall(vim.lsp.buf.format, { bufnr = args.buf, async = false })
  end,
  desc = "保存文件前自动格式化代码（无 LSP 时静默跳过）",
})

-- Python 文件关闭 inlay hints（隐藏 -> None 等返回类型提示）
-- 注意：LspAttach 的 pattern 匹配的是「缓冲区文件名」而不是文件类型，
-- 所以这里用 callback 判断 filetype（原写法 pattern = "python" 永远不会命中）。
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    if vim.bo[args.buf].filetype == "python" then
      vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
    end
  end,
  desc = "Python: 关闭 inlay hints",
})

-- 启动时自动打开文件树
if vim.fn.argc() == 0 then
  vim.schedule(function()
    Snacks.explorer()
  end)
end
