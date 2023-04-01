-- lua =vim.lsp.get_active_clients()
--
LspInfos = {}
function LspInfos.get_lsp_name()
    for i = 1, #vim.lsp.get_active_clients(), 1 do
        print(vim.lsp.get_active_clients()[i]["name"])
    end
    -- return vim.lsp.get_active_clients()[1]['name']
end

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set
keymap("n", "<leader>ls", LspInfos.get_lsp_name, opts)
keymap("n", "<leader>ll", ":lua =vim.lsp.get_active_clients()<CR>", opts)
