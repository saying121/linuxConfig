---@diagnostic disable: unused-local
local ok, _ = pcall(require, "lazy-config")

-- lsp 图标，边框等等
local signs = {
    { name = "DiagnosticSignError", text = " " },
    { name = "DiagnosticSignWarn", text = " " },
    { name = "DiagnosticSignHint", text = " " },
    { name = "DiagnosticSignInfo", text = " " },
}

for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

-- 边框
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "single",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "single",
})

-- vim.lsp.handlers["experimental/serverStatus"] = function(_, result)
--     print("Received serverStatus notification:", vim.inspect(result))
-- end

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = true,
    underline = true,
    float = { border = "single" },
})

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
        ["~/.config/hypr/*.conf"] = "conf",
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
