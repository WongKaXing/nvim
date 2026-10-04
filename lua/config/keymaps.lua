-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- be like
-- keymap.set("mode","ur_keymap", "command", {desc = "注释"})

-- <leader>键位改为空格键
vim.g.mapleader = " "

local keymap = vim.keymap

-- ---------- 插入模式 ---------- ---
-- 连续摁`jk`退出插入模式
-- keymap.set("i", "jk", "<ESC>")
keymap.set("i", "jk", "<Esc>")
-- 终端模式同样用 jk 退出
keymap.set("t", "jk", "<C-\\><C-n>")

-- Cmd+V 粘贴（系统剪贴板）
keymap.set("i", "<D-v>", '<C-o>"+p', { desc = "粘贴" })

-- ---------- 视觉模式 ---------- ---

-- Cmd+V 从系统剪贴板粘贴
keymap.set("n", "<D-v>", '"+p', { desc = "粘贴" })

-- Cmd+C 复制到系统剪贴板
keymap.set("v", "<D-c>", '"+y', { desc = "复制" })

-- ---------- 正常模式 ---------- ---
-- cw 改为 ciw：光标在单词任意位置都能改写整个单词
keymap.set("n", "cw", "ciw", { desc = "改写整个单词" })

-- vw 改为 viw：光标在单词任意位置都能选中整个单词（不带后面的空格）
keymap.set("n", "vw", "viw", { desc = "选中整个单词" })

-- yw 改为 yiw：光标在单词任意位置都能复制整个单词（不带后面的空格）
keymap.set("n", "yw", "yiw", { desc = "复制整个单词" })

-- J / K 向下/上滚动 10 行
keymap.set("n", "J", "10j", { desc = "向下移动10行" })
-- K：全局映射 + 每个 LSP buffer 里强制覆盖 hover
keymap.set("n", "K", "10k", { desc = "向上移动10行" })
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.keymap.set("n", "K", "10k", { buffer = args.buf, desc = "向上移动10行" })
  end,
})

-- 窗口
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "水平新增窗口" }) -- 水平新增窗口

-- 拷贝路径到系统剪贴板
keymap.set("n", "<leader>yf", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("📋 " .. path)
end, { desc = "拷贝当前文件路径" })

keymap.set("n", "<leader>yp", function()
  local dir = vim.fn.expand("%:p:h")
  vim.fn.setreg("+", dir)
  vim.notify("📋 " .. dir)
end, { desc = "拷贝当前路径" })

-- grn 智能回退：有支持改名的 LSP（.lua/.py 等）就用 LSP 语义改名；
-- 没有（markdown 笔记、纯文本、txt）则退回 grug-far，替换「光标下的词 / 选中的内容」，
-- 范围限定当前文件（grug-far 默认就是 --fixed-strings 字面量搜索，字符串里有正则符号也安全）
local function grn_has_lsp()
  return #vim.lsp.get_clients({ bufnr = 0, method = "textDocument/rename" }) > 0
end

local function grn_replace(word)
  word = vim.trim(word or "")
  if word == "" then
    vim.notify("grn: 光标下没有可取的内容", vim.log.levels.WARN)
    return
  end
  require("grug-far").open({
    transient = true,
    prefills = { search = word, paths = vim.fn.expand("%") },
  })
end

keymap.set("n", "grn", function()
  if grn_has_lsp() then
    return vim.lsp.buf.rename()
  end
  grn_replace(vim.fn.expand("<cword>"))
end, { desc = "重命名（无 LSP 时退回当前文件替换）" })

keymap.set("x", "grn", function()
  if grn_has_lsp() then
    return vim.lsp.buf.rename()
  end
  local saved = vim.fn.getreg("v")
  vim.cmd('noau normal! "vy')
  local text = vim.fn.getreg("v")
  vim.fn.setreg("v", saved)
  grn_replace(text)
end, { desc = "重命名（无 LSP 时退回当前文件替换）" })

