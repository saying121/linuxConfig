---@type LazySpec
return {
    "turbio/bracey.vim",
    cond = false,
    build = "fnm use 16; npm install --prefix server",
    event = {
        "UIEnter *.html",
        "BufNew *.html",
    },
    config = function()
        vim.api.nvim_create_autocmd({ "BufNew", "BufWinEnter", "BufEnter" }, {
            group = vim.api.nvim_create_augroup("HtmlPreview", { clear = true }),
            pattern = { "*.html" },
            callback = function()
                local opts = { noremap = true, silent = true, buffer = true }

                vim.keymap.set("n", "<c-p>", ":Bracey<cr>", opts)
                vim.keymap.set("n", "<c-s>", ":BraceyStop<cr>", opts)
            end,
        })
    end,
}
