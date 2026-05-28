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

local ints = { 8, 16, 32, 64 }

local all = {
    s({
        trig = "bool",
        dscr = "",
    }, fmta("bool", {})),
    s({
        trig = "f32",
        dscr = "",
    }, fmta("f32", {})),
    s({
        trig = "f64",
        dscr = "",
    }, fmta("f64", {})),
    s({
        trig = "char",
        dscr = "",
    }, fmta("char", {})),
    s({
        trig = "string",
        dscr = "",
    }, fmta("string", {})),
    s({
        trig = "list",
        dscr = "",
    }, fmt("list<{}>", { i(1, "") })),
    s({
        trig = "option",
        dscr = "like `Option`",
    }, fmt("option<{}>", { i(1, "") })),
    s(
        {
            trig = "result",
            dscr = "",
        },
        fmt("result<{}, {}>", {
            i(1, "T"),
            i(2, "E"),
        })
    ),
    s(
        {
            trig = "tuple",
            dscr = "like `(a, b, c)`",
        },
        fmt("tuple<{},{}>", {
            i(1, ""),
            i(2, ""),
        })
    ),
    s(
        {
            trig = "record",
            dscr = "like `struct`",
        },
        fmta(
            [[record <> {
    <>
}]],
            {
                i(1, ""),
                i(2, ""),
            }
        )
    ),
    s(
        {
            trig = "variant",
            dscr = "like `enum Name { A(i32), B }`",
        },
        fmta(
            [[variant <> {
    <>
}]],
            {
                i(1, ""),
                i(2, ""),
            }
        )
    ),
    s(
        {
            trig = "enum",
            dscr = "like `enum Name { A, B }`",
        },
        fmta(
            [[enum <> {
    <>
}]],
            {
                i(1, ""),
                i(2, ""),
            }
        )
    ),
    s(
        {
            trig = "resource",
            dscr = "mean can't copy",
        },
        fmta(
            [[resource <> {
    <>
}]],
            {
                i(1, ""),
                i(2, ""),
            }
        )
    ),
    s(
        {
            trig = "flags",
            dscr = "all `true/false`",
        },
        fmta(
            [[flags <> {
    <>
}]],
            {
                i(1, ""),
                i(2, ""),
            }
        )
    ),
    s(
        {
            trig = "type",
            dscr = "all `true/false`",
        },
        fmta([[type <> = <>;]], {
            i(1, ""),
            i(2, ""),
        })
    ),
    s(
        {
            trig = "fn",
            dscr = "",
        },
        fmta([[<>: func(<>);]], {
            i(1, "name"),
            i(2, ""),
        })
    ),
    s(
        {
            trig = "fnr",
            dscr = "",
        },
        fmt("{}: func({}) -> {};", {
            i(1, "name"),
            i(2, ""),
            i(3, "type"),
        })
    ),
    s(
        {
            trig = "interface",
            dscr = "一组命名的类型和函数",
        },
        fmta(
            [[interface <> {
    <>
}]],
            {
                i(1, ""),
                i(2, ""),
            }
        )
    ),
    s(
        {
            trig = "world",
            dscr = "描述一组 exprots 和 imports",
        },
        fmta(
            [[world <> {
    <>
}]],
            {
                i(1, ""),
                i(2, ""),
            }
        )
    ),
    s({
        trig = "include",
        dscr = "共享 exports 和 imports",
    }, fmta([[include <>;]], { i(1, "") })),
    s({
        trig = "export",
        dscr = "需要自己实现这些东西",
    }, fmta([[export <>;]], { i(1, "") })),
    s({
        trig = "import",
        dscr = "需要外部实现这些东西",
    }, fmta([[import <>;]], { i(1, "") })),
    s({
        trig = "package",
        dscr = "",
    }, fmta([[package <>;]], { i(1, "") })),
}

for _, value in ipairs(ints) do
    local sint = "i" .. value
    table.insert(
        all,
        s({
            trig = sint,
            dscr = "",
        }, fmta(sint .. " ", {}))
    )

    local uint = "u" .. value
    table.insert(
        all,
        s({
            trig = uint,
            dscr = "",
        }, fmta(uint, {}))
    )
end

return all
