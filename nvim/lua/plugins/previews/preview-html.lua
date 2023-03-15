return {
    "turbio/bracey.vim",
    lazy = true,
    -- 需要调整nodejs版本
    build = "source /usr/share/nvm/init-nvm.sh; nvm use v16; npm install --prefix server",
    ft = { "html" },
    config = function()
        -- local opts = { noremap = true, buffer = true, silent = true }
        local opts = { noremap = true, silent = true }
        vim.keymap.set("n", "<c-p>", ":Bracey<cr>", opts)
        vim.keymap.set("n", "<c-s>", ":BraceyStop<cr>", opts)
    end,
}
