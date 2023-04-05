return {
    "arnamak/stay-centered.nvim",
    event = "VeryLazy",
    config = function()
        -- 获取更好的鼠标滚动体验
        local buf_height = math.floor(vim.fn.winheight(0) / 2)
        vim.o.scrolloff = buf_height

        -- 不生效的文件类型
        vim.api.nvim_set_var("stay-centered#skip_filetypes", {
            "dashboard",
            "lspsagafinder",
            "sagacodeaction",
        })
        require("stay-centered")
    end,
}
