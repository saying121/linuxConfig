return {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    cond = function()
        return vim.endswith(vim.fn.argv(0), ".norg")
    end,
    -- tag = "*",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("neorg").setup({
            load = {
                ["core.defaults"] = {}, -- Loads default behaviour
                ["core.concealer"] = {}, -- Adds pretty icons to your documents
                ["core.dirman"] = { -- Manages Neorg workspaces
                    config = {
                        workspaces = {
                            notes = "~/notes",
                        },
                    },
                },
            },
        })
    end,
}
