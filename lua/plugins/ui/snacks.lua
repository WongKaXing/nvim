return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = [[


██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗
██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║
██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║
██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║
███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        keys = {},
      },
    },
    explorer = { enabled = true },
    picker = {
      enabled = true,
      sources = {
        explorer = {
          hidden = true,
          sort = function(a, b)
            local function naturalize(s)
              return (s or ""):gsub("(%d+)", function(d)
                return string.format("%010d", tonumber(d))
              end)
            end
            return naturalize(a.sort) < naturalize(b.sort)
          end,
          win = {
            list = {
              keys = {
                H = false, -- 禁用 Shift+H 切换隐藏文件
              },
            },
          },
        },
      },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      },
    },
  },
  keys = {
    -- Top Pickers & Explorer
    {
      "<leader><space>",
      function()
        Snacks.picker.smart()
      end,
      desc = "智能查找文件",
    },
    {
      "<leader>,",
      function()
        Snacks.picker.buffers()
      end,
      desc = "缓冲区列表",
    },
    {
      "<leader>/",
      function()
        Snacks.picker.grep()
      end,
      desc = "全局搜索",
    },
    {
      "<leader>:",
      function()
        Snacks.picker.command_history()
      end,
      desc = "命令历史",
    },
    {
      "<leader>n",
      function()
        Snacks.picker.notifications()
      end,
      desc = "通知历史",
    },
    {
      "<leader>e",
      function()
        local cwd = vim.fn.expand("%:p:h")
        if cwd == "" then
          cwd = nil
        end
        Snacks.explorer({ cwd = cwd })
      end,
      desc = "文件资源管理器",
    },
    -- find
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "缓冲区列表",
    },
    {
      "<leader>fc",
      function()
        Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "查找配置文件",
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "查找文件",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.git_files()
      end,
      desc = "查找Git文件",
    },
    {
      "<leader>fp",
      function()
        Snacks.picker.projects()
      end,
      desc = "项目列表",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent()
      end,
      desc = "最近文件",
    },
    -- git
    {
      "<leader>gb",
      function()
        Snacks.picker.git_branches()
      end,
      desc = "Git分支",
    },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log()
      end,
      desc = "Git日志",
    },
    {
      "<leader>gL",
      function()
        Snacks.picker.git_log_line()
      end,
      desc = "Git日志行",
    },
    {
      "<leader>gs",
      function()
        Snacks.picker.git_status()
      end,
      desc = "Git状态",
    },
    {
      "<leader>gS",
      function()
        Snacks.picker.git_stash()
      end,
      desc = "Git暂存",
    },
    {
      "<leader>gd",
      function()
        Snacks.picker.git_diff()
      end,
      desc = "Git差异",
    },
    {
      "<leader>gf",
      function()
        Snacks.picker.git_log_file()
      end,
      desc = "Git文件日志",
    },
    -- gh
    {
      "<leader>gi",
      function()
        Snacks.picker.gh_issue()
      end,
      desc = "GitHub Issues（开启）",
    },
    {
      "<leader>gI",
      function()
        Snacks.picker.gh_issue({ state = "all" })
      end,
      desc = "GitHub Issues（全部）",
    },
    {
      "<leader>gp",
      function()
        Snacks.picker.gh_pr()
      end,
      desc = "GitHub PR（开启）",
    },
    {
      "<leader>gP",
      function()
        Snacks.picker.gh_pr({ state = "all" })
      end,
      desc = "GitHub PR（全部）",
    },
    -- Grep
    {
      "<leader>sb",
      function()
        Snacks.picker.lines()
      end,
      desc = "缓冲区行",
    },
    {
      "<leader>sB",
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = "搜索打开的缓冲区",
    },
    {
      "<leader>sg",
      function()
        Snacks.picker.grep()
      end,
      desc = "全局搜索",
    },
    {
      "<leader>sw",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "搜索选中或光标单词",
      mode = { "n", "x" },
    },
    -- search
    {
      '<leader>s"',
      function()
        Snacks.picker.registers()
      end,
      desc = "寄存器",
    },
    {
      "<leader>s/",
      function()
        Snacks.picker.search_history()
      end,
      desc = "搜索历史",
    },
    {
      "<leader>sa",
      function()
        Snacks.picker.autocmds()
      end,
      desc = "自动命令",
    },
    {
      "<leader>sb",
      function()
        Snacks.picker.lines()
      end,
      desc = "缓冲区行",
    },
    {
      "<leader>sc",
      function()
        Snacks.picker.command_history()
      end,
      desc = "命令历史",
    },
    {
      "<leader>sC",
      function()
        Snacks.picker.commands()
      end,
      desc = "命令列表",
    },
    {
      "<leader>sd",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "诊断信息",
    },
    {
      "<leader>sD",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "缓冲区诊断",
    },
    {
      "<leader>sh",
      function()
        Snacks.picker.help()
      end,
      desc = "帮助页面",
    },
    {
      "<leader>sH",
      function()
        Snacks.picker.highlights()
      end,
      desc = "高亮组",
    },
    {
      "<leader>si",
      function()
        Snacks.picker.icons()
      end,
      desc = "图标",
    },
    {
      "<leader>sj",
      function()
        Snacks.picker.jumps()
      end,
      desc = "跳转列表",
    },
    {
      "<leader>sk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "快捷键",
    },
    {
      "<leader>sl",
      function()
        Snacks.picker.loclist()
      end,
      desc = "位置列表",
    },
    {
      "<leader>sm",
      function()
        Snacks.picker.marks()
      end,
      desc = "标记",
    },
    {
      "<leader>sM",
      function()
        Snacks.picker.man()
      end,
      desc = "手册页",
    },
    {
      "<leader>sp",
      function()
        Snacks.picker.lazy()
      end,
      desc = "搜索插件",
    },
    {
      "<leader>sq",
      function()
        Snacks.picker.qflist()
      end,
      desc = "快速修复列表",
    },
    {
      "<leader>sR",
      function()
        Snacks.picker.resume()
      end,
      desc = "恢复上次搜索",
    },
    {
      "<leader>su",
      function()
        Snacks.picker.undo()
      end,
      desc = "撤销历史",
    },
    {
      "<leader>uC",
      function()
        Snacks.picker.colorschemes()
      end,
      desc = "配色方案",
    },
    -- LSP
    {
      "gd",
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = "跳转到定义",
    },
    {
      "gD",
      function()
        Snacks.picker.lsp_declarations()
      end,
      desc = "跳转到声明",
    },
    {
      "gr",
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = "引用",
    },
    {
      "gI",
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = "跳转到实现",
    },
    {
      "gy",
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = "跳转到类型定义",
    },
    {
      "gai",
      function()
        Snacks.picker.lsp_incoming_calls()
      end,
      desc = "传入调用",
    },
    {
      "gao",
      function()
        Snacks.picker.lsp_outgoing_calls()
      end,
      desc = "传出调用",
    },
    {
      "<leader>ss",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "LSP符号",
    },
    {
      "<leader>sS",
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = "LSP工作区符号",
    },
    -- Other
    {
      "<leader>z",
      function()
        Snacks.zen()
      end,
      desc = "切换禅模式",
    },
    {
      "<leader>Z",
      function()
        Snacks.zen.zoom()
      end,
      desc = "切换缩放",
    },
    {
      "<leader>.",
      function()
        Snacks.scratch()
      end,
      desc = "切换临时缓冲区",
    },
    {
      "<leader>S",
      function()
        Snacks.scratch.select()
      end,
      desc = "选择临时缓冲区",
    },
    {
      "<leader>n",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "通知历史",
    },
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "删除缓冲区",
    },
    {
      "<leader>cR",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "重命名文件",
    },
    {
      "<leader>gB",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git在线浏览",
      mode = { "n", "v" },
    },
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "关闭所有通知",
    },
    {
      "<c-/>",
      function()
        Snacks.terminal()
      end,
      desc = "切换终端",
    },
    {
      "<c-_>",
      function()
        Snacks.terminal()
      end,
      desc = "which_key_ignore",
    },
    {
      "]]",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "下一个引用",
      mode = { "n", "t" },
    },
    {
      "[[",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "上一个引用",
      mode = { "n", "t" },
    },
    {
      "<leader>N",
      desc = "Neovim更新日志",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end

        -- Override print to use snacks for `:=` command
        if vim.fn.has("nvim-0.11") == 1 then
          vim._print = function(_, ...)
            dd(...)
          end
        else
          vim.print = _G.dd
        end

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle
          .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
          :map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
      end,
    })
  end,
}
