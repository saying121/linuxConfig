local ft = {
    zsh = "zsh",
}

---@diagnostic disable: unused-local
return {
    "jose-elias-alvarez/null-ls.nvim",
    event = require("public.utils").boot_event(ft),
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                null_ls.builtins.diagnostics.zsh,
            },
        })
    end,
}
