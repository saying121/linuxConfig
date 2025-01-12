return {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    ---@type snacks.Config
    opts = {
        bigfile = {
            enabled = true,
            size = 1.5 * 1024 * 1024, -- 1.5MB
        },
        gitbrowse = {
            -- your gitbrowse configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        -- TODO: can't remove foldlevel number
        ---@type snacks.statuscolumn.Config
        statuscolumn = {
            enabled = false,
            left = { "mark", "sign" }, -- priority of signs on the left (high to low)
            right = { "fold", "git" }, -- priority of signs on the right (high to low)
            folds = {
                open = false, -- show open fold icons
                git_hl = false, -- use Git Signs hl for fold icons
            },
            git = {
                -- patterns to match Git signs
                patterns = { "GitSign", "MiniDiffSign" },
            },
            refresh = 50, -- refresh at most every 50ms
        },
    },
    config = function(opts)
        vim.keymap.set({ "n", "x" }, "<leader>go", function()
            Snacks.gitbrowse.open()
        end)
    end,
}
