local api = vim.api
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
        api.nvim_create_autocmd({ "BufNew", "BufWinEnter", "BufEnter" }, {
            group = api.nvim_create_augroup("HtmlPreview", { clear = true }),
            pattern = { "*.html" },
            callback = function()
                local opts = { noremap = true, silent = true, buffer = true }
                local keymap = vim.keymap.set

                keymap("n", "<c-p>", ":Bracey<cr>", opts)
                keymap("n", "<c-s>", ":BraceyStop<cr>", opts)
            end,
        })
    end,
}
