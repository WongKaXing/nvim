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

-- ---------- 视觉模式 ---------- ---
-- 单行或多行移动
-- keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- ---------- 正常模式 ---------- ---
-- 窗口
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "水平新增窗口" }) -- 水平新增窗口
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "垂直新增窗口" }) -- 垂直新增窗口

-- 字符串搜索后的取消高亮
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "字符串搜索后的取消高亮" })

-- 切换buffer
keymap.set("n", "<C-L>", ":bnext<CR>", { desc = "切换左侧buffer" })
keymap.set("n", "<C-H>", ":bprevious<CR>", { desc = "切换右侧buffer" })

-- ---------- undo keymaps ---------- ---
-- keymap.del("n", "<leader>-") -- 取消分屏键

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

-- ---------- 插件 ---------- ---
-- nvim-tree
keymap.set("n", "<leader>E", ":NvimTreeToggle<CR>", { desc = "打开/关闭文件树" })
keymap.set("n", "<S-h>", "<C-w>h", { desc = "向左移动焦点" })
keymap.set("n", "<S-l>", "<C-w>l", { desc = "向右移动焦点" })
keymap.set("n", "<S-k>", "<C-w>k", { desc = "向上移动焦点" })

-- Twilight
keymap.set("n", "<leader>tw", ":Twilight<CR>", { desc = "开启Twilight专注模式" })

-- yazi
-- k ymap.set("n", "<leader>yi", "<cmd>Yazi<cr>", { desc = "在当前文件中打开yazi" })
-- keymap.set("v", "<leader>yi", "<cmd>Yazi<cr>", { desc = "在当前文件中打开yazi" })
keymap.set("n", "<leader>ya", "<cmd>Yazi cwd<cr>", { desc = "打开nvim工作目录中的文件管理器" })
keymap.set("n", "<leader>yz", "<cmd>Yazi toggle<cr>", { desc = "继续上次yazi会话" })

-- markdownperview

keymap.set("n", "<leader>mm", ":MarkdownPreview<CR>", { desc = "MarkdownPreview" })
keymap.set("n", "<leader>ms", ":MarkdownPreviewStop<CR>", { desc = "MarkdownPreviewStop" })
keymap.set("n", "<leader>mt", ":MarkdownPreviewToggle<CR>", { desc = "MarkdownPreviewToggle" })

-- bufferline
-- 你可以通过点击关闭图标或右键点击任意标签来关闭缓冲区
vim.opt.termguicolors = true
require("bufferline").setup({})
