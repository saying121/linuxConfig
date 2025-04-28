local vfn = vim.fn
local api = vim.api
local lsp = vim.lsp
local util = lsp.util
local diagnostic = vim.diagnostic
local severity = diagnostic.severity
local methods = lsp.protocol.Methods
local log = vim.lsp.log

local lsp_attach = require("public.lsp_attach")

local lsp_attach = require("public.lsp_attach")

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

local function get_locations(split_cmd)
    ---@type lsp.Handler
    local handler = function(_, result, ctx)
        local encoding = "utf-8"
        local client = lsp.get_client_by_id(ctx.client_id)
        if client then
            encoding = client.offset_encoding
        end
        if result == nil or vim.tbl_isempty(result) then
            local _ = log.info() and log.info(ctx.method, "No location found")
            return nil
        end

        if split_cmd then
            -- vim.cmd(split_cmd)
        end

        if not vim.islist(result) then
            util.show_document(result, encoding, { focus = true })
        elseif #result == 1 then
            util.show_document(result[1], encoding, { focus = true })
        else
            vim.ui.select(util.locations_to_items(result, encoding), {
                prompt = "Lsp locations: ",
                ---@param item vim.quickfix.entry
                ---@return string
                format_item = function(item)
                    return item.text
                end,
            }, function(item, _)
                if not item then
                    return
                end
                vim.cmd("tabedit " .. item.filename)
                api.nvim_win_set_cursor(0, { item.lnum, item.col - 1 })
            end)
        end
    end

    return handler
end

lsp.handlers[methods.textDocument_definition] = get_locations("vsplit")
-- lsp.handlers[methods.textDocument_implementation] = get_locations("vsplit")

---@type vim.lsp.Config
local default_lsp_config = {
    capabilities = lsp.protocol.make_client_capabilities(),
}
default_lsp_config.capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}
lsp.config("*", default_lsp_config)

api.nvim_create_autocmd({ "LspAttach" }, {
    group = api.nvim_create_augroup("LspAttachConfig", { clear = true }),
    callback = function(ev)
        local client = lsp.get_client_by_id(ev.data.client_id)
        if not client then
            return
        end

        lsp_attach.on_attach(client, ev.buf)
    end,
})

-- 要禁用某个 lsp 就去改后缀名
local lsp_path = vfn.stdpath("config") .. "/after/lsp"
local file_name_list = vfn.readdir(lsp_path)

local lsps = {}
for _, the_file_name in ipairs(file_name_list) do
    if not vim.endswith(the_file_name, ".lua") then
        goto continue
    end
    local lsp_name = string.sub(the_file_name, 1, #the_file_name - 4)

    table.insert(lsps, lsp_name)

    ::continue::
end

lsp.enable(lsps)
