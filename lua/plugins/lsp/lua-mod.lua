-- 饥荒(DST) Lua mod 开发配置:
-- lua_ls 按 Lua 5.1 解析 + 声明游戏全局, 避免满屏误报
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "Lua 5.1" },
              diagnostics = {
                globals = {
                  "vim",
                  "GLOBAL", "env", "inst", "TheSim", "TheWorld", "ThePlayer",
                  "TheCamera", "TheInput", "TheFrontEnd", "TheNet", "STRINGS",
                  "TUNING", "Print", "PLATFORM", "LOC",
                  -- 常用官方 mod API(未定义全局误报开关)
                  "AddPrefabPostInit", "AddComponentPostInit", "AddClassPostConstruct",
                  "AddGlobalClassPostConstruct", "AddSimPostInit", "AddPlayerPostInit",
                  "AddModRPCHandler", "AddClientModRPCHandler", "GetModRPC",
                  "SendModRPCToServer", "GetModConfigData", "modimport",
                },
              },
              workspace = { checkThirdParty = false },
            },
          },
        },
      },
    },
  },
}
