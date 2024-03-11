-- 使用方法 :h dadbod-<database>，在 dadbod-ui 里面按下A连接数据库

---@type LazySpec
return {
    "tpope/vim-dadbod",
    keys = { "<leader><leader>d" },
    cmd = {
        "DBUI",
        "DBUIToggle",
        "DBUIFindBuffer",
    },
    dependencies = require("public.utils").req_lua_files_return_table("plugins/" .. "database" .. "/dependencies"),
}
