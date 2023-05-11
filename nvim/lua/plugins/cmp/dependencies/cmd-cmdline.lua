return {
    "hrsh7th/cmp-cmdline",
    config = function()
        local cmp = require("cmp")
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer", priority = 1000 },
                -- { name = "rg", priority = 900 },
            },
            {
                { name = "spell", priority = 800 },
                -- { name = "rime", priority = 800 },
            },
        })
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "cmdline", priority = 1000 },
                { name = "path", priority = 900 },
            }, {
                { name = "buffer", priority = 800 },
                { name = "rg", priority = 700 },
            }, {
                { name = "spell", priority = 600 },
            }),
        })
    end,
}
