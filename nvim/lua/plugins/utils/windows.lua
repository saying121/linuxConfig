return {
    "anuvyklack/windows.nvim",
    keys = {
        { "mm", mode = { "n", "v" } },
        { "mv", mode = { "n", "v" } },
        { "mh", mode = { "n", "v" } },
        { "me", mode = { "n", "v" } },
        { "ma", mode = { "n", "v" } },
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
        vim.keymap.set({ "n", "v" }, "mm", cmd("WindowsMaximize"), opts)
        vim.keymap.set({ "n", "v" }, "mv", cmd("WindowsMaximizeVertically"), opts)
        vim.keymap.set({ "n", "v" }, "mh", cmd("WindowsMaximizeHorizontally"), opts)
        vim.keymap.set({ "n", "v" }, "me", cmd("WindowsEqualize"), opts)
        vim.keymap.set({ "n", "v" }, "ma", cmd("WindowsToggleAutowidth"), opts)
    end,
}
