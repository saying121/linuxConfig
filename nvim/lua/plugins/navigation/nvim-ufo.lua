return {
    "kevinhwang91/nvim-ufo",
    event = "VeryLazy",
    dependencies = {
        "kevinhwang91/promise-async",
        "neovim/nvim-lspconfig",
        "luukvbaal/statuscol.nvim",
    },
    config = function()
        local handler = function(virtText, lnum, endLnum, width, truncate)
            local newVirtText = {}
            local suffix = ("    %d "):format(endLnum - lnum)
            local sufWidth = vim.fn.strdisplaywidth(suffix)
            local targetWidth = width - sufWidth
            local curWidth = 0
            for _, chunk in ipairs(virtText) do
                local chunkText = chunk[1]
                local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                if targetWidth > curWidth + chunkWidth then
                    table.insert(newVirtText, chunk)
                else
                    chunkText = truncate(chunkText, targetWidth - curWidth)
                    local hlGroup = chunk[2]
                    table.insert(newVirtText, { chunkText, hlGroup })
                    chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    -- str width returned from truncate() may less than 2nd argument, need padding
                    if curWidth + chunkWidth < targetWidth then
                        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                    end
                    break
                end
                curWidth = curWidth + chunkWidth
            end
            table.insert(newVirtText, { suffix, "MoreMsg" })
            return newVirtText
        end

        -- global handler
        -- `handler` is the 2nd parameter of `setFoldVirtTextHandler`,
        -- check out `./lua/ufo.lua` and search `setFoldVirtTextHandler` for detail.
        require("ufo").setup({
            fold_virt_text_handler = handler,
            provider_selector = function(bufnr, filetype, buftype)
                local ftMap = {
                    vim = { "indent", "treesitter" },
                    python = { "indent", "treesitter" },
                    git = "",
                }

                if ftMap[filetype] ~= nil then
                    return ftMap[filetype]
                end

                return { "lsp", "indent" }
            end,
            close_fold_kinds = {
                "imports",
                -- "region",
                -- "comment",
            },
            enable_get_fold_virt_text = true,
            preview = {
                win_config = {
                    border = "rounded",
                    winhighlight = "Normal:Folded",
                    winblend = 0,
                },
                mappings = {
                    scrollB = "<C-b>",
                    scrollF = "<C-f>",
                    scrollU = "<C-u>",
                    scrollD = "<C-d>",
                    scrollE = "<C-e>",
                    scrollY = "<C-y>",
                    jumpTop = "gg",
                    jumpBot = "G",
                    close = "q",
                    switch = "K",
                    trace = "<CR>",
                },
            },
        })

        -- buffer scope handler
        -- will override global handler if it is existed
        -- local bufnr = vim.api.nvim_get_current_buf()
        -- require("ufo").setFoldVirtTextHandler(bufnr, handler)

        local keymap, opts = vim.keymap.set, { silent = true, noremap = true }

        local function goPreviousClosedAndPeek()
            require("ufo").goPreviousClosedFold()
            require("ufo").peekFoldedLinesUnderCursor()
        end
        keymap("n", "[z", goPreviousClosedAndPeek, opts)

        local function goNextClosedAndPeek()
            require("ufo").goNextClosedFold()
            require("ufo").peekFoldedLinesUnderCursor()
        end
        keymap("n", "]z", goNextClosedAndPeek, opts)

        keymap("n", "zR", require("ufo").openAllFolds, opts)
        keymap("n", "zM", require("ufo").closeAllFolds, opts)
        keymap("n", "zr", function()
            require("ufo").openFoldsExceptKinds(require("ufo.config").close_fold_kinds)
        end, opts)

        keymap("n", "zm", function()
            require("ufo").closeFoldsWith(1)
        end, opts) -- closeAllFolds == closeFoldsWith(0)
        for i = 2, 10, 1 do
            keymap("n", i .. "zm", function()
                require("ufo").closeFoldsWith(i)
            end, opts) -- closeAllFolds == closeFoldsWith(0)
        end

        local ft = {
            "dashboard",
            "alpha",
            "dbui",
        }

        vim.api.nvim_create_autocmd({ "BufEnter" }, {
            group = vim.api.nvim_create_augroup("UfoDetachs", { clear = true }),
            pattern = ft,
            callback = function()
                vim.cmd("UfoDetach")
            end,
        })
    end,
}
