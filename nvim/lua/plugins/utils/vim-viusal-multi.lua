return {
    "mg979/vim-visual-multi",
    branch = "master",
    keys = {
        { "\\\\", mode = "n" },
        { "<C-down>", mode = "n" },
        { "<C-up>", mode = "n" },
        { "<S-left>", mode = "n" },
        { "<S-right>", mode = "n" },
        { "<C-n>", mode = "n" },
    },
    config = function()
        vim.g.VM_silent_exit = 1
        vim.g.VM_show_warnings = 0
        vim.g.VM_verbose_commands = 1
        vim.g.VM_theme = "ocean"

        local keymap, opts = vim.keymap.set, { silent = true, noremap = true }
        keymap("n", "\\\\gv", "<Plug>(VM-Reselect-Last)", opts)
    end,
}
