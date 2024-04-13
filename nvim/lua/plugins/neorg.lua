---@type LazySpec
return {
    "nvim-neorg/neorg",
    ft = "norg",
    version = "*",
    dependencies = {
        "vhyrro/luarocks.nvim",
        priority = 1000,
        config = true,
    },
    config = function()
        vim.wo.conceallevel = 2
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
