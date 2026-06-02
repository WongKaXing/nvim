return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      ensure_installed = {
        "kitty",
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
          if content:find("font_family")
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
        end,
      })
    end,
  },
}
