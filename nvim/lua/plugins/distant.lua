return {
    "chipsenkbeil/distant.nvim",
    cond = true,
    build = '[ "$(command -v distant)" ] || cargo install distant',
    version = "v0.2",
    cmd = {
        "DistantInstall",
        "DistantLaunch",
    },
    config = function()
        require("distant"):setup()
    end,
}
