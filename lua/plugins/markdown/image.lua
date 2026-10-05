-- 在缓冲区里直接显示图片（3rd/image.nvim）
-- 走 Kitty 图形协议（本机 kitty 0.49.2 ✓），依赖 ImageMagick（已 brew 安装 7.1.2）。
-- 效果：markdown 里的 ![](pic.png) 直接渲染成图片，不用开浏览器。
-- 与 render-markdown.nvim 互补（一个画图、一个画文字样式），不冲突。
return {
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    -- 必须关掉 rock 构建：image.nvim 自带 rockspec（依赖 magick rock），lazy v11+ 会自动
    -- 拉 hererocks 去编译它，而本机没有 luarocks → 每轮都失败 → lazy 报
    -- "Too many rounds of missing plugins" 并中断整个 spec 加载。
    -- 我们用 magick_cli（命令行 ImageMagick，已装），压根不需要这个 rock。
    -- 官方 README 的 "For magick_cli using Lazy" 就是这么写的。
    build = false,
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false, -- 插入模式下也保持显示，不闪
          only_render_image_at_cursor = false, -- 所有图片都渲染，不只是光标下那张
          filetypes = { "markdown", "quarto" }, -- quarto 也按 markdown 的规则渲染图片
        },
      },
      max_height_window_percentage = 50, -- 单张图最高占窗口高度一半
      window_overlap_clear_enabled = true, -- 浮动窗口（which-key / picker）压上来时自动隐藏图片
    },
  },
}
