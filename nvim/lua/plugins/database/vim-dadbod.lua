-- 使用方法 :h dadbod-<database>，在 dadbodui 里面按下A连接数据库

return {
    "tpope/vim-dadbod",
    keys = {
        "<leader>d",
    },
    cmd = {
        "DBUI",
        "DBUIToggle",
        "DBUIFindBuffer",
    },
    dependencies = {
        require("public.utils").get_dependencies_table("plugins/" .. "database" .. "/dependencies"),
    },
}
