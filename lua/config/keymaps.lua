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
-- <C-w>v = 竖着切一刀 → 左右两个窗口；<C-w>s = 横着切一刀 → 上下两个窗口
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "垂直分屏（左右）" })
-- 关闭分屏放在窗口组（w），别占用 <leader>sk —— 那是 snacks 的「快捷键查询器」
keymap.set("n", "<leader>wq", "<C-w>c", { desc = "关闭当前分屏" })

-- 拷贝路径到系统剪贴板
keymap.set("n", "<leader>yf", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("cp: " .. path)
end, { desc = "拷贝当前文件路径" })

keymap.set("n", "<leader>yp", function()
  local dir = vim.fn.expand("%:p:h")
  vim.fn.setreg("+", dir)
  vim.notify("cp: " .. dir)
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

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

-- ---------- 插件 ---------- ---
keymap.set("n", "<D>h", "<C-w>h", { desc = "焦点移到左侧文件树" })
keymap.set("n", "<D>l", "<C-w>l", { desc = "焦点移到右侧Outline" })

-- yazi
keymap.set("n", "<leader>ya", "<cmd>Yazi cwd<cr>", { desc = "打开nvim工作目录中的文件管理器" })

-- markdown 侧边预览（md-render.nvim）：竖向分屏「源码 | 渲染」并排
-- 已有渲染窗口时再按一次关掉（b:md_render 是插件给渲染缓冲区打的标记）
keymap.set("n", "<leader>mv", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.b[vim.api.nvim_win_get_buf(win)].md_render then
      if #vim.api.nvim_list_wins() > 1 then
        vim.api.nvim_win_close(win, true)
      end
      return
    end
  end
  vim.cmd("vert MdRender split")
end, { desc = "侧边Markdown预览（竖向分屏）" })

-- markdown 浮动窗口预览（md-render.nvim）
keymap.set("n", "<leader>mp", "<cmd>MdRender float<cr>", { desc = "浮动Markdown预览" })

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
end, { desc = "浮动终端（桌面中央）" })

-- ---------- 清理：删掉用不到的默认键位 ---------- ---
-- 清单来源：按 nvim-leader-keymaps.md 里筛过的表 ——「表里还保留的 = 要删，已被删掉的 = 要留」。
-- 只写 <leader> 后面的部分，每个键在 n / v / x / t 各模式都删一遍。
-- 整块注释掉即可全部恢复。
local drop_keys = {
  -- 单键 / 符号
  ",", "-", ".", "/", ":", "E", "K", "L", "N", "S", "Z", "`", "n", "z",
  -- 缓冲区（b 组）
  "bD", "bP", "bb", "bd", "bi", "bj", "bl", "bo", "bp", "br",
  -- 代码 / LSP（c 组）
  "cR", "cS", "cd", "cs", "cw",
  -- 查找（f 组）
  "fB", "fE", "fF", "fR", "fT", "fb", "fc", "fe", "fg", "fn", "fp", "fr", "ft",
  -- Git（g 组）
  "gD", "gG", "gL", "gS", "gb", "gd", "gf", "gg", "gl", "gs",
  -- 搜索列表（s 组）
  's"', "s/", "sB", "sC", "sD", "sG", "sH", "sM", "sR", "sS", "sT",
  -- 注意：sk 不在清单里 —— 它是 snacks 的「快捷键查询器」，保留
  "sa", "sb", "sc", "sd", "sh", "si", "sj", "sl", "sm", "sp", "sq", "sr", "ss", "st", "su",
  -- 界面开关（u 组）
  "uA", "uC", "uD", "uF", "uI", "uL", "uS", "uT", "uZ", "ua", "ub", "uc", "ud",
  "uf", "ug", "uh", "ui", "ul", "un", "up", "ur", "us", "uw", "uz",
  -- 窗口
  "wm", "wq",
  -- 诊断 / 列表（x 组）
  "xL", "xQ", "xT", "xX", "xl", "xq", "xt", "xx",
  -- 以下为上一轮已删的开发向键位，保留在清单里以便整块恢复
  "dpp", "dps", "dph",
  "sn", "sna", "snd", "snh", "snl", "snt",
  "qs", "qS", "ql", "qd",
  "<Tab><Tab>", "<Tab>[", "<Tab>]", "<Tab>d", "<Tab>f", "<Tab>l", "<Tab>o",
  "gi", "gI", "gp", "gP", "gB", "gY",
}

local function drop_keys_now()
  for _, k in ipairs(drop_keys) do
    for _, mode in ipairs({ "n", "v", "x", "t" }) do
      pcall(vim.keymap.del, mode, "<leader>" .. k)
    end
  end
end

-- 这些键位都是各插件 spec 在启动 / VeryLazy 阶段注册的，schedule 一帧后统一删
vim.schedule(drop_keys_now)

-- 菜单里显示的名字（分组名 / 键位描述）统一在 lua/plugins/ui/which-key.lua 里改成中文，
-- 空分组（<leader>b / <leader>u）也在那里隐藏。
