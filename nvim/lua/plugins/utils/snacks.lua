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
            Snacks.gitbrowse.open()
        end)
    end,
}
