return {
  "MunsMan/kitty-navigator.nvim",
  keys = {
    {
      "<C-h>",
      function()
        require("kitty-navigator").navigateLeft()
      end,
      desc = "向左移动窗口",
      mode = { "n" },
    },
    {
      "<C-j>",
      function()
        require("kitty-navigator").navigateDown()
      end,
      desc = "向下移动窗口",
      mode = { "n" },
    },
    {
      "<C-k>",
      function()
        require("kitty-navigator").navigateUp()
      end,
      desc = "向上移动窗口",
      mode = { "n" },
    },
    {
      "<C-l>",
      function()
        require("kitty-navigator").navigateRight()
      end,
      desc = "向右移动窗口",
      mode = { "n" },
    },
  },
  build = {
    "cp navigate_kitty.py ~/.config/kitty",
    "cp pass_keys.py ~/.config/kitty",
  },
  opts = { keybindings = {} },
}
