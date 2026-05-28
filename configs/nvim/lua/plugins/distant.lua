---@type LazySpec
return {
    "chipsenkbeil/distant.nvim",
    cond = true,
    cmd = { "Distant" },
    build = '[[ "$(command -v distant)" = "" ]] && cargo install distant',
    version = "*",
    -- cmd = {
    --     "DistantInstall",
    --     "DistantLaunch",
    -- },

    config = function()
        require("distant"):setup()
    end,
}
