return {
    "lvimuser/lsp-inlayhints.nvim",
    cond = function()
        local support_list = { lua = true, go = true, javascript = true, typescript = true, c = true, cpp = true }
        if support_list[vim.bo.ft] then
            return true
        end
        return false
    end,
    event = "LspAttach",
    config = function()
        require("lsp-inlayhints").setup({
            inlay_hints = {
                parameter_hints = {
                    show = true,
                    -- prefix = "<- ",
                    prefix = " — ",
                    separator = ", ",
                    remove_colon_start = false,
                    remove_colon_end = true,
                },
                type_hints = {
                    -- type and other hints
                    show = true,
                    prefix = " — ",
                    separator = ", ",
                    remove_colon_start = false,
                    remove_colon_end = false,
                },
                only_current_line = false,
                -- separator between types and parameter hints. Note that type hints are
                -- shown before parameter
                labels_separator = "  ",
                -- whether to align to the length of the longest line in the file
                max_len_align = false,
                -- padding from the left if max_len_align is true
                max_len_align_padding = 1,
                -- highlight group
                highlight = "LspInlayHint",
                -- virt_text priority
                priority = 0,
            },
            enabled_at_startup = true,
            debug_mode = false,
        })

        vim.api.nvim_create_autocmd({ "LspAttach" }, {
            group = vim.api.nvim_create_augroup("LspAttach_inlayhints", { clear = true }),
            callback = function(args)
                if not (args.data and args.data.client_id) then
                    return
                end

                local bufnr = args.buf
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                require("lsp-inlayhints").on_attach(client, bufnr)
            end,
        })
    end,
}
