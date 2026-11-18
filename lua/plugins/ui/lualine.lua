return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      -- 状态栏去掉底色（与主题的透明背景配套）：取 lualine 自己那套「auto」主题
      -- （按当前配色生成），把每个分段的背景清空。必须在主题层做，
      -- 因为 lualine 还会按分段动态生成高亮组，那些组是从主题里取色的。
      -- 模式块（a 段）原本是「彩底深字」，去掉底色后要把底色当字色，否则字看不见。
      theme = function()
        local theme = require("lualine.utils.loader").load_theme("auto")

        -- 颜色亮度（0~1），用来判断是不是「彩底深字」
        local function bright(color)
          if type(color) ~= "string" or not color:match("^#%x%x%x%x%x%x$") then
            return nil
          end
          local r = tonumber(color:sub(2, 3), 16)
          local g = tonumber(color:sub(4, 5), 16)
          local b = tonumber(color:sub(6, 7), 16)
          return (r * 2 + g * 3 + b) / 6 / 256
        end

        for _, sections in pairs(theme) do
          for name, section in pairs(sections) do
            if type(section) == "table" then
              local fg, bg = bright(section.fg), bright(section.bg)
              if name == "a" and fg and bg and bg > fg then
                section.fg = section.bg
              end
              section.bg = nil
            end
          end
        end
        return theme
      end,
      -- lualine 默认的 powerline 箭头（  等）本来是靠背景色画出来的，
      -- 没有底色后会变成悬空的彩色符号，所以改用不依赖背景色的分隔符
      section_separators = { left = "", right = "" },
      component_separators = { left = "|", right = "|" },
    },
  },
}
