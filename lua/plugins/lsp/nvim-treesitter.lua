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

      -- 给已有高亮「追加」属性（下划线 / 斜体等）时，必须先把原属性取出来再合并：
      -- nvim_set_hl 是整组覆盖，只写 italic/undercurl 会把原来的字色抹成默认色。
      -- link=false 拿到的是链接解析后的真实属性，避免丢掉 @xxx -> Foo 的继承。
      local function extend_hl(name, extra)
        local cur = vim.api.nvim_get_hl(0, { name = name, link = false })
        vim.api.nvim_set_hl(0, name, vim.tbl_extend("force", cur, extra))
      end

      -- ── 花体字清单 ──────────────────────────────────────────────────
      -- 原理：kitty 的 italic_font 就是 VictorMono 的连笔斜体（见
      -- ~/.config/kitty/kitty-font.conf 里的 `italic_font`），所以 nvim 只要给
      -- 哪个组加 `italic`，那个 token 就显示成花体，跟字体文件无关。
      --
      -- 用法：
      --   · 不想要某个花体 → 在那一行前面加 -- 注释掉（下面每个都单独一行）
      --   · 想要默认没开的 → 把行首的 `-- ` 删掉即可
      -- 默认只开「靠字形一眼能认出是什么」的那批；会把整屏变花的
      -- （变量名 / 字符串 / 数字 / 标点 / 运算符）默认注释着，按需打开。
      -- 组名含义见 `:h treesitter-highlight-groups`，Python 实际的 token 映射
      -- 可以用 `:InspectTree` 或 `:Inspect` 现查。
      local italic_groups = {
        -- ── 定义与关键字 ────────────────────────────────────────────
        "@keyword.function", -- def / lambda（函数定义关键字）
        "@keyword.type", -- class（类型定义关键字）
        "@keyword.import", -- from / import
        -- "@keyword", -- 其余关键字 if / for / return / try…（tokyonight 默认已斜体）
        -- "@keyword.return", -- return
        "@keyword.conditional", -- if / elif / else
        -- "@keyword.conditional.ternary", -- 三元表达式 ? :
        "@keyword.repeat", -- for / while
        "@keyword.exception", -- try / except / finally / raise
        "@keyword.operator", -- and / or / not / in / is
        -- "@keyword.coroutine", -- async / await
        -- "@keyword.modifier", -- 修饰符（public / private 等）
        -- "@keyword.directive", -- 编译指示 / pragma 类
        -- "@keyword.directive.define", -- #define 之类
        -- "@keyword.debug", -- 调试语句
        -- "@include", -- include / import 语句（旧捕获名）
        -- "@conditional", -- 条件语句（旧捕获名）
        -- "@repeat", -- 循环（旧捕获名）
        -- "@exception", -- 异常（旧捕获名）
        -- "@storageclass", -- static / const / var 之类
        -- "@define", -- #define（旧捕获名）
        -- "@preproc", -- 预处理指令（旧捕获名）
        -- "@debug", -- 调试（旧捕获名）

        -- ── 函数 ────────────────────────────────────────────────────
        -- "@function", -- 函数定义名（def foo 里的 foo）
        -- "@function.call", -- 函数调用 foo()（含你自己写的 success()、error()）
        -- "@function.method", -- 方法定义名
        -- "@function.method.call", -- 方法调用 obj.method()，如 os.system / requests.get
        "@function.builtin", -- 内置函数 print / len / range
        -- "@function.macro", -- 宏
        -- "@constructor", -- 构造函数调用

        -- ── 类型 ────────────────────────────────────────────────────
        "@type", -- 类型标注（x: int 里的 int）
        "@type.builtin", -- 内置类型 str / int / dict / list
        -- "@type.definition", -- 类型定义名（class Foo 里的 Foo / 类型别名）
        -- "@type.qualifier", -- 类型限定符（const / 协变逆变等）

        -- ── 布尔 / 常量 / 数字 ───────────────────────────────────────
        "@boolean", -- True / False
        "@constant.builtin", -- None / NotImplemented
        -- "@constant", -- 普通常量
        -- "@constant.macro", -- 宏常量
        -- "@number", -- 整数
        -- "@number.float", -- 浮点数
        -- "@character", -- 字符字面量 'a'
        -- "@character.special", -- 特殊字符 '\n'
        -- "@label", -- 标签（goto 的 label）
        -- "@annotation", -- 注解 / 装饰器名（@decorator）
        -- "@attribute", -- 属性（HTML 属性 / 注解参数）

        -- ── 模块 / 命名空间 ─────────────────────────────────────────
        -- "@module", -- 模块名（import os 里的 os）
        -- "@module.builtin", -- 内置模块
        -- "@namespace", -- 命名空间

        -- ── 变量（这一段打开会整屏花，默认全关）──────────────────────
        -- "@variable", -- 普通变量名
        -- "@variable.member", -- 成员访问 obj.attr
        -- "@variable.parameter", -- 函数参数、self
        -- "@variable.parameter.builtin", -- 内置参数（如 self）
        "@variable.builtin", -- 内置变量 self / super
        -- "@property", -- 对象属性 / 字典键

        -- ── 字符串 / 字面量（默认全关）──────────────────────────────
        -- "@string", -- 字符串
        -- "@string.escape", -- 转义序列 \n \t
        -- "@string.regexp", -- 正则表达式
        -- "@string.special", -- 特殊字符串
        -- "@string.special.path", -- 路径字符串（配置里另有下波浪线）
        -- "@string.special.symbol", -- 符号（Ruby :sym 等）
        -- "@string.special.url", -- URL
        -- "@string.documentation", -- 文档字符串
        -- "@float", -- 浮点（旧捕获名）

        -- ── 标点 / 运算符（打开基本没法看代码，默认全关）─────────────
        -- "@operator", -- 运算符 + - * / == and or
        -- "@punctuation", -- 标点总称
        -- "@punctuation.bracket", -- 括号 () [] {}（会和彩虹括号抢，不建议）
        -- "@punctuation.delimiter", -- 分隔符 , ; :
        -- "@punctuation.special", -- 特殊标点 #{}、${}
        -- "@delimiter", -- 分隔符（旧捕获名）

        -- ── 注释 / 文档（tokyonight 默认已斜体，列出来方便统一管理）──
        -- "@comment", -- 注释
        -- "@comment.documentation", -- 文档注释 docstring
        -- "@comment.error", -- 错误类注释
        -- "@comment.warning", -- 警告类注释
        -- "@comment.todo", -- TODO
        -- "@comment.note", -- NOTE

        -- ── Markdown / 文本（只在笔记里生效，代码里看不到）───────────
        -- 注意：这些是「正文样式」，加 italic 等于改变 markdown 的语义渲染，
        -- 一般别开；这里只是把能用的组名列全。
        -- "@markup.heading", -- 标题
        -- "@markup.strong", -- 粗体
        -- "@markup.italic", -- 斜体（本身就是斜体）
        -- "@markup.link", -- 链接
        -- "@markup.link.url", -- 链接地址
        -- "@markup.link.label", -- 链接文字
        -- "@markup.raw", -- 行内代码
        -- "@markup.raw.block", -- 代码块
        -- "@markup.quote", -- 引用
        -- "@markup.math", -- 数学公式
        -- "@markup.list", -- 列表符号
        -- "@markup.strikethrough", -- 删除线
        -- "@text.title", -- 标题（旧捕获名）
        -- "@text.literal", -- 字面量（旧捕获名）
        -- "@text.uri", -- 链接（旧捕获名）
        -- "@text.reference", -- 引用（旧捕获名）
        -- "@text.emphasis", -- 强调（旧捕获名）
        -- "@text.strong", -- 加粗（旧捕获名）
        -- "@text.quote", -- 引用（旧捕获名）
      }

      -- ── 反向清单：把「主题自带的斜体」改回正体 ───────────────────────
      -- 坑点：tokyonight 主题本身就给 @keyword（以及它下面所有子组，如
      -- @keyword.return）和 @comment 设了斜体。所以只把上面清单里对应行注释掉，
      -- 并不会让它们变回正体 —— 要显式写 italic = false 才盖得住。
      -- 想让哪些变正体，把下面行首的 -- 删掉即可（取消注释就生效）。
      local upright_groups = {
        -- "@comment", -- 注释改成正体
        -- "@keyword", -- 所有关键字改成正体（会连带 @keyword.* 子组）
        "@keyword.return", -- 只让 return 正体（主题默认给它斜体，注释掉上面清单没用）
        -- "@keyword.conditional", -- 只让 if / else 正体
        -- "@keyword.import", -- 只让 from / import 正体
      }

      -- 文件路径引用加下波浪线（斜体统一走上面的 italic_groups，方便你一处开关）
      local function apply_ts_attrs()
        for _, name in ipairs({ "@module", "@string.special.path", "@string.special.url", "@text.uri" }) do
          extend_hl(name, { undercurl = true, sp = "#7dcfff" })
        end
        for _, name in ipairs(italic_groups) do
          extend_hl(name, { italic = true })
        end
        -- 放在最后，保证盖得住主题 / 上面清单设的斜体
        for _, name in ipairs(upright_groups) do
          extend_hl(name, { italic = false })
        end
      end

      -- Apply custom highlights AFTER treesitter is fully loaded
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          apply_ts_attrs()
          strip_ts_bg()
        end,
      })

      -- 换主题后会重新载入配色，markdown 缓冲区打开时 render-markdown 才懒加载，
      -- 两种情况都再清一遍（schedule 保证跑在插件自己的高亮处理之后）
      -- VimEnter 是不依赖 VeryLazy 的兜底（无 UI 的场景不会触发 VeryLazy）
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.schedule(function()
            apply_ts_attrs()
            strip_ts_bg()
          end)
        end,
      })
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          vim.schedule(function()
            apply_ts_attrs()
            strip_ts_bg()
          end)
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
