local api, keymap = vim.api, vim.keymap.set
require("opts")

package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"

require("public.ft").make_ft()

--local _ = pcall(require, "lazy-config")
require("lazy-config")

require("lsp_configs")

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

api.nvim_set_hl(0, "ActiveWindow", { bg = "#17252c" })
api.nvim_set_hl(0, "InactiveWindow", { bg = "#0D1B22" })

-- vim.o.winhighlight = "Normal:Normal,NormalNC:InactiveWindow"
