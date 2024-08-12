local api, keymap, vcmd = vim.api, vim.keymap.set, vim.cmd
require("opts")

package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"

require("public.ft").make_ft()

require("lsp_configs")
-- require("completion")

_G.dapui_for_K = false

local function UfoHover()
    local winid = require("ufo").peekFoldedLinesUnderCursor()
    if winid then
        local bufnr = api.nvim_win_get_buf(winid)
        local keys = { "a", "i", "o", "A", "I", "O", "gd", "gr", "dd" }
        for _, k in ipairs(keys) do
            -- Add a prefix key to fire `trace` action,
            keymap("n", k, "<CR>" .. k, { remap = true, buffer = bufnr })
        end
    end
    return winid
end

api.nvim_create_autocmd({ "CursorHold" }, {
    group = api.nvim_create_augroup("FoldHover", { clear = false }),
    pattern = { "*" },
    callback = function()
        if vim.tbl_contains(vim.treesitter.get_captures_at_cursor(), "include") then
            UfoHover()
        end
    end,
})
api.nvim_create_autocmd({ "FileType" }, {
    group = api.nvim_create_augroup("NoCursorline", { clear = false }),
    pattern = { "dashboard", "alpha" },
    callback = function()
        vim.cmd.setlocal("nocursorline")
    end,
})

api.nvim_create_autocmd("ColorScheme", {
    group = api.nvim_create_augroup("ColorSchemeMod", { clear = false }),
    pattern = "*",
    callback = function()
        vcmd.source(vim.fn.stdpath("config") .. "/colors/mycolors.vim")
    end,
})

function _G.show_documentation()
    if _G.dapui_for_K then
        require("dapui").eval()
    elseif vim.tbl_contains({ "help" }, vim.bo.filetype) then
        vcmd.help(vim.fn.expand("<cword>"))
    elseif vim.tbl_contains({ "man" }, vim.bo.filetype) then
        vcmd.Man(vim.fn.expand("<cword>"))
    elseif not UfoHover() then
        -- vcmd([[Lspsaga hover_doc]])
        vim.lsp.buf.hover()
    end
end

keymap("n", "K", _G.show_documentation, { silent = true })

api.nvim_set_hl(0, "ActiveWindow", { bg = "#17252c" })
api.nvim_set_hl(0, "InactiveWindow", { bg = "#0D1B22" })

-- vim.o.winhighlight = "Normal:Normal,NormalNC:InactiveWindow"

require("lazy-config")
