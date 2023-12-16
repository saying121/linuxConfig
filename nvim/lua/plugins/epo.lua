return {
    "nvimdev/epo.nvim",
    cond = false,
    config = function()
        -- suggested completeopt
        vim.opt.completeopt = "menu,menuone,noselect"
        require("epo").setup({
            fuzzy = true,
            signature = true,
            debounce = 100,
            signature_border = "rounded",
            kind_format = function(k)
                return k:lower():sub(1, 1)
            end,
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
        -- For using enter as completion, may conflict with some autopair plugin
        vim.keymap.set("i", "<cr>", function()
            if vim.fn.pumvisible() == 1 then
                return "<C-y>"
            end
            return "<cr>"
        end, { expr = true, noremap = true })

        -- nvim-autopair compatibility
        vim.keymap.set("i", "<cr>", function()
            if vim.fn.pumvisible() == 1 then
                return "<C-y>"
            end
            return require("nvim-autopairs").autopairs_cr()
        end, { expr = true, noremap = true })
    end,
}
