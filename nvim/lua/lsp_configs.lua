local methods = vim.lsp.protocol.Methods
local severity = vim.diagnostic.severity

local signs = {
    [severity.ERROR] = "", --
    [severity.WARN] = "", --
    [severity.INFO] = "", --
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
    --     max = vim.diagnostic.severity.ERROR,
    --     min = vim.diagnostic.severity.WARN,
    -- },

    ---@param diagnostic vim.Diagnostic
    ---@param i integer
    ---@param total integer
    ---@return string
    prefix = function(diagnostic, i, total)
        if signs[diagnostic.severity] then
            return signs[diagnostic.severity] .. i .. "/" .. total .. ":"
        else
            return "" --"●"
        end
    end,
    -- source = "if_many", --- boolean

    ---@param diagnostic vim.Diagnostic
    ---@return string
    format = function(diagnostic)
        -- if signs[diagnostic.severity] then
        --     return signs[diagnostic.severity] .. ": " .. diagnostic.message
        -- else
        return diagnostic.message
        -- end
    end,
}

vim.diagnostic.config({
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

-- 边框
vim.lsp.handlers[methods.textDocument_hover] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "single",
})
vim.lsp.handlers[methods.textDocument_signatureHelp] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "single",
})

local function goto_definition(split_cmd)
  local util = vim.lsp.util
  local log = require("vim.lsp.log")
  local api = vim.api

  -- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
  local handler = function(_, result, ctx)
    if result == nil or vim.tbl_isempty(result) then
      local _ = log.info() and log.info(ctx.method, "No location found")
      return nil
    end

    if split_cmd then
      vim.cmd(split_cmd)
    end

    if vim.tbl_islist(result) then
      util.jump_to_location(result[1])

      if #result > 1 then
        -- util.set_qflist(util.locations_to_items(result))
        vim.fn.setqflist(util.locations_to_items(result))
        api.nvim_command("copen")
        api.nvim_command("wincmd p")
      end
    else
      util.jump_to_location(result)
    end
  end

  return handler
end

vim.lsp.handlers["textDocument/definition"] = goto_definition('vsplit')
