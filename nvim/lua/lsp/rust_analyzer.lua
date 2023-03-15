return {
    ["rust-analyzer"] = {
        cargo = {
            allFeatures = true,
            runBuildScripts = { enable = true },
            buildScripts = { enable = true },
        },
        checkOnSave = {
            enable = true,
            command = "clippy",
        },
        diagnostics = {
            enable = true,
            experimental = { enable = true },
            previewRustcOutput = true,
        },
        inlayHints = {
            bindingModeHints = { enable = false },
            chainingHints = { enable = true },
            closingBraceHints = {
                enable = true,
                minLines = 25,
            },
            closureReturnTypeHints = { enable = "always" },
            discriminantHints = { enable = "always" },
            expressionAdjustmentHints = {
                enable = "never",
                hideOutsideUnsafe = false,
                mode = "prefix",
            },
            lifetimeElisionHints = {
                enable = "never",
                useParameterNames = false,
            },
            maxLength = 25,
            parameterHints = { enable = true },
            reborrowHints = { enable = "always" },
            renderColons = true,
            typeHints = {
                enable = true,
                hideClosureInitialization = false,
                hideNamedConstructor = false,
            },
        },
        rustfmt = {
            rangeFormatting = { enable = false },
        },
    },
}
