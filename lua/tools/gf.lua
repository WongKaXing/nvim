local M = {}

function M.includeexpr()
  local file = vim.fn.expand("<cfile>")
  -- require("a.b.c") → a/b/c.lua
  if file:match("%.") then
    local transformed = file:gsub("%.", "/")
    local full = vim.fn.findfile(transformed .. ".lua")
    if full ~= "" then
      return full
    end
    full = vim.fn.findfile(transformed .. ".ts")
    if full ~= "" then
      return full
    end
  end
  return file
end

return M
