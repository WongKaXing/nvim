-- 占位模块，本身不声明任何插件。
-- 作用：lazy 的 import 在「一个 spec 都没找到」时会报
-- "No specs found for module 'plugins'"（见 lazy/core/plugin.lua 的 imported == 0 判定）。
-- 现在插件都按分类放进了子目录，这个文件让顶层 import 依然合法，
-- 于是以后临时试验的单个 spec 文件直接丢进 lua/plugins/ 就能被自动收进来。
return {}
