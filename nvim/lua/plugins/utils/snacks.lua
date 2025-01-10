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
    },
    config = function(opts)
        vim.keymap.set({ "n", "x" }, "<leader>go", function()
            Snacks.gitbrowse.open()
        end)
    end,
}
