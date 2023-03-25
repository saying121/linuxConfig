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
        require("plugins.database.vim-dadbd-completion"),
        require("plugins.database.vim-dadbod-ui"),
    },
}
