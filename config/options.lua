-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- 主题 使用 tokyonight
vim.g.tokyonight_style = "moon" -- storm, moon, night, day
vim.g.tokyonight_transparent = true

-- 行号
opt.relativenumber = true
opt.number = true

-- 缩进
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- 软换行（长行自动折行显示，不修改实际内容）
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.showbreak = "↪ "

-- 光标行
opt.cursorline = true

-- 启用鼠标
opt.mouse:append("a")

-- 系统剪贴板
opt.clipboard:append("unnamedplus")

-- 默认新窗口右和下
opt.splitright = true
opt.splitbelow = true

-- 按键超时 (默认 1000ms)
opt.timeoutlen = 1000

-- 不区分大小写搜索
opt.ignorecase = true
opt.smartcase = true

-- 外观
opt.termguicolors = true
opt.signcolumn = "yes"

-- gf (goto file): 智能打开光标下的文件路径
opt.suffixesadd:append({ ".lua", ".ts", ".tsx", ".js", ".jsx", ".py", ".go", ".rs", ".c", ".h", ".cpp", ".hpp", ".css", ".scss", ".json", ".yaml", ".yml", ".toml", ".md", ".vim", ".sh", ".bash", ".zsh" })
opt.path:append("**")
vim.opt.includeexpr = "v:lua.require'tools.gf'.includeexpr()"
