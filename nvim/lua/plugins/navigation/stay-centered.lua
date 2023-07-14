return {
    "arnamak/stay-centered.nvim",
    event = {
        "VeryLazy",
    },
    config = function()
        -- 获取更好的鼠标滚动体验，这个可以当作自带的居中，但是插件的更好
        local buf_height = math.floor(vim.fn.winheight(0) / 2)
        vim.o.scrolloff = buf_height

        require("stay-centered").setup({
            -- 不生效的文件类型
            skip_filetypes = {
                "dashboard",
                "alpha",
                "sagafinder",
                "saga_codeaction",
                "toggleterm",
                "markdown",
            },
        })
    end,
}
