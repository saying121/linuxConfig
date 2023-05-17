return {
    "michaelb/sniprun",
    build = "./install.sh",
    keys = {
        { "<leader>sr", mode = "x", desc = "unit test" },
    },
    config = function()
        local keymap,opts = vim.keymap.set,{ noremap = true, silent = true }
        keymap("x", "<leader>sr", "<Plug>SnipRun<CR>", opts)
        keymap("n", "<space>sc", "<Plug>SnipClose<CR>", opts)

        require("sniprun").setup({
            repl_enable = {},
            display = {
                -- "Classic",                    --# display results in the command-line  area
                "VirtualTextOk", --# display ok results as virtual text (multiline is shortened)

                -- "VirtualText",             --# display results as virtual text
                -- "TempFloatingWindow",      --# display results in a floating window
                -- "LongTempFloatingWindow",  --# same as above, but only long results. To use with VirtualText[Ok/Err]
                -- "Terminal",                --# display results in a vertical split
                -- "TerminalWithCode",        --# display results and code history in a vertical split
                -- "NvimNotify",              --# display with the nvim-notify plugin
                -- "Api"                      --# return output to a programming interface
            },
            display_options = {
                terminal_width = 45,
                notification_timeout = 5, --# timeout for nvim_notify output
            },
            snipruncolors = {
                SniprunVirtualTextOk = { bg = "#66eeff", fg = "#000000", ctermbg = "Cyan", cterfg = "Black" },
                SniprunFloatingWinOk = { fg = "#66eeff", ctermfg = "Cyan" },
                SniprunVirtualTextErr = { bg = "#881515", fg = "#000000", ctermbg = "DarkRed", cterfg = "Black" },
                SniprunFloatingWinErr = { fg = "#881515", ctermfg = "DarkRed" },
            },
        })
    end,
}
