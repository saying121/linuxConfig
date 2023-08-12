local M = {
    {
        "folke/lazy.nvim",
        cmd = { "Lazy" },
    }
}
--
-- local ut = require("public.utils")
--
-- local path = vim.fn.stdpath("config") .. "/lua/plugins"
-- -- 导入plugins文件夹下面的文件夹，里面的文件
-- for _, file_name in pairs(vim.fn.readdir(path)) do
--     if not vim.endswith(file_name, ".lua") then
--         table.insert(M, ut.get_lua_files_return_table("plugins/" .. file_name))
--     end
-- end

return M
