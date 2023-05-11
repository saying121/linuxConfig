return {
    "mg979/vim-visual-multi",
    branch = "master",
    keys = {
        { "\\\\", mode = "n" },
        { "<C-M-k>", mode = "n" },
        { "<C-M-j>", mode = "n" },
        { "<S-left>", mode = "n" },
        { "<S-right>", mode = "n" },
        { "<C-n>", mode = "n" },
    },
    config = function()
        vim.g.VM_silent_exit = 1
        vim.g.VM_show_warnings = 0
        vim.g.VM_verbose_commands = 1
        vim.g.VM_theme = "ocean"
        vim.g.VM_set_statusline = 3

        local keymap, opts = vim.keymap.set, { silent = true, noremap = true }
        keymap("n", "\\\\gv", "<Plug>(VM-Reselect-Last)", opts)
        keymap("n", "<C-M-k>", "<Plug>(VM-Add-Cursor-Up)", opts)
        keymap("n", "<C-M-j>", "<Plug>(VM-Add-Cursor-Down)", opts)
    end,
}
