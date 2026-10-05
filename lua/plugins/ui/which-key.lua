-- which-key 菜单中文化 + 清掉空分组
-- 原理：LazyVim 的 which-key spec 带 opts_extend = { "spec" }，这里追加的 spec 会并进去，
-- 同一个键位/分组以「后追加的」为准 —— 所以能在**不改动真实映射**的前提下，
-- 只把菜单里显示的名字换成中文（映射本身、功能、`:verbose map` 都不受影响）。
return {
  {
    "folke/which-key.nvim",
    opts_extend = { "spec" },
    -- LSP 缓冲区里的键位（ca/cc/cr/ss…）是 attach 时才动态挂上的 buffer-local 映射，
    -- 不能用全局 spec 改描述 —— 那样会在没有 LSP 的缓冲区里造出「幽灵条目」
    -- （实测：给一个不存在的键加 spec，菜单里就会凭空多出该键）。
    -- 所以挂在 LspAttach 上，用 buffer 限定的 spec 只改当前缓冲区。
    init = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          vim.schedule(function()
            pcall(function()
              require("which-key").add({
                { "<leader>ca", desc = "代码操作（Code Action）", buffer = args.buf },
                { "<leader>cA", desc = "源码操作（Source Action）", buffer = args.buf },
                { "<leader>cc", desc = "运行 Codelens", buffer = args.buf },
                { "<leader>cC", desc = "刷新并显示 Codelens", buffer = args.buf },
                { "<leader>cl", desc = "LSP 信息", buffer = args.buf },
                { "<leader>cr", desc = "重命名", buffer = args.buf },
                { "<leader>ss", desc = "LSP 符号（当前文件）", buffer = args.buf },
                { "<leader>sS", desc = "LSP 符号（整个项目）", buffer = args.buf },
              })
            end)
          end)
        end,
      })
    end,
    opts = {
      spec = {
        -- ── 分组名（LazyVim 默认是英文）──
        { "<leader>c", group = "代码" },
        { "<leader>d", group = "调试" },
        { "<leader>f", group = "文件 / 查找" },
        { "<leader>g", group = "Git" },
        { "<leader>m", group = "Markdown" },
        { "<leader>q", group = "退出 / 会话" },
        { "<leader>s", group = "搜索" },
        { "<leader>t", group = "终端" },
        { "<leader>w", group = "窗口" },
        { "<leader>x", group = "诊断 / 列表" },
        { "<leader>y", group = "路径 / 文件管理" },
        { "<leader><tab>", group = "标签页" },
        -- 非 leader 的分组
        { "g", group = "跳转" },
        { "gs", group = "包围" },
        { "z", group = "折叠" },
        { "[", group = "上一个" },
        { "]", group = "下一个" },

        -- ── 隐藏空分组：b（buffer）/ u（ui）里的键位已全部删除，分组标题还挂着 ──
        { "<leader>b", hidden = true },
        { "<leader>u", hidden = true },

        -- ── 键位描述中文化（LazyVim 默认给的是英文说明）──
        { "<leader><space>", desc = "智能查找文件" },
        { "<leader>?", desc = "当前缓冲区的键位" },
        { "<leader>cf", desc = "格式化当前文件" },
        { "<leader>cF", desc = "格式化注入语言（如 md 里的代码块）" },
        { "<leader>cm", desc = "Mason（LSP / 工具安装器）" },
        { "<leader>l", desc = "Lazy（插件管理）" },
        { "<leader>qq", desc = "退出全部" },
        { "<leader>sW", desc = "搜索选中 / 光标词（当前目录）" },
        { "<leader>wd", desc = "关闭当前窗口 / 分屏" },
        { "<leader>|", desc = "垂直分屏（右）" },

        -- ── g 前缀（LSP 跳转 / 文件导航）──
        { "gd", desc = "跳转到定义" },
        { "gD", desc = "跳转到声明" },
        { "gI", desc = "跳转到实现" },
        { "gy", desc = "跳转到类型定义" },
        { "gO", desc = "显示当前文件的大纲" },
        { "gr", group = "引用" },
        { "ge", desc = "上一个词尾" },
        { "gf", desc = "打开光标下的文件" },
        { "gg", desc = "文件首行" },
        { "gi", desc = "上次插入的位置" },
        { "gn", desc = "向下搜索并选中" },
        { "gN", desc = "向上搜索并选中" },
        { "gt", desc = "下一个标签页" },
        { "gT", desc = "上一个标签页" },
        { "gu", desc = "转小写" },
        { "gU", desc = "转大写" },
        { "gv", desc = "上次可视选择" },
        { "gw", desc = "格式化" },
        { "gx", desc = "用系统程序打开" },
        { "g%", desc = "跳到匹配的另一半" },
        { "g,", desc = "较新的修改位置" },
        { "g;", desc = "较旧的修改位置" },
        { "g[", desc = "向左移动到 around" },
        { "g]", desc = "向右移动到 around" },
        { "g~", desc = "切换大小写" },
        { "gc", group = "注释开关" },
        { "g'", group = "标记" },
        { "g`", group = "标记" },
      },
    },
  },
}
