return {
  {
    "folke/tokyonight.nvim",
    lazy = false, -- 不延迟加载
    priority = 1000, -- 确保优先加载
    opts = {
      style = "moon", -- 默认主体变体
      transparent = true, -- 背景透明（终端控制具体透明度）
      terminal_colors = true, -- 同步终端颜色
    },
    init = function()
      -- transparent = true 只让编辑区透明：浮动窗口、补全菜单、状态栏这些「界面部件」
      -- 仍然带着底色（leader+e 打开的文件管理器、Lazy UI、blink 补全菜单等）。
      -- 这里把它们一并清成透明，做到整屏无底色。
      -- 表示状态的底色（光标行、选区、补全选中项、折叠行）保留，否则看不出状态。
      local groups = {
        -- 浮动窗口
        "NormalFloat", "NormalSB", "FloatBorder", "FloatTitle", "FloatFooter",
        "FloatShadow", "FloatShadowThrough",
        -- 弹出菜单
        "Pmenu", "PmenuMatch",
        -- 状态栏 / 窗口栏 / 标签栏
        "StatusLine", "StatusLineNC", "WinBar", "WinBarNC",
        "TabLine", "TabLineFill", "TabLineSel", "MsgArea", "MsgSeparator",
        -- blink.cmp 的补全菜单 / 悬浮文档 / 签名帮助
        "BlinkCmpMenu", "BlinkCmpMenuBorder", "BlinkCmpDoc", "BlinkCmpDocBorder",
        "BlinkCmpSignatureHelp", "BlinkCmpSignatureHelpBorder",
        -- snacks 的 explorer / picker 边框与标题
        "SnacksPickerBoxBorder", "SnacksPickerListBorder", "SnacksPickerInputBorder",
        "SnacksPickerBoxTitle", "SnacksPickerListTitle", "SnacksPickerInputTitle",
        "SnacksTitle",
        -- which-key：leader 键呼出的菜单（窗口 winhl 是 Normal:WhichKeyNormal）
        "WhichKeyNormal",
        -- trouble 的列表窗口（<leader>xx 等）、侧边栏符号列、:LspInfo 的边框
        "TroubleNormal", "SignColumnSB", "LspInfoBorder",
      }
      -- 前缀匹配：lualine 的全部状态栏高亮（各模式、各段、段间过渡色），
      -- 以及 trouble 复制进状态栏的计数高亮
      local prefixes = { "^lualine_", "^TroubleStatusline" }

      local function wanted(name)
        for _, prefix in ipairs(prefixes) do
          if name:match(prefix) then
            return true
          end
        end
        return vim.tbl_contains(groups, name)
      end

      -- 「彩底深字」的组（状态栏模式块、当前标签页）：底色去掉后深色字会看不见，
      -- 所以把字色换成原来的底色，变成彩字 + 透明底
      local function bg_as_fg(name)
        return name == "TabLineSel" or (name:match("^lualine_a_") and name ~= "lualine_a_inactive")
      end

      local function strip_ui_bg()
        for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
          if wanted(name) and hl.bg then
            if bg_as_fg(name) then
              hl.fg = hl.bg
              hl.ctermfg = nil
            end
            hl.bg = "NONE"
            hl.ctermbg = nil
            hl.default = nil
            vim.api.nvim_set_hl(0, name, hl)
          end
        end
      end

      -- 状态栏（lualine）到 VeryLazy 才加载、换主题时又会重新写入高亮，
      -- 所以这几个时机都要再清一遍；schedule 保证跑在插件自己的处理之后
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          vim.schedule(strip_ui_bg)
        end,
      })
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.schedule(strip_ui_bg)
        end,
      })
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          vim.schedule(strip_ui_bg)
        end,
      })
    end,
    -- config = function(_, opts)
    --   require("tokyonight").setup(opts)
    --   vim.cmd.colorscheme("tokyonight") -- 应用主题
    -- end,
  },
}
