return {
    "JuanZoran/Trans.nvim",
    keys = {
        { "my", mode = { "n", "x" } },
        { "ms", mode = { "n", "x" } },
        { "mi", mode = { "n" } },
    },
    branch = "v2",
    build = function()
        require("Trans").install()
    end,
    dependencies = {
        "kkharji/sqlite.lua",
    },
    config = function()
        local keymap, opts = vim.keymap.set, { noremap = true, silent = true }
        keymap({ "n", "x" }, "my", ":Translate<CR>", opts)
        keymap({ "n", "x" }, "ms", ":TransPlay<CR>", opts)
        keymap("n", "mi", "<Cmd>TranslateInput<CR>", opts)

        require("Trans").setup({
            frontend = {
                hover = {
                    width = 37,
                    height = 27,
                    border = "rounded",
                    -- title = title,
                    keymap = {
                        pageup = "[[",
                        pagedown = "]]",
                        pin = "<leader>[",
                        close = "<leader>]",
                        toggle_entry = "<leader>;",
                    },
                    animation = {
                        -- open = 'fold',
                        -- close = 'fold',
                        open = "slid",
                        close = "slid",
                        interval = 12,
                    },
                    auto_close_events = {
                        "InsertEnter",
                        "CursorMoved",
                        "BufLeave",
                    },
                    auto_play = true,
                    timeout = 3000,
                    spinner = "dots", -- 查看所有样式: /lua/Trans/util/spinner
                    -- spinner = 'moon'
                },
            },
            -- theme = "default",
            theme = "dracula",
            -- theme = 'tokyonight',

            engine = {
                -- baidu = {
                --     appid = '',
                --     appPasswd = '',
                -- },
                -- -- youdao = {
                --     appkey = '',
                --     appPasswd = '',
                -- },
            },
        })
    end,
}
