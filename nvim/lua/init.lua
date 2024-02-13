require("opts")
local keymap = vim.keymap.set

package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"

--local _ = pcall(require, "lazy-config")
require'lazy-config'

require("lsp_configs")

_G.dapui_for_K = false

local function UfoHover()
    local winid = require("ufo").peekFoldedLinesUnderCursor()
    if winid then
        local bufnr = vim.api.nvim_win_get_buf(winid)
        local keys = { "a", "i", "o", "A", "I", "O", "gd", "gr", "dd" }
        for _, k in ipairs(keys) do
            -- Add a prefix key to fire `trace` action,
            keymap("n", k, "<CR>" .. k, { remap = true, buffer = bufnr })
        end
    end
    return winid
end

vim.api.nvim_create_autocmd({ "CursorHold" }, {
    group = vim.api.nvim_create_augroup("FoldHover", { clear = false }),
    pattern = { "*" },
    callback = function()
        if vim.tbl_contains(vim.treesitter.get_captures_at_cursor(), "include") then
            UfoHover()
        end
    end,
})

function _G.show_documentation()
    if _G.dapui_for_K then
        require("dapui").eval()
    elseif vim.tbl_contains({ "help" }, vim.bo.filetype) then
        vim.cmd("h " .. vim.fn.expand("<cword>"))
    elseif vim.tbl_contains({ "man" }, vim.bo.filetype) then
        vim.cmd("Man " .. vim.fn.expand("<cword>"))
    elseif vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
        require("crates").show_popup()
    elseif not UfoHover() then
        -- vim.cmd([[Lspsaga hover_doc]])
        vim.lsp.buf.hover()
    end
end

keymap("n", "K", _G.show_documentation, { silent = true })

vim.filetype.add({
    extension = {
        foo = "fooscript",
        mir = "rust",
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
        [".log"] = "log",
        [".yuck"] = "yuck",
        [".typ"] = "typst",
        ["LICENSE"] = "license",
        ["license"] = "license",
        ["config"] = "config",
        ["~/.linuxConfig/wayland/waybar/config"] = "json",
        ["~/.config/waybar/config"] = "json",
        -- ["~/.linuxConfig/wayland/swaylock/config"] = "config",
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

vim.api.nvim_set_hl(0, "ActiveWindow", { bg = "#17252c" })
vim.api.nvim_set_hl(0, "InactiveWindow", { bg = "#0D1B22" })

-- vim.o.winhighlight = "Normal:Normal,NormalNC:InactiveWindow"
