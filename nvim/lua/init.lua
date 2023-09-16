---@diagnostic disable: unused-local
local ok, _ = pcall(require, "lazy-config")

vim.g.vimsyn_embed = 'lPr'

if vim.fn.has("nvim-0.10.0") == 1 then
    vim.opt.smoothscroll = true
end

-- 边框
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "single",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "single",
})

vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.g.maplocalleader = ","

vim.filetype.add({
    extension = {
        foo = "fooscript",
        bar = function(path, bufnr)
            -- if some_condition() then
            --     return "barscript",
            --         function(bufnr)
            --             -- Set a buffer variable
            --             vim.b[bufnr].barscript_version = 2
            --         end
            -- end
            return "bar"
        end,
    },
    filename = {
        [".foorc"] = "toml",
        [".log"] = "lot",
        [".yuck"] = "yuck",
        [".typ"] = "typst",
        ["LICENSE"] = "license",
        ["license"] = "license",
        ["~/.linuxConfig/wayland/waybar/config"] = "json",
        ["~/.config/waybar/config"] = "json",
        ["/etc/foo/config"] = "toml",
    },
    pattern = {
        ["(?i)LICENSE"] = "license",
        [".*/etc/foo/.*"] = "fooscript",
        [".*.conf"] = "conf",
        -- ["~/.config/hypr/*.conf"] = "conf",
        ["/proc/bus/input/.*"] = "txt",
        -- Using an optional priority
        [".*/etc/foo/.*%.conf"] = { "dosini", { priority = 10 } },
        -- A pattern containing an environment variable
        ["${XDG_CONFIG_HOME}/foo/git"] = "git",
        ["README.(a+)$"] = function(path, bufnr, ext)
            if ext == "md" then
                return "markdown"
            elseif ext == "rst" then
                return "rst"
            end
        end,
    },
})

local function hi()
    for _, value in ipairs(vim.lsp.get_active_clients()) do
        if value.server_capabilities.documentHighlightProvider then
            for key, _ in pairs(value.attached_buffers) do
                vim.api.nvim_create_autocmd({ "CursorHold" }, {
                    group = vim.api.nvim_create_augroup("LspHighlight", { clear = true }),
                    buffer = key,
                    callback = function()
                        vim.lsp.buf.document_highlight()
                    end,
                })
                vim.api.nvim_create_autocmd({ "CursorMoved" }, {
                    group = vim.api.nvim_create_augroup("LspHighlight1", { clear = true }),
                    buffer = key,
                    callback = function()
                        vim.lsp.buf.clear_references()
                    end,
                })
            end
        end
    end
end

vim.api.nvim_create_autocmd({ "LspAttach" }, {
    group = vim.api.nvim_create_augroup("LspHi", { clear = true }),
    -- buffer = key,
    callback = function()
        hi()
    end,
})

vim.keymap.set("n", "<leader>hl", function()
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
        group = vim.api.nvim_create_augroup("LspHighlight", { clear = true }),
        buffer = 0,
        callback = function()
            vim.lsp.buf.document_highlight()
        end,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
        group = vim.api.nvim_create_augroup("LspHighlight1", { clear = true }),
        buffer = 0,
        callback = function()
            vim.lsp.buf.clear_references()
        end,
    })
end)
