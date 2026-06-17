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
-- 单行或多行移动
-- keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Cmd+V 从系统剪贴板粘贴
keymap.set("n", "<D-v>", '"+p', { desc = "粘贴" })

-- Cmd+C 复制到系统剪贴板
keymap.set("v", "<D-c>", '"+y', { desc = "复制" })

-- ---------- 正常模式 ---------- ---
-- J / K 向下/上滚动 15 行
keymap.set("n", "J", "15j", { desc = "向下移动15行" })
keymap.set("n", "K", "15k", { desc = "向上移动15行" })

-- 窗口
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "水平新增窗口" }) -- 水平新增窗口
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "垂直新增窗口" }) -- 垂直新增窗口

-- 编辑区 与 浮动终端 之间焦点切换
keymap.set("n", "<leader>th", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local cfg = vim.api.nvim_win_get_config(win)
    local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
    -- 仅普通分屏窗口（relative=""），排除终端和Outline
    if cfg.relative == "" and ft ~= "snacks_terminal" and ft ~= "Outline" then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
end, { desc = "焦点回到编辑区" })

keymap.set("n", "<leader>tl", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "snacks_terminal" then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
end, { desc = "焦点到浮动终端" })

-- 字符串搜索后的取消高亮
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "字符串搜索后的取消高亮" })

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
-- k ymap.set("n", "<leader>yi", "<cmd>Yazi<cr>", { desc = "在当前文件中打开yazi" })
-- keymap.set("v", "<leader>yi", "<cmd>Yazi<cr>", { desc = "在当前文件中打开yazi" })
keymap.set("n", "<leader>ya", "<cmd>Yazi cwd<cr>", { desc = "打开nvim工作目录中的文件管理器" })
keymap.set("n", "<leader>yz", "<cmd>Yazi toggle<cr>", { desc = "继续上次yazi会话" })

-- markdownperview
keymap.set("n", "<leader>mm", ":MarkdownPreview<CR>", { desc = "MarkdownPreview" })
keymap.set("n", "<leader>ms", ":MarkdownPreviewStop<CR>", { desc = "MarkdownPreviewStop" })
keymap.set("n", "<leader>mt", ":MarkdownPreviewToggle<CR>", { desc = "MarkdownPreviewToggle" })

-- gf (goto file): 打开光标下的引用文件
-- 内置: gf=当前窗口, <C-w>gf=新标签
keymap.set("n", "<leader>gf", "<C-w>gf", { desc = "新标签打开引用文件" })

-- 浮动终端（右侧半屏，自动关闭/恢复Outline）
keymap.set("n", "<leader>tm", function()
  local term, created = Snacks.terminal.get(nil, {
    win = {
      position = "float",
      width = 0.5,
      height = 0,
      row = 0,
      col = 0.5,
      enter = true,
      backdrop = false,
    },
  })

  if created then
    local augroup = vim.api.nvim_create_augroup("TermOutline", { clear = true })
    vim.api.nvim_create_autocmd("BufWinEnter", {
      group = augroup,
      buffer = term.buf,
      callback = function()
        vim.cmd("OutlineClose")
      end,
    })
    vim.api.nvim_create_autocmd("WinClosed", {
      group = augroup,
      buffer = term.buf,
      callback = function()
        -- 先记下编辑区窗口
        local editor_win
        for _, w in ipairs(vim.api.nvim_list_wins()) do
          local cfg = vim.api.nvim_win_get_config(w)
          local ft = vim.bo[vim.api.nvim_win_get_buf(w)].filetype
          if cfg.relative == "" and ft ~= "snacks_terminal" and ft ~= "Outline" then
            editor_win = w
            break
          end
        end
        vim.schedule(function()
          vim.cmd("OutlineOpen")
          if editor_win and vim.api.nvim_win_is_valid(editor_win) then
            vim.defer_fn(function()
              if vim.api.nvim_win_is_valid(editor_win) then
                vim.api.nvim_set_current_win(editor_win)
              end
            end, 50)
          end
        end)
      end,
    })
    -- OutlineClose 可能导致焦点跳转，手动聚焦回终端
    vim.cmd("OutlineClose")
    vim.schedule(function()
      term:focus()
    end)
  else
    term:toggle()
    if term:valid() then
      term:focus()
    end
  end
end, { desc = "切换浮动终端（右侧半屏）" })
