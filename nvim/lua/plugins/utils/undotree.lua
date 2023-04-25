return {
    "mbbill/undotree",
    cmd = { "UndotreeToggle", "UndotreeFocus" },
    keys = { "<leader>ut" },
    config = function()
        vim.keymap.set("n", "<leader>ut", ":UndotreeToggle | UndotreeFocus<CR>", { silent = true, noremap = true })

        -- if !exists('g:undotree_WindowLayout')
        vim.g.undotree_WindowLayout = 1
        -- endif

        -- e.g. using 'd' instead of 'days' to save some space.
        -- if !exists('g:undotree_ShortIndicators')
        vim.g.undotree_ShortIndicators = 0
        -- endif

        -- undotree window width
        -- if !exists('g:undotree_SplitWidth')
        -- if g:undotree_ShortIndicators == 1
        -- vim.g.undotree_SplitWidth = 24
        -- else
        vim.g.undotree_SplitWidth = 30
        -- endif
        -- endif

        -- diff window height
        -- if !exists('g:undotree_DiffpanelHeight')
        vim.g.undotree_DiffpanelHeight = 10
        -- endif

        -- auto open diff window
        -- if !exists('g:undotree_DiffAutoOpen')
        vim.g.undotree_DiffAutoOpen = 1
        -- endif

        -- if set, let undotree window get focus after being opened, otherwise
        -- focus will stay in current window.
        -- if !exists('g:undotree_SetFocusWhenToggle')
        vim.g.undotree_SetFocusWhenToggle = 0
        -- endif
    end,
}
