return {
    ["rust-analyzer"] = {
        completion = {
            autoinport = { enable = true },
            autoself = { enable = true },
            postfix = { enable = true },
            privateEditable = { enable = false },
            snippets = { custom = require("plugins.lsps.rust.snippets") },
        },
        imports = {
            granularity = { enforce = true, group = "crate", enable = true },
            group = { enable = true },
            merge = { glob = false },
            prefer = { no = { std = false } },
            prefix = "plain", -- crate,self
        },
        inlayHints = {
            bindingModeHints = { enable = true },
            chainingHints = { enable = true },
            closingBraceHints = { enable = true, minLines = 40 },
            closureCaptureHints = { enable = true },
            closureReturnTypeHints = { enable = "always" }, -- never
            closureStyle = "impl_fn",
            discriminantHints = { enable = "always" },
            expressionAdjustmentHints = {
                enable = "always",
                hideOutsideUnsafe = false,
                mode = "prefix", --[[ postfix ]]
            },
            lifetimeElisionHints = { enable = "always", useParameterNames = false },
            maxLength = 25,
            parameterHints = { enable = true },
            renderColons = true,
            typeHints = { enable = true, hideClosureInitialization = false, hideNamedConstructor = false },
        },
        rustfmt = { rangeFormatting = { enable = true } },
    },
}
