---@type LazySpec
return {
    "mbbill/undotree",
    cmd = { "UndotreeToggle", "UndotreeFocus" },
    keys = { "<leader>ut" },
    config = function()
        vim.keymap.set("n", "<leader>ut", ":UndotreeToggle | UndotreeFocus<CR>", { silent = true, noremap = true })

        local vfn = vim.fn
        if not vfn.exists("g:undotree_WindowLayout") then
            vim.g.undotree_WindowLayout = 1
        end

        -- e.g. using 'd' instead of 'days' to save some space.
        if not vfn.exists("g:undotree_ShortIndicators") then
            vim.g.undotree_ShortIndicators = 0
        end

        -- undotree window width
        if not vfn.exists("g:undotree_SplitWidth") then
            if vim.g.undotree_ShortIndicators == 1 then
                vim.g.undotree_SplitWidth = 24
            else
                vim.g.undotree_SplitWidth = 30
            end
        end

        -- diff window height
        if not vfn.exists("g:undotree_DiffpanelHeight") then
            vim.g.undotree_DiffpanelHeight = 10
        end

        -- auto open diff window
        if vfn.exists("g:undotree_DiffAutoOpen") then
            vim.g.undotree_DiffAutoOpen = 1
        end

        -- if set, let undotree window get focus after being opened, otherwise
        -- focus will stay in current window.
        if not vfn.exists("g:undotree_SetFocusWhenToggle") then
            vim.g.undotree_SetFocusWhenToggle = 0
        end
    end,
}
