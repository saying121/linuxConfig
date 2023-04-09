return {
    "lukas-reineke/indent-blankline.nvim",
    cond = false,
    event = "VeryLazy",
    config = function()
        -- vim.cmd [[hi IndentBlanklineIndent1 guibg=#9D7CD8 guifg=#9D7CD8]]
        require("indent_blankline").setup({
            space_char_blankline = " ",
            show_current_context = false,
            -- show_current_context_start = true,
        })
    end,
}
