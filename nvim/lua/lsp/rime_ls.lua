local rime_on_attach = function(client, _)
    local toggle_rime = function()
        client.request("workspace/executeCommand", { command = "rime-ls.toggle-rime" }, function(_, result, ctx, _)
            if ctx.client_id == client.id then
                vim.g.rime_enabled = result
            end
        end)
    end
    vim.keymap.set({ "n", "i" }, "<A-g>", function()
        toggle_rime()
    end)
    vim.keymap.set("n", "<leader>rs", function()
        vim.lsp.buf.execute_command({ command = "rime-ls.sync-user-data" })
    end)
end

return {
    init_options = {
        enabled = vim.g.rime_enabled,
        shared_data_dir = "/usr/share/rime-data",
        user_data_dir = vim.fn.getenv("HOME") .. "/.local/share/rime-ls-nvim",
        log_dir = vim.fn.getenv("HOME") .. "/.local/share/rime-ls-nvim",
        max_candidates = 9,
        -- trigger_characters = { '::' },
    },
    on_attach = rime_on_attach,
    settings = {},
}
