local vfn = vim.fn
local api = vim.api
---@type LazySpec
return {
    "chomosuke/typst-preview.nvim",
    build = function()
        require("typst-preview").update()
    end,
    ft = "typst",
    config = function()
        api.nvim_create_autocmd({ "BufNew", "BufWinEnter", "BufEnter" }, {
            group = api.nvim_create_augroup("TypstPreview", { clear = true }),
            pattern = { "typst", "*.typ" },
            callback = function()
                local opts = { noremap = true, silent = true, buffer = true }

                vim.keymap.set("n", "<c-p>", function()
                    vim.cmd.TypstPreview()
                end, opts)
            end,
        })

        require("typst-preview").setup({
            -- Setting this true will enable printing debug information with print()
            debug = false,
            -- This function will be called to determine the root of the typst project
            get_root = function(bufnr_of_typst_buffer)
                return vfn.getcwd()
                -- return vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h")
            end,
        })
    end,
}
