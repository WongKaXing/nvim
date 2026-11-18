-- 调试器通用设置：把 LazyVim 默认的英文键位说明（which-key 里显示的那串）换成中文。
-- 键位本身由 LazyVim 的 extras.dap.core 提供，这里只覆盖说明文字。
--
-- 原理：lazy.nvim 的 keys 按「mode:lhs」去重，同名的后声明者覆盖先声明者
-- （见 lazy/core/handler/keys.lua 的 Keys.resolve：values[keys.id] = keys）。
-- 所以把同一个键再写一遍，换掉 desc 就行，功能不变。

-- 「带参数运行」：先弹窗问命令行参数，逻辑与 LazyVim 原版一致
local function with_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
  local args_str = type(args) == "table" and table.concat(args, " ") or args
  config = vim.deepcopy(config)
  config.args = function()
    local s = vim.fn.expand(vim.fn.input("运行参数: ", args_str))
    return require("dap.utils").splitstr(s)
  end
  return config
end

return {
  {
    "mfussenegger/nvim-dap",
    optional = true, -- 插件由 LazyVim 的 dap.core 扩展引入，这里只覆盖 keys
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "切换断点" },
      {
        "<leader>dB",
        function() require("dap").set_breakpoint(vim.fn.input("断点条件: ")) end,
        desc = "条件断点（满足表达式才停）",
      },
      { "<leader>dc", function() require("dap").continue() end, desc = "启动 / 继续" },
      { "<leader>da", function() require("dap").continue({ before = with_args }) end, desc = "带参数运行" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "运行到光标处" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "跳到指定行（不执行）" },
      { "<leader>di", function() require("dap").step_into() end, desc = "单步进入（钻进函数）" },
      { "<leader>do", function() require("dap").step_out() end, desc = "单步跳出（出当前函数）" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "单步跳过（整行执行）" },
      { "<leader>dj", function() require("dap").down() end, desc = "下一层栈帧" },
      { "<leader>dk", function() require("dap").up() end, desc = "上一层栈帧" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "重新运行上次调试" },
      { "<leader>dP", function() require("dap").pause() end, desc = "暂停" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "调试 REPL（实时求值）" },
      { "<leader>ds", function() require("dap").session() end, desc = "当前会话信息" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "结束调试" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "悬停查看变量" },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    optional = true,
    keys = {
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "调试面板开关" },
      { "<leader>de", function() require("dapui").eval() end, mode = { "n", "x" }, desc = "求值（光标处 / 选中）" },
    },
  },
  {
    -- Snacks 的「性能分析临时缓冲」也挂在 <leader>d 组下，一并换成中文
    "folke/snacks.nvim",
    optional = true,
    keys = {
      { "<leader>dps", function() require("snacks").profiler.scratch() end, desc = "性能分析临时缓冲" },
    },
  },
}
