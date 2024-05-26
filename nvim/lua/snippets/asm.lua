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

return {
    s(
        {
            trig = "sys_32",
            dscr = "",
        },
        fmta(
            [[
SYS_EXIT equ 1
SYS_READ equ 3
SYS_WRITE equ 4
STDIN equ 2
STDOUT equ 1
<>
]],
            {
                i(1, ""),
            }
        )
    ),
    s(
        {
            trig = "const",
            dscr = "",
        },
        fmta("<> equ <>", {
            i(1, "STDOUT"),
            i(2, "1"),
        })
    ),
    s(
        {
            trig = "segment",
            dscr = "",
        },
        fmta("segment .<>", {
            c(1, {
                fmta("<>", { i(1, "text") }),
                fmta("<>", { i(1, "data") }),
                fmta("<>", { i(1, "rodata") }),
                fmta("<>", { i(1, "bss") }),
            }),
        })
    ),
    s(
        {
            trig = "section",
            dscr = "",
        },
        fmta("section .<>", {
            c(1, {
                fmta("<>", { i(1, "text") }),
                fmta("<>", { i(1, "data") }),
                fmta("<>", { i(1, "rodata") }),
                fmta("<>", { i(1, "bss") }),
            }),
        })
    ),
    s(
        {
            trig = "global",
            dscr = "",
        },
        fmta("global <>", {
            i(1, "_start"),
        })
    ),
}
