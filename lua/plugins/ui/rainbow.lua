-- 彩虹括号：按嵌套深度给 () [] {} 轮流上色，长表达式不容易数错层。
--
-- 跟 LSP / 补全无关，纯 treesitter 干的活：插件自带 queries/<语言>/
-- rainbow-delimiters.scm，说明「哪些节点算一对括号」，再按层数套
-- RainbowDelimiter* 高亮组。所以语言只要装了 treesitter 解析器就会生效
-- （python 的 python.so 已由 LazyVim 默认装在 site/parser/ 下）。
--
-- 加载方式：不延迟。插件只做「注册几个 autocmd + 定义 7 个高亮组」，开销可忽略；
-- 改成 event = "VeryLazy" 会有副作用——启动时命令行打开的第一个缓冲区，FileType
-- 早于插件加载，那份文件不会挂上彩虹括号。
--
-- 配色：取 tokyonight moon 的调色板（与 lua/plugins/ui/tokyonight.lua 同款），
-- 按「嵌套层数」循环使用。顺序是蓝 → 橙 → 绿 → 紫 → 青 → 黄 → 红，相邻层对比强，
-- 且第一层用蓝不用红（红色留给报错）。
-- 注意：换主题时 :hi clear 会把这些组清空，插件随后用自带的 gruvbox 色补回来，
-- 所以挂 ColorScheme 事件再写一遍。

local enabled = true

local palette = {
  Blue = "#82aaff",
  Orange = "#ff966c",
  Green = "#c3e88d",
  Violet = "#c099ff",
  Cyan = "#86e1fc",
  Yellow = "#ffc777",
  Red = "#ff757f",
}

local order = { "Blue", "Orange", "Green", "Violet", "Cyan", "Yellow", "Red" }

-- 写高亮组，并返回「层数 → 组名」的列表（插件按这个列表循环取色）
local function apply_colors()
  local groups = {}
  for i, name in ipairs(order) do
    local group = "RainbowDelimiter" .. name
    vim.api.nvim_set_hl(0, group, { fg = palette[name] })
    groups[i] = group
  end
  return groups
end

return {
  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      require("rainbow-delimiters.setup").setup({
        -- 这里的名字是 treesitter 语言名，不是 filetype。
        -- 纯文字的文件不挂：markdown 笔记里的 [[双链]]、[文字](链接) 会变得很花。
        blacklist = {
          "markdown",
          "markdown_inline",
          "rst",
          "text",
          "help",
          "vimdoc",
          "gitcommit",
          "gitrebase",
        },
        -- 全局开关：关掉后新打开的文件也不再挂
        condition = function()
          return enabled
        end,
        highlight = apply_colors(),
      })

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = apply_colors,
        desc = "彩虹括号：换主题后重新套 tokyonight 的颜色",
      })

      -- 全局开关：已打开的缓冲区逐个启用/禁用，之后新开的由 condition 管住
      local function set_enabled(state)
        enabled = state
        local rainbow = require("rainbow-delimiters")
        local rb_config = require("rainbow-delimiters.config")
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
            if not state then
              rainbow.disable(buf)
            else
              local ft = vim.bo[buf].ft
              local lang = ft ~= "" and vim.treesitter.language.get_lang(ft) or nil
              -- 走一遍插件自己的白/黑名单判断，免得开关一开把 markdown 也点亮了
              if lang and rb_config.enabled_for(lang) then
                rainbow.enable(buf)
              end
            end
          end
        end
      end

      require("snacks").toggle({
        -- id 必须是 ASCII：Snacks 用它当 toggles 表的键，中文名会被 gsub 成空串
        id = "rainbow_brackets",
        name = "彩虹括号",
        get = function()
          return enabled
        end,
        set = set_enabled,
        wk_desc = { enabled = "关闭", disabled = "开启" },
        notify = function(state)
          vim.notify("彩虹括号：" .. (state and "开启" or "关闭"), vim.log.levels.INFO)
        end,
      }):map("<leader>uR", { desc = "彩虹括号开关" })
    end,
  },
}
