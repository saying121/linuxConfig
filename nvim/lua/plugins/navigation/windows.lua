return {
    "anuvyklack/windows.nvim",
    keys = {
        { "mm", mode = { "n", "x" } },
        { "mv", mode = { "n", "x" } },
        { "mh", mode = { "n", "x" } },
        { "me", mode = { "n", "x" } },
        { "ma", mode = { "n", "x" } },
    },
    dependencies = {
        "anuvyklack/middleclass",
        "anuvyklack/animation.nvim",
    },
    config = function()
        vim.o.winwidth = 10
        vim.o.winminwidth = 10
        vim.o.equalalways = false
        require("windows").setup({
            autowidth = {
                --		       |windows.autowidth|
                enable = false,
                winwidth = 5, --		        |windows.winwidth|
                filetype = { --	      |windows.autowidth.filetype|
                    help = 2,
                },
            },
            ignore = {
                --			  |windows.ignore|
                buftype = { "quickfix" },
                filetype = { "NvimTree", "neo-tree", "undotree", "gundo" },
            },
            animation = {
                enable = true,
                duration = 300,
                fps = 30,
                easing = "in_out_sine",
            },
        })

        local function cmd(command)
            return table.concat({ "<Cmd>", command, "<CR>" })
        end

        local opts = { noremap = true, silent = true }
        local keymap = vim.keymap.set
        keymap({ "n", "x" }, "mm", cmd("WindowsMaximize"), opts)
        keymap({ "n", "x" }, "mv", cmd("WindowsMaximizeVertically"), opts)
        keymap({ "n", "x" }, "mh", cmd("WindowsMaximizeHorizontally"), opts)
        keymap({ "n", "x" }, "me", cmd("WindowsEqualize"), opts)
        keymap({ "n", "x" }, "ma", cmd("WindowsToggleAutowidth"), opts)
    end,
}
