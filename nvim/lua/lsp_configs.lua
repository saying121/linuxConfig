local vfn = vim.fn
local api = vim.api
local lsp = vim.lsp
local util = lsp.util
local diagnostic = vim.diagnostic
local severity = diagnostic.severity

local signs = {
    [severity.ERROR] = "", --
    [severity.WARN] = "", --
    [severity.INFO] = "󰋽", --
    [severity.HINT] = "", --📌 
}
local diagnostic_hl = {
    [severity.ERROR] = "DiagnosticSignError",
    [severity.WARN] = "DiagnosticSignWarn",
    [severity.INFO] = "DiagnosticSignInfo",
    [severity.HINT] = "DiagnosticSignHint",
}
---@diagnostic disable-next-line: unused-local
local virtual_text = {
    severity = false,
    spacing = 4,
    -- severity = {
    --     max = diagnostic.severity.ERROR,
    --     min = diagnostic.severity.WARN,
    -- },

    ---@param diag vim.Diagnostic
    ---@param i integer
    ---@param total integer
    ---@return string
    prefix = function(diag, i, total)
        if signs[diag.severity] then
            return signs[diag.severity] .. i .. "/" .. total .. ":"
        else
            return "" --"●"
        end
    end,
    -- source = "if_many", --- boolean

    ---@param diag vim.Diagnostic
    ---@return string
    format = function(diag)
        -- if signs[diag.severity] then
        --     return signs[diag.severity] .. ": " .. diag.message
        -- else
        return diag.message
        -- end
    end,
}

diagnostic.config({
    virtual_lines = false,
    -- virtual_lines = {
    --     current_line = true,
    -- },
    virtual_text = false,
    -- virtual_text = virtual_text,
    float = { border = "single" },
    severity_sort = true,
    signs = {
        priority = 10,
        text = signs,
        -- linehl = diagnostic_hl,
        numhl = diagnostic_hl,
        texthl = diagnostic_hl,
    },
    underline = false,
    update_in_insert = false,
})

local function goto_definition(split_cmd)
    local log = vim.lsp.log

    -- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
    local handler = function(_, result, ctx)
        if result == nil or vim.tbl_isempty(result) then
            local _ = log.info() and log.info(ctx.method, "No location found")
            return nil
        end

        if split_cmd then
            vim.cmd(split_cmd)
        end

        if vim.islist(result) then
            util.show_document(result[1], "utf-8", { focus = true })

            if #result > 1 then
                -- util.set_qflist(util.locations_to_items(result))
                vfn.setqflist(util.locations_to_items(result))
                api.nvim_command("copen")
                api.nvim_command("wincmd p")
            end
        else
            util.show_document(result, "utf-8", { focus = true })
        end
    end

    return handler
end

lsp.handlers["textDocument/definition"] = goto_definition("vsplit")
