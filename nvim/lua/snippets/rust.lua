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
            trig = "lcode",
            priority = 20,
            dscr = "让力扣可以编译运行",
        },
        fmt(
            [[
            struct Solution;

            fn main() {
                println!("{:?}", Solution::<>);
            }
            ]],
            {
                i(1, "function"),
            },
            { delimiters = "<>" }
        )
    ),
    s(
        {
            trig = "println",
            priority = 30000,
        },
        fmt([[println!("<>"<>);]], {
            i(1, ""),
            i(2, ""),
        }, { delimiters = "<>" })
    ),
    s("prvar", {
        t([[println!("]]),
        i(1, "variable"),
        t({ ": {" }),
        i(2, ":?"),
        t({ [[}", ]] }),
        d(3, function(args)
            return sn(nil, { i(1, args[1]) })
        end, { 1 }),
        t(");"),
    }),
    s(
        {
            trig = "eprintln",
            priority = 30000,
        },
        fmt([[println!("<>"<>);]], {
            i(1, ""),
            i(2, ""),
        }, { delimiters = "<>" })
    ),
    s(
        {
            trig = "fori",
            priority = 30000,
        },
        fmt(
            [[
            for <> in <> {
                <>
            }
            ]],
            {
                i(1, "var"),
                i(2, ""),
                i(3, "unimplemented!();"),
            },
            { delimiters = "<>" }
        )
    ),
}
