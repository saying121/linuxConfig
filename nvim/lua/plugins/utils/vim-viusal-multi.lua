return {
    "mg979/vim-visual-multi",
    branch = "master",
    keys = {
        { "\\\\", mode = "n" },
        { "<c-down>", mode = "n" },
        { "<c-up>", mode = "n" },
        { "<s-left>", mode = "n" },
        { "<s-right>", mode = "n" },
        { "<c-n>", mode = "n" },
    },
    config = function()
        -- vim.cmd [[ hi VM_Cursor guibg=blue ctermbg=blue guifg=blue ctermfg=blue gui=italic ]]
        -- vim.cmd [[ hi VM_Insert guibg=blue ctermbg=blue guifg=blue ctermfg=blue gui=italic ]]
        -- vim.cmd [[ hi VM_Extend guibg=blue ctermbg=blue guifg=blue ctermfg=blue gui=italic ]]
        -- vim.cmd([[ hi VM_Mono guibg=blue ctermbg=blue guifg=blue ctermfg=blue gui=italic ]])
        -- vim.cmd([[ hi MultiCursor guibg=blue ctermbg=blue guifg=blue ctermfg=blue gui=italic ]])

        vim.g.VM_silent_exit = 1
        vim.g.VM_show_warnings = 0
        vim.g.VM_verbose_commands = 1
        vim.g.VM_theme = "ocean"
    end,
}
