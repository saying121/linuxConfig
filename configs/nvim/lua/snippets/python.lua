---@diagnostic disable: unused-local
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet

-- see latex infinite list for the idea. Allows to keep adding arguments via choice nodes.
local function py_init()
    return sn(
        nil,
        c(1, {
            t(""),
            sn(1, {
                t(", "),
                i(1),
                d(2, py_init),
            }),
        })
    )
end

-- splits the string of the comma separated argument list into the arguments
-- and returns the text-/insert- or restore-nodes
local function to_init_assign(args)
    local tab = {}
    local a = args[1][1]
    if #a == 0 then
        table.insert(tab, t({ "", "\tpass" }))
    else
        local cnt = 1
        for e in string.gmatch(a, " ?([^,]*) ?") do
            if #e > 0 then
                table.insert(tab, t({ "", "\tself." }))
                -- use a restore-node to be able to keep the possibly changed attribute name
                -- (otherwise this function would always restore the default, even if the user
                -- changed the name)
                table.insert(tab, r(cnt, tostring(cnt), i(nil, e)))
                table.insert(tab, t(" = "))
                table.insert(tab, t(e))
                cnt = cnt + 1
            end
        end
    end
    return sn(nil, tab)
end

return {
    s(
        "pyinit",
        fmt([[def __init__(self{}):{}]], {
            d(1, py_init),
            d(2, to_init_assign, { 1 }),
        })
    ),
}