-- -- ---------- 位置锚点（不管怎么移动都能一键回来） ---------- ---
-- -- 用法：在第 20 行按 \ 钉住 -> 跳到第 15 行某字符处复制/删改 -> 再按 \ 一键飞回第 20 行
-- -- 再按一次会飞回刚才离开的地方（两点之间来回跳）；| 把锚点重新钉在当前光标处
-- -- 注：内置的 <C-o> 只记得「跳转类」移动（15G / gg / } / 搜索 / mark），
-- --     15k、5k、f 这类相对移动，以及 :15 这类 Ex 行号命令都不进跳跃表，所以才要这个锚点
-- local ANCHOR_MARK = "z" -- 用缓冲区本地标记 z 存锚点，上方增删行时会跟着文字走（:marks 里能看到）
--
-- local function anchor_get()
--   local m = vim.api.nvim_buf_get_mark(0, ANCHOR_MARK)
--   return (m[1] and m[1] > 0) and m or nil
-- end
--
-- local function anchor_set(pos)
--   vim.api.nvim_buf_set_mark(0, ANCHOR_MARK, pos[1], pos[2], {})
-- end
--
-- local function anchor_goto(pos)
--   local buf = vim.api.nvim_get_current_buf()
--   local row = math.max(1, math.min(pos[1], vim.api.nvim_buf_line_count(buf)))
--   local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1] or ""
--   local col = math.max(0, math.min(pos[2], math.max(#line - 1, 0)))
--   vim.api.nvim_win_set_cursor(0, { row, col })
--   vim.cmd("normal! zz") -- 目标行居中，方便看清上下文
-- end

-- nowait 说明：LazyVim 的 localleader 也是 \，它在 lua 文件里还留了个 <localleader>r
-- （Run Lua）；不加 nowait 的话，按 \ 会先等 1 秒看你是不是要补一个 r
-- keymap.set("n", "\\", function()
--   local here = vim.api.nvim_win_get_cursor(0)
--   local anchor = anchor_get()
--   if anchor then
--     anchor_set(here) -- 锚点换成离开的位置，实现两点之间来回跳
--     anchor_goto(anchor)
--     vim.notify(
--       ("📌 回到 %d:%d（再按一次飞回 %d:%d）"):format(anchor[1], anchor[2] + 1, here[1], here[2] + 1)
--     )
--   else
--     anchor_set(here)
--     vim.notify(("📌 已钉住 %d:%d，再按 \\ 飞回"):format(here[1], here[2] + 1))
--   end
-- end, { desc = "位置锚点：钉住 / 飞回", nowait = true })
--
-- keymap.set("n", "|", function()
--   local here = vim.api.nvim_win_get_cursor(0)
--   anchor_set(here)
--   vim.notify(("📌 锚点重设在 %d:%d"):format(here[1], here[2] + 1))
-- end, { desc = "位置锚点：重设到当前处" })

-- 拔掉 \ 的「前缀冲突」：LazyVim 在 lua 文件里绑了 <localleader>r = Run Lua（localleader 也是 \），
-- 有它在，按 \ 时 Vim 会先等 timeoutlen(1000ms) 看你要不要补个 r —— 这就是"跳转要等一下"的原因。
-- 这里把 Run Lua 挪到 <leader>rr，并删掉 lua 缓冲区里的 \r，让 \ 在任何文件里都立刻触发。
-- local function fix_lua_localleader_r(buf)
--   buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
--   if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].filetype ~= "lua" then
--     return
--   end
--   keymap.set({ "n", "x" }, "<leader>rr", function()
--     Snacks.debug.run()
--   end, { buffer = buf, desc = "Run Lua" })
--   for _, mode in ipairs({ "n", "x" }) do
--     pcall(keymap.del, mode, "\\r", { buffer = buf })
--   end
-- end
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "lua",
--   callback = function(args)
--     fix_lua_localleader_r(args.buf)
--   end,
-- })
-- fix_lua_localleader_r(0) -- 启动时就已经打开着 lua 文件的情况

-- ---------- undo keymaps ---------- ---
-- keymap.del("n", "<leader>-") -- 取消分屏键

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

-- ---------- 插件 ---------- ---
keymap.set("n", "<D>h", "<C-w>h", { desc = "焦点移到左侧文件树" })
keymap.set("n", "<D>l", "<C-w>l", { desc = "焦点移到右侧Outline" })

-- Twilight
keymap.set("n", "<leader>tw", ":Twilight<CR>", { desc = "开启Twilight专注模式" })

-- yazi
keymap.set("n", "<leader>ya", "<cmd>Yazi cwd<cr>", { desc = "打开nvim工作目录中的文件管理器" })

-- markdownperview
keymap.set("n", "<leader>mm", ":MarkdownPreview<CR>", { desc = "开启Markdown预览" })
keymap.set("n", "<leader>ms", ":MarkdownPreviewStop<CR>", { desc = "关闭Markdown预览" })
keymap.set("n", "<leader>mt", ":MarkdownPreviewToggle<CR>", { desc = "切换Markdown预览" })

-- gf (goto file): 打开光标下的引用文件
-- 内置: gf=当前窗口, <C-w>gf=新标签
keymap.set("n", "<leader>gf", "<C-w>gf", { desc = "新标签打开引用文件" })

-- 浮动终端（桌面中央，用于调试）
keymap.set("n", "<leader>tt", function()
  local term, created = Snacks.terminal.get(nil, {
    win = {
      position = "float",
      width = 0.8,
      height = 0.8,
      row = 0.1,
      col = 0.1,
      enter = true,
      backdrop = false,
      wo = { winblend = 14 },
    },
  })
  if created then
    vim.schedule(function()
      vim.wo[term.win].winblend = 10
      term:focus()
    end)
  else
    term:toggle()
    if term:valid() then
      term:focus()
    end
  end
end, { desc = "切换调试终端（桌面中央）" })
