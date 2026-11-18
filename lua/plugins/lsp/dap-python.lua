-- Python 调试器：nvim-dap（客户端） + nvim-dap-python（Python 适配器）
--
-- 必须分清两个解释器：
--   ① 适配器解释器（debugpy 装在哪）—— 独立的 uv 环境，不往项目 venv 里塞调试依赖；
--   ② 程序解释器（真正跑你代码的 python）—— nvim-dap-python 会从当前文件所在
--      目录向上找 .venv / venv，找到就用它。所以 requests、lxml 这些依赖自动对得上。
-- 通用键位与中文说明见同目录的 dap.lua。
return {
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local uv = vim.uv or vim.loop

      -- ① 适配器：独立的 debugpy 环境（uv 建的，13M），不碰项目 venv，也不依赖 mason
      --    升级：uv pip install --python ~/.local/share/nvim/debugpy-adapter/bin/python -U debugpy
      require("dap-python").setup(vim.fn.stdpath("data") .. "/debugpy-adapter/bin/python")

      -- ② 程序解释器：优先显式激活的 venv，其次从当前文件向上找项目 .venv
      local function project_python()
        if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= "" then
          return vim.env.VIRTUAL_ENV .. "/bin/python"
        end
        local buf = vim.api.nvim_buf_get_name(0)
        local start = (buf ~= "" and vim.fs.dirname(buf)) or vim.fn.getcwd()
        local venv = vim.fs.find({ ".venv", "venv" }, { path = start, upward = true, type = "directory" })[1]
        local exe = venv and (venv .. "/bin/python")
        if exe and uv.fs_stat(exe) then
          return exe
        end
        return "python3"
      end
      require("dap-python").resolve_python = project_python

      -- ③ 一键调试当前文件：不弹配置选择，直接跑，跑之前不用先写 main
      vim.keymap.set("n", "<leader>dp", function()
        local file = vim.fn.expand("%:p")
        if file == "" then
          vim.notify("当前 buffer 没有文件路径，先存盘", vim.log.levels.WARN)
          return
        end
        require("dap").run({
          type = "python",
          request = "launch",
          name = "调试当前 Python 文件",
          program = file,
          cwd = vim.fn.fnamemodify(file, ":h"),
          pythonPath = project_python(),
          console = "integratedTerminal",
          justMyCode = true, -- 只在你自己写的代码里停，不钻进 requests 等第三方库
        })
      end, { desc = "调试当前 Python 文件（自动用项目 venv）" })
    end,
  },

  -- 别让 mason-nvim-dap 抢走 python 适配器（nvim-dap-python 已接管）
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = {
      handlers = {
        python = function() end,
      },
    },
  },
}
