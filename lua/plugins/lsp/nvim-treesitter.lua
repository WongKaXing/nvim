return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      -- 语法高亮解析器清单（在 LazyVim 默认清单之外补充的）
      -- LazyVim 启动时会自动安装这里缺的解析器，不需要手动 :TSInstall
      ensure_installed = {
        -- 原有
        "kitty",
        "markdown",
        "markdown_inline",
        -- 系统 / 脚本
        "zsh",
        "bash",
        "ssh_config",
        "desktop",
        -- 配置文件
        "ini",
        "dockerfile",
        "make",
        "nginx",
        "git_config",
        "gitcommit",
        "gitignore",
        -- 前端
        "css",
        "scss",
        -- 文档 / 其他
        "properties",
        "perl",
        "sql",
        "cpp",
        "go",
        "rust",
      },
    },
    init = function()
      -- Detect kitty conf files (path-based)
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { "kitty.conf", "*/kitty/*.conf", "*kitty*.conf" },
        callback = function(ev)
          vim.bo[ev.buf].filetype = "kitty"
        end,
      })
      -- Content-based detection for generic .conf files
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.conf",
        callback = function(ev)
          if vim.bo[ev.buf].filetype ~= "conf" and vim.bo[ev.buf].filetype ~= "" then
            return
          end
          local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, 20, false)
          local content = table.concat(lines, "\n")
          if
            content:find("font_family")
            or content:find("font_size")
            or content:find("window_padding_width")
            or content:find("kitty_mod")
            or content:find("include ")
            or content:find("mouse_map")
          then
            vim.bo[ev.buf].filetype = "kitty"
          end
        end,
      })

      -- 去掉 treesitter 高亮的背景色：@xxx 语法高亮组，以及 Markdown 渲染用的
      -- RenderMarkdown* 组（标题底色 / 行内代码 / 代码块底色都来自它们）。
      -- 只清背景，前景色与粗体、斜体、下划线等样式全部保留。
      local function strip_ts_bg()
        local function is_ts(name)
          return name:sub(1, 1) == "@" or vim.startswith(name, "RenderMarkdown")
        end

        -- 用原属性重设该组，只把背景拿掉
        local function clear_bg(name, hl)
          hl.bg = "NONE"
          hl.ctermbg = nil
          hl.default = nil
          vim.api.nvim_set_hl(0, name, hl)
        end

        local groups = vim.api.nvim_get_hl(0, {})
        -- 第一遍：自带背景色的组，把背景清掉
        for name, hl in pairs(groups) do
          if is_ts(name) and hl.bg then
            clear_bg(name, hl)
          end
        end
        -- 第二遍：链接到别的组的，若目标带背景色就改用去掉背景的副本
        for name, hl in pairs(groups) do
          if is_ts(name) and hl.link then
            local ok, tgt = pcall(vim.api.nvim_get_hl, 0, { name = hl.link, link = true })
            if ok and tgt.bg then
              clear_bg(name, tgt)
            end
          end
        end
        -- render-markdown 会缓存「把背景色当字色」的衍生高亮，清完背景让它重算
        pcall(function()
          require("render-markdown.core.colors").reload()
        end)
      end

      -- Apply custom highlights AFTER treesitter is fully loaded
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          local set_hl = vim.api.nvim_set_hl
          -- File path references get undercurl
          set_hl(0, "@module", { undercurl = true, sp = "#7dcfff" })
          set_hl(0, "@string.special.path", { undercurl = true, sp = "#7dcfff" })
          set_hl(0, "@string.special.url", { undercurl = true, sp = "#7dcfff" })
          set_hl(0, "@text.uri", { undercurl = true, sp = "#7dcfff" })
          -- Import/include keywords in some languages
          set_hl(0, "@keyword.import", { italic = true })
          strip_ts_bg()
        end,
      })

      -- 换主题后会重新载入配色，markdown 缓冲区打开时 render-markdown 才懒加载，
      -- 两种情况都再清一遍（schedule 保证跑在插件自己的高亮处理之后）
      -- VimEnter 是不依赖 VeryLazy 的兜底（无 UI 的场景不会触发 VeryLazy）
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.schedule(strip_ts_bg)
        end,
      })
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          vim.schedule(strip_ts_bg)
        end,
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "quarto" },
        callback = function()
          vim.schedule(strip_ts_bg)
        end,
      })
    end,
  },
}
