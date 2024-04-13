---@type LazySpec
return {
    "arnamak/stay-centered.nvim",
    event = "VeryLazy",
    cond = false,
    config = function()
        require("stay-centered").setup({
            -- 不生效的文件类型
            skip_filetypes = {
                "dashboard",
                "alpha",
                "sagafinder",
                "saga_codeaction",
                "toggleterm",
                "markdown",
                "TelescopePrompt",
                "dropbar_menu",
                "dapui_hover",
            },
        })
    end,
}
