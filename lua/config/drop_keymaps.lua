-- 要删掉的 LazyVim / 插件默认键位
-- 被 lua/config/keymaps.lua 引用；把 M.apply() 那行注释掉即可全部恢复。
-- 菜单里显示的中文名在 lua/plugins/ui/which-key.lua。

local M = {}

-- 只写 <leader> 后面的部分（不带 <leader> 前缀）
-- stylua: ignore
M.keys = {
  -- 单键 / 符号
  ",", "-", ".", "/", ":", "E", "K", "L", "N", "S", "Z", "`", "n", "z",
  -- 缓冲区（bd 保留，见 keymaps.lua）
  "bD", "bP", "bb", "bi", "bj", "bl", "bo", "bp", "br",
  -- 代码 / LSP
  "cR", "cS", "cd", "cs", "cw",
  -- 查找
  "fB", "fE", "fF", "fR", "fT", "fb", "fc", "fe", "fg", "fn", "fp", "fr", "ft",
  -- Git
  "gD", "gG", "gL", "gS", "gb", "gd", "gf", "gg", "gl", "gs",
  -- 搜索列表（sk 保留 = 快捷键查询器）
  's"', "s/", "sB", "sC", "sD", "sG", "sH", "sM", "sR", "sS", "sT",
  "sa", "sb", "sc", "sd", "sh", "si", "sj", "sl", "sm", "sp", "sq", "sr", "ss", "st", "su",
  -- 界面开关
  "uA", "uC", "uD", "uF", "uI", "uL", "uS", "uT", "uZ", "ua", "ub", "uc", "ud",
  "uf", "ug", "uh", "ui", "ul", "un", "up", "ur", "us", "uw", "uz",
  -- 窗口
  "wm", "wq",
  -- 诊断 / 列表
  "xL", "xQ", "xT", "xX", "xl", "xq", "xt", "xx",
  -- 开发向 / 需要特定环境的：Profiler、Noice、会话、标签页、GitHub、Git Browse
  "dpp", "dps", "dph",
  "sn", "sna", "snd", "snh", "snl", "snt",
  "qs", "qS", "ql", "qd",
  "<Tab><Tab>", "<Tab>[", "<Tab>]", "<Tab>d", "<Tab>f", "<Tab>l", "<Tab>o",
  "gi", "gI", "gp", "gP", "gB", "gY",
}

-- 这些键位由各插件在启动 / VeryLazy 阶段注册，所以 schedule 一帧后再统一删
function M.apply()
  vim.schedule(function()
    for _, k in ipairs(M.keys) do
      for _, mode in ipairs({ "n", "v", "x", "t" }) do
        pcall(vim.keymap.del, mode, "<leader>" .. k)
      end
    end
  end)
end

return M
