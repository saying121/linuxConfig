---@type LazySpec
return {
    "folke/lazydev.nvim",
    cond = function()
        return string.find(vim.fn.expand("%:p"), "nvim/lua") ~= nil
    end,
    ft = "lua",
    dependencies = {
        { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    },
    opts = {
        -- library = {
        --     -- You can also add plugins you always want to have loaded.
        --     -- Useful if the plugin has globals or types you want to use
        --     -- vim.env.LAZY .. "/LazyVim", -- see below
        -- },
    },
}
