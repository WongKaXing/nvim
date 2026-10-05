-- ─── 饥荒(DST) mod 片段补全开关 ────────────────────────────────────────────
-- DST 的 78 个片段放在 ~/.config/nvim/snippets-dst/，默认 *不* 加载，
-- 免得写普通 lua 时被刷屏。写 mod 时用 :DSTMod on 打开（或 <leader>dm）。
local DST_SNIPPET_DIR = vim.fs.joinpath(vim.fn.stdpath("config"), "snippets-dst")

-- 开关打开时把 dst 目录并进 blink 的 snippet 搜索路径
local function dst_paths(enabled)
  local base = { vim.fn.stdpath("config") .. "/snippets" }
  if enabled and vim.fn.isdirectory(DST_SNIPPET_DIR) == 1 then
    table.insert(base, DST_SNIPPET_DIR)
  end
  return base
end

return {
  {
    "saghen/blink.cmp",
    init = function()
      -- 首次运行：若片段还留在老位置（snippets/lua.json），自动搬到 snippets-dst/
      local old = vim.fs.joinpath(vim.fn.stdpath("config"), "snippets", "lua.json")
      local new = vim.fs.joinpath(DST_SNIPPET_DIR, "lua.json")
      if vim.fn.filereadable(old) == 1 and vim.fn.filereadable(new) == 0 then
        vim.fn.mkdir(DST_SNIPPET_DIR, "p")
        vim.fn.rename(old, new)
      end
    end,
    config = function(_, opts)
      -- 默认关闭 DST 片段
      opts.snippets = opts.snippets or {}
      opts.snippets.search_paths = dst_paths(false)
      require("blink.cmp").setup(opts)

      local enabled = false

      -- 拿到 blink 实际在用的 snippets provider（可能尚未实例化）
      local function get_provider()
        local ok, lib = pcall(require, "blink.cmp.sources.lib")
        if not ok then return nil end
        local ok2, prov = pcall(lib.get_provider_by_id, "snippets")
        if ok2 then return prov end
        return nil
      end

      -- 改动 search_paths 后重建 registry 并清缓存，让开关立即生效
      local function apply(on)
        local paths = dst_paths(on)
        opts.snippets.search_paths = paths

        local ok, registry = pcall(require, "blink.cmp.sources.snippets.default.registry")
        if not ok then return false end
        local ok2, inst = pcall(registry.new, { search_paths = paths })
        if not ok2 then return false end

        local prov = get_provider()
        if prov then
          prov.registry = inst
          prov.cache = {}   -- 关键：provider 按 filetype 缓存了补全项，必须清掉
          return true
        end
        return true -- provider 还没实例化，等它创建时会读到新 search_paths
      end

      local function count()
        local ok, registry = pcall(require, "blink.cmp.sources.snippets.default.registry")
        if not ok then return nil end
        local ok2, inst = pcall(registry.new, { search_paths = opts.snippets.search_paths })
        if not ok2 then return nil end
        local ok3, snips = pcall(function() return inst:get_snippets_for_ft("lua") end)
        if not ok3 then return nil end
        return #snips
      end

      local function set(on, notify)
        enabled = on
        local ok = apply(on)
        if notify then
          local msg = on and "DST mod 片段补全：开启 ✅" or "DST mod 片段补全：关闭 ⛔"
          if not ok then msg = msg .. "（需重启 nvim 生效）" end
          vim.notify(msg, on and vim.log.levels.INFO or vim.log.levels.WARN)
        end
        -- 刷新已打开的补全菜单，避免显示旧结果
        pcall(function() require("blink.cmp").hide() end)
      end

      vim.api.nvim_create_user_command("DSTMod", function(a)
        local arg = (a.args or ""):lower():gsub("%s", "")
        if arg == "" then
          set(not enabled, true)
        elseif arg == "on" then
          set(true, true)
        elseif arg == "off" then
          set(false, true)
        elseif arg == "status" then
          vim.notify(
            string.format("DST 片段：%s  |  当前 lua 片段数：%s",
              enabled and "开启" or "关闭", count() or "?"),
            vim.log.levels.INFO
          )
        else
          vim.notify("用法: :DSTMod [on|off|status]", vim.log.levels.WARN)
        end
      end, { nargs = "?", complete = function() return { "on", "off", "status" } end,
             desc = "开关饥荒 DST mod 片段补全" })

      vim.keymap.set("n", "<leader>dm", function()
        local c = vim.fn.confirm("饥荒 DST mod 片段补全（当前: " .. (enabled and "开启" or "关闭") .. "）",
          "&开启\t&关闭\t查看&状态", enabled and 2 or 1)
        if c == 1 then set(true, true)
        elseif c == 2 then set(false, true)
        elseif c == 3 then vim.cmd("DSTMod status") end
      end, { desc = "DST mod 补全开关" })
    end,
    opts = {
      keymap = {
        preset = "enter",
        ["<CR>"] = { "fallback" },
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      },
      completion = {
        trigger = {
          -- 进入插入模式立即触发补全请求，预热 LSP
          show_on_insert = true,
          -- 退格回到关键词内时重新触发补全
          show_on_backspace_in_keyword = true,
        },
      },
      sources = {
        providers = {
          -- buffer 即时补全给高分，确保输入 1-2 字符就有反馈
          buffer = {
            name = "Buffer",
            module = "blink.cmp.sources.buffer",
            score_offset = 5,
          },
          path = {
            name = "Path",
            module = "blink.cmp.sources.path",
            score_offset = 3,
            opts = {
              trailing_slash = true,
              label_trailing_slash = true,
              -- 注意：blink.cmp 1.x 的字段名是 show_hidden_files_by_default，
              -- 写成 show_hidden 会被它的配置校验拒绝并提示
              -- "sources → providers → path → show_hidden Unexpected field in configuration!"
              show_hidden_files_by_default = false,
            },
          },
        },
        per_filetype = {
          kitty = { "path", "buffer", "snippets" },
          conf = { "path", "buffer", "snippets" },
        },
      },
    },
  },
}
