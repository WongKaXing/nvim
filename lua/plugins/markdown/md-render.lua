-- Markdown 侧边 / 浮动预览（md-render.nvim）
-- 纯终端内渲染，成品放在「另一个窗口」，不改动编辑缓冲区 —— 所以能和
-- render-markdown.nvim 共存：后者让源码本身变好看，它负责另开窗口看成品。
-- 渲染缓冲区的 filetype 是 md-render（不是 markdown），不会和 render-markdown 抢渲染。
-- 要求 Neovim >= 0.12（本机 0.12.5 ✓）；图片/视频走 Kitty 图形协议（本机 kitty 0.49.2 ✓）。
-- 自带 Obsidian 集成：能解析 ![[image.png]] 这类库内图片引用。
-- 命令：:MdRender float | split | tab | toggle | pager | demo | textsize
--   :vert MdRender split = 竖向分屏「源码 | 渲染」并排（键位 <leader>mv）
-- 注意：本插件没有 setup()，所以这里不能写 opts（lazy 会去调用不存在的函数）；
--       需要配置子模块时用 config 自己调用。
return {
  {
    "delphinus/md-render.nvim",
    version = "*",
    ft = { "markdown", "quarto" },
    cmd = { "MdRender" },
    dependencies = {
      { "nvim-tree/nvim-web-devicons", version = "*" }, -- 代码块右上角的文件类型图标（LazyVim 已装）
      { "delphinus/budoux.lua", version = "*" }, -- 中日文按词组断行，避免行尾孤字
    },
    -- 关掉 Kitty 文本缩放（OSC 66）。原因：上游未修复的 issue #65 —— 分数缩放的
    -- 标题（## ~ ######）在中文等 CJK 字体回退场景下会出现字距错乱、字形被裁切，
    -- 看起来就像文字叠在一起（缩放文字是直接画在普通标题之上的，一错位就叠住）。
    -- 实测中文标题会被从词中间切成多段、每段各声明整数宽度 w=，正是 issue 描述的现象；
    -- # 用整数缩放 s=2 不受影响，但插件只有总开关、没有分级开关，只能整体关。
    -- 想临时开回来对比：:MdRender textsize on
    config = function()
      require("md-render.text_size").setup { enabled = false }
    end,
  },
}
