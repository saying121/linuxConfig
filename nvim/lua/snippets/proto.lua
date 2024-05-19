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

local snippets = {
    s(
        {
            trig = "enum",
            dscr = "",
        },
        fmta(
            [[
enum <> {
  <>
}
            ]],
            {
                i(1, "name"),
                i(2, ""),
            }
        )
    ),
    s(
        {
            trig = "oneof",
            dscr = "",
        },
        fmta(
            [[
oneof <> {
  <>
}
            ]],
            {
                i(1, "name"),
                i(2, ""),
            }
        )
    ),
    s(
        {
            trig = "message",
            dscr = "",
        },
        fmta(
            [[
message <> {
  <>
}
            ]],
            {
                i(1, "msg"),
                i(2, ""),
            }
        )
    ),
    s(
        {
            trig = "package",
            dscr = "",
        },
        fmta(
            [[
package <>;
            ]],
            {
                i(1, "name"),
            }
        )
    ),
    s(
        {
            trig = "syntax",
            dscr = "",
        },
        fmta(
            [[
syntax = "<>";
            ]],
            {
                i(1, "proto3"),
            }
        )
    ),
    s(
        {
            trig = "service",
            dscr = "",
        },
        fmta(
            [[
service <> {
  rpc <>(<>) returns (<>);
}
            ]],
            {
                i(1, ""),
                i(2, "func"),
                i(3, "Request"),
                i(4, "Reply"),
            }
        )
    ),
    s(
        {
            trig = "rpc",
            dscr = "",
        },
        fmta(
            [[
    rpc <>(<>) returns (<>);
            ]],
            {
                i(1, "func"),
                i(2, "Request"),
                i(3, "Reply"),
            }
        )
    ),
}

local proto_types = {
    double = "f64",
    float = "f32",
    int32 = "i32",
    int64 = "i64",
    uint32 = "u32",
    uint64 = "u64",
    sint32 = "i32",
    sint64 = "i64",
    fixed32 = "u32",
    fixed64 = "u64",
    sfixed32 = "i32",
    sfixed64 = "i64",
    string = "String",
    bytes = "Vec<u8>",

    Vec = "bytes",
    f32 = "float",
    f64 = "double",
    i32 = { "int32", "sfixed32", "sint32" },
    i64 = { "int64", "sfixed64", "sint64" },
    u32 = { "fixed32", "uint32" },
    u64 = { "fixed64", "uint64" },

    bool = "bool",
    map = "HashMap, BtreeMap",
}
for name, describe in pairs(proto_types) do
    if type(describe) == "string" then
        table.insert(
            snippets,
            s(
                {
                    trig = name,
                    priority = 30000,
                    dscr = describe,
                },
                fmta(name .. [[ <> = <>; ]], {
                    i(1, ""),
                    i(2, "1"),
                })
            )
        )
    elseif type(describe) == "table" then
        -- local ds  =
        -- table.insert(
        --     snippets,
        --     s(
        --         {
        --             trig = name,
        --             priority = 30000,
        --             dscr = describe,
        --         },
        --         fmta(name .. [[ <> = <>; ]], {
        --             i(1, ""),
        --             i(2, "1"),
        --         })
        --     )
        -- )
    end
end
return snippets
