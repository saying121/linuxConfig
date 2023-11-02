return {
    "nvimdev/epo.nvim",
    cond = false,
    config = function()
        require("epo").setup({
            fuzzy = true,
            signature = true,
            debounce = 100,
        })
        local keymap = vim.keymap.set
        keymap("i", "<TAB>", function()
            if vim.fn.pumvisible() == 1 then
                return "<C-n>"
            elseif vim.snippet.jumpable(1) then
                return "<cmd>lua vim.snippet.jump(1)<cr>"
            else
                return "<TAB>"
            end
        end, { expr = true })

        keymap("i", "<S-TAB>", function()
            if vim.fn.pumvisible() == 1 then
                return "<C-p>"
            elseif vim.snippet.jumpable(-1) then
                return "<cmd>lua vim.snippet.jump(-1)<CR>"
            else
                return "<S-TAB>"
            end
        end, { expr = true })
    end,
}
