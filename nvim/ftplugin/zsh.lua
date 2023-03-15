local bufopts = { noremap = true, silent = true }

vim.keymap.set("n", "<space>f", function()
    vim.lsp.buf.format({ async = true })
end, bufopts)

vim.cmd([[syntax on]])
