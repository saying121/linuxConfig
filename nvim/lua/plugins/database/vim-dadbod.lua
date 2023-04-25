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
