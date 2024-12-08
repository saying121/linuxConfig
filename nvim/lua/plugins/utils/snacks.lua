return {
    "folke/snacks.nvim",
    opts = {
        gitbrowse = {
            -- your gitbrowse configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },
    config = function(opts)
        vim.keymap.set("n", "<leader>go", function()
            ---@param opts? snacks.gitbrowse.Config
            Snacks.gitbrowse.open(opts)
        end)
    end,
}
