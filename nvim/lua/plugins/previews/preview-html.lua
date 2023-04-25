return {
    "turbio/bracey.vim",
    -- 需要调整nodejs版本
    build = "source /usr/share/nvm/init-nvm.sh; nvm use v16; npm install --prefix server",
    ft = { "html" },
    config = function()
        vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter" }, {
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
