return {
    "arnamak/stay-centered.nvim",
    event = "VeryLazy",
    -- cond = false,
    config = function()
        -- vim.bo.filetype
        -- vim.o.filetype

        -- 不生效的文件类型
        vim.api.nvim_set_var("stay-centered#skip_filetypes", {
            "dashboard",
            "lspsagafinder",
        })
        require("stay-centered")
    end,
}
