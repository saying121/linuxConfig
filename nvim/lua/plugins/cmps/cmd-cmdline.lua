return {
    "hrsh7th/cmp-cmdline",
    config = function()
        local cmp = require("cmp")
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "cmdline" },
            }, {
                { name = "path" },
            }),
        })
    end,
}
