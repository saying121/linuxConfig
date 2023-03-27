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
        require("public.merge").get_dependencies_table("database"),
    },
}
