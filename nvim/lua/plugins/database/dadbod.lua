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
        {
            "kristijanhusak/vim-dadbod-ui",
            config = function()
                vim.keymap.set("n", "<leader>d", "<cmd>DBUIToggle<cr>", { noremap = true, silent = true })

                vim.g.db_ui_tmp_query_location = "~/sql"
                vim.g.db_ui_icons = {
                    expanded = {
                        db = "▾ ",
                        buffers = "▾ ",
                        saved_queries = "▾ ",
                        schemas = "▾ ",
                        schema = "▾ פּ",
                        tables = "▾ 藺",
                        table = "▾ ",
                    },
                    collapsed = {
                        db = "▸ ",
                        buffers = "▸ ",
                        saved_queries = "▸ ",
                        schemas = "▸ ",
                        schema = "▸ פּ",
                        tables = "▸ 藺",
                        table = "▸ ",
                    },
                    saved_query = "",
                    new_query = "璘",
                    tables = "離",
                    buffers = "﬘",
                    add_connection = "",
                    connection_ok = "✓",
                    connection_error = "✕",
                }
            end,
        },
    },
}
