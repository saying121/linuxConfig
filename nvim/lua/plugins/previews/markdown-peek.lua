return {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    cmd = {
        "PeekOpen",
        "PeekClose",
    },
    config = function()
        local peek = require("peek")

        vim.api.nvim_create_user_command("PeekOpen", function()
            if not peek.is_open() and vim.bo[vim.api.nvim_get_current_buf()].filetype == "markdown" then
                vim.fn.system("i3-msg split horizontal")
                peek.open()
            end
        end, {})

        vim.api.nvim_create_user_command("PeekClose", function()
            if peek.is_open() then
                peek.close()
                vim.fn.system("i3-msg move left")
            end
        end, {})

        peek.setup({
            auto_load = false, -- whether to automatically load preview when
            -- entering another markdown buffer
            close_on_bdelete = true, -- close preview window on buffer delete

            syntax = true, -- enable syntax highlighting, affects performance

            theme = "dark", -- 'dark' or 'light'

            update_on_change = true,

            app = "webview", -- 'webview', 'browser', string or a table of strings
            -- explained below

            filetype = { "markdown" }, -- list of filetypes to recognize as markdown

            -- relevant if update_on_change is true
            throttle_at = 200000, -- start throttling when file exceeds this
            -- amount of bytes in size
            throttle_time = "auto", -- minimum amount of time in milliseconds
            -- that has to pass before starting new render
        })
    end,
}
