---@diagnostic disable: unused-local
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

-- TODO: add different filetypes: known_formats = {py = {}, cpp = {}, c = {}}
local known_formats = {
    ["char"] = "%c",
    ["int"] = "%d",
    ["unsigned int"] = "%x",
    ["long"] = "%l",
    ["long long"] = "%ll",
    ["size_t"] = "%z",
}

local function get_type(line, character)
    local bufnr = vim.api.nvim_get_current_buf()
    local position = vim.api.nvim_win_get_cursor(0)
    local mode = vim.fn.mode()
    local params = {
        textDocument = {
            uri = vim.uri_from_bufnr(bufnr),
        },
        position = {
            line = line or position[1] - 1,
            character = character or (mode == "n" and position[2] or position[2] - 1),
        },
    }
    local result = vim.lsp.buf_request_sync(bufnr, "textDocument/hover", params, 100)
    if result and not vim.tbl_isempty(result) then
        for _, res in pairs(result) do
            if res.result then
                local content = vim.split(res.result.contents.value, "\n")
                local todo = content[4]
                local type = todo:match("`([^`]+)")
                if type and #type > 0 then
                    return type
                end
            end
        end
        return nil
    else
        return nil
    end
end

local map_to_specifier_node = function(index, e)
    for k, v in pairs(known_formats) do
        if string.find(e, "^" .. k) then
            return sn(index, t(v .. " "))
        end
    end
    return sn(index, i(1, "unknown "))
end

local default_snip = function(types)
    local nodes = {}
    for index, e in ipairs(types) do
        table.insert(nodes, map_to_specifier_node(index, e))
    end
    local snip = sn(nil, nodes)
    snip.old_state = { types = types } -- NOTE: important for resume states
    return snip
end

local test = fmt(
    [[
printf("{}", {});
]],
    {
        d(2, function(args, _, old_state)
            old_state = old_state or { types = {} }
            local str = args[1][1]
            local last_char = str:sub(#str, #str)
            if last_char == "," or last_char == " " then
                return default_snip(old_state.types)
            end

            local position = vim.api.nvim_win_get_cursor(0)
            local row = position[1] - 1
            local character = position[2] - 1
            local cur_line_text = vim.api.nvim_get_current_line()
            local pattern = [[printf%(".*", ]] -- NOTE: add more language support
            local _, offset = string.find(cur_line_text, pattern)
            local nodes = {}
            local tmp = 1
            local st, ed = string.find(str, "[^ ,]+", tmp)
            local types = {}
            local cnt = 1
            while st do
                local type = get_type(row, offset + st - 1)
                if not type then
                    type = "unknown"
                end
                table.insert(types, type)
                table.insert(nodes, map_to_specifier_node(cnt, type))
                cnt = cnt + 1
                st, ed = string.find(str, "[^ ,]+", ed + 1) -- NOTE: skip ',' and ' '
            end
            local snip = sn(nil, nodes)
            snip.old_state = { types = types }
            return snip
        end, { 1 }),
        i(1, ""),
    }
)

-- ls.add_snippets("all", {
--     s("kpp", test),
-- })
return {
    s("kpp", test),
}
