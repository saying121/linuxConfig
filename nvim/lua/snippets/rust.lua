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

local rust_types = {
    Result = "Ok(())",
    Option = "Some(())",
    Vec = "vec![]",
}
local rust_types_exact = {
    bool = "false",
    Self = "Self {  }",

    i8 = "0",
    i16 = "0",
    i32 = "0",
    i64 = "0",
    i128 = "0",
    u8 = "0",
    u16 = "0",
    u32 = "0",
    u64 = "0",
    u128 = "0",
}

local function get_rt_value()
    local temp = vim.fn.searchpos("fn ", "bcn", vim.fn.line("w0"))
    local pos = { math.max(temp[1] - 1, 0), temp[2] }
    local line = pos[1]
    local line_str = vim.api.nvim_buf_get_lines(0, line, line + 1, false)[1]
    local startIdx, endIdx = string.find(line_str, "->%s*(.-)%s*{")

    if startIdx and endIdx then
        local result = string.sub(line_str, startIdx + 2, endIdx - 1)
        result = string.gsub(result, "^%s*(.-)%s*$", "%1")

        local exact = rust_types_exact[result]
        if exact then
            return exact
        end

        for key, value in pairs(rust_types) do
            if string.find(result, key) then
                return value
            end
        end
    else
        return ""
    end
end

local map_to_specifier_node = function(index, e)
    return sn(index, i(1, "{} "))
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
println!("{}", {});
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
            local pattern = [[println!%(".*", ]] -- NOTE: add more language support
            local nodes = {}
            local tmp = 1
            local st, ed = string.find(str, "[^ ,]+", tmp)
            local types = {}
            local cnt = 1
            while st do
                local type = "{}"
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

return {
    s({
        trig = "rt",
        dscr = "根据返回类型返回一个默认值",
    }, {
        t("return "),
        d(1, function(args)
            return sn(nil, i(1, get_rt_value()))
        end, {}),
        t(";"),
    }),
    s("kpp", test),
    s(":turbofish", { t({ "::<" }), i(0), t({ ">" }) }),
    s(
        {
            trig = "pub-trait",
            dscr = "pub trait() { … }",
        },
        fmta(
            [[
            pub trait <> {
                <>
            }
            ]],
            {
                i(1, "Name"),
                i(2, ""),
            }
        )
    ),
    s(
        {
            trig = "main",
            dscr = "fn main() { … }",
        },
        fmta(
            [[
            fn main() {
                <>
            }
            ]],
            { i(1, [[unimplemented!();]]) }
        )
    ),
    s(
        {
            trig = "tokio_main",
            dscr = "#[tokio::main]",
        },
        fmta(
            [[
            #[tokio::main]
            async fn main() {
                <>
            }
            ]],
            { i(1, [[unimplemented!();]]) }
        )
    ),
    s({
        trig = "tokio_add_head",
        dscr = "add #[tokio::main]",
    }, fmta("#[tokio::main]", {})),
    s(
        {
            trig = "tokio_test",
            dscr = "add #[tokio::test]",
        },
        fmta("#[tokio::test(<>worker_threads = <>)]", {
            i(1, [[flavor = "multi_thread", ]]),
            i(2, "10"),
        })
    ),
    s(
        {
            trig = "feature",
            dscr = "add #![feature(…)]",
        },
        fmta("#![feature(<>)]", {
            i(1, ""),
        })
    ),
    s(
        {
            trig = "extern-crate",
            dscr = "extern crate …;",
        },
        fmta("extern crate <>;", {
            i(1, "name"),
        })
    ),
    s(
        {
            trig = "extern-fn",
            dscr = 'extern "C" fn …(…) { … }',
        },
        fmta(
            [[
extern "C" fn []([]: []) -> [] {
    []
}
        ]],
            {
                i(1, "name"),
                i(2, "arg"),
                i(3, "Type"),
                i(4, "RetType"),
                i(5, "// add code here"),
            },
            { delimiters = "[]" }
        )
    ),
    s(
        {
            trig = "extern-mod",
            dscr = 'extern "C" { … }',
        },
        fmta(
            [[
extern "<>" {
    <>
}
        ]],
            {
                i(1, "C"),
                i(2, "// add code here"),
            }
        )
    ),
    s({
        trig = "alloc_add",
        dscr = "add extern crate alloc;",
    }, fmta("extern crate alloc;", {})),
    s(
        {
            trig = "static",
            dscr = "static …: … = …;",
        },
        fmta("static <>: <> = <>;", {
            i(1, "STATIC"),
            i(2, "Type"),
            i(3, "init"),
        })
    ),
    s(
        {
            trig = "fnr",
            dscr = "fn …(…) -> … { … }",
        },
        fmta(
            [[
            fn []([]) -> [] {
                []
            }
            ]],
            {
                i(1, "name"),
                c(2, {
                    i(""),
                    fmta("<>: <>", { i(1, "arg"), i(2, "Type") }),
                    fmta("<>: <>, <>: <>", {
                        i(1, "arg"),
                        i(2, "Type"),
                        i(3, "arg"),
                        i(4, "Type"),
                    }),
                }),
                i(3, "!"),
                i(4, "unimplemented!()"),
            },
            { delimiters = "[]" }
        )
    ),
    s("prvar", {
        t([[println!(r##"(| ]]),
        d(4, function(args)
            return sn(nil, { i(1, args[1]) })
        end, { 1 }),
        t({ " |) " }),
        i(3, "->"),
        t({ " {" }),
        i(2, ":#?"),
        t({ [[}"##, ]] }),
        i(1, "variable"),
        t(");"),
    }),
    s(
        "dbg",
        fmta(
            [[
        #[cfg(debug_assertions)]
        dbg!(<>);
        ]],
            {
                i(1, "variable"),
            }
        )
    ),
    s(
        "dbgr",
        fmta(
            [[
        #[cfg(debug_assertions)]
        dbg!(&<>);
        ]],
            {
                i(1, "variable"),
            }
        )
    ),
    s(
        {
            trig = "eprintln",
            priority = 30000,
        },
        fmta([[eprintln!("<>"<>);]], {
            i(1, ""),
            i(2, ""),
        })
    ),
    s(
        {
            trig = "allow",
            dscr = "#![allow(…)]",
        },
        fmt("#![allow({})]", {
            i(1, ""),
        })
    ),
    s({
        trig = "cfg",
        dscr = "#[cfg(…)]",
    }, fmt("#[cfg({})]", { i(1, "") })),
    s(
        {
            trig = "cfg_attr",
            dscr = "#[cfg_attr(…, …)]",
        },
        fmt("#[cfg_attr({}, {})]", {
            i(1, ""),
            i(2, ""),
        })
    ),
    s(
        {
            trig = "const",
            dscr = "const …: … = …;",
        },
        fmt("const {}: {} = {};", {
            i(1, "CONST"),
            i(2, "Type"),
            i(3, "init"),
        })
    ),
    s({
        trig = "deny",
        dscr = "#![deny(…)]",
    }, fmt("#![deny({})]", { i(1, "") })),
    s({
        dscr = "#[derive(…)]",
        trig = "derive",
    }, fmt("#[derive({})]", { i(1, "") })),
    s(
        {
            trig = "enum",
            dscr = "enum … { … }",
        },
        fmta(
            [[
            #[derive(Clone, Copy)]
            #[derive(Debug)]
            #[derive(Default)]
            #[derive(PartialEq, Eq, PartialOrd, Ord)]
            enum <> {
                <>,
            }
            ]],
            {
                i(1, "Name"),
                i(2, ""),
            }
        )
    ),
    s(
        {
            trig = "struct",
            dscr = "struct … { … }",
        },
        fmta(
            [[
            #[derive(Clone, Copy)]
            #[derive(Debug)]
            #[derive(Default)]
            #[derive(PartialEq, Eq, PartialOrd, Ord)]
            pub struct <> {
                <>: <>,
            }
            ]],
            {
                i(1, "Name"),
                i(2, "field"),
                i(3, "Type"),
            }
        )
    ),
    s(
        {
            trig = "struct-tuple",
            dscr = "struct …(…);",
        },
        fmt(
            [[
        #[derive(Clone, Copy)]
        #[derive(Debug)]
        #[derive(Default)]
        #[derive(PartialEq, Eq, PartialOrd, Ord)]
        pub struct {}({});
        ]],
            {
                i(1, "Name"),
                i(2, "Type"),
            }
        )
    ),
    s(
        {
            trig = "struct-unit",
            dscr = "struct …;",
        },
        fmt(
            [[
    #[derive(Clone, Copy)]
    #[derive(Debug)]
    #[derive(Default)]
    #[derive(PartialEq, Eq, PartialOrd, Ord)]
    pub struct {};
    ]],
            { i(1, "Name") }
        )
    ),
    s(
        {
            trig = "type",
            dscr = "type … = …;",
        },
        fmt("type {} = {};", {
            i(1, "Alias"),
            i(2, "Type"),
        })
    ),
    s({
        trig = "warn",
        dscr = "#[warn(…)]",
    }, fmt("#[warn({})]", { i(1, "") })),
    s(
        {
            dscr = "impl … { … }",
            trig = "impl",
        },
        fmta(
            [[
            impl <> {
                <>
            }
            ]],
            {
                i(1, "Type"),
                i(2, "// add code here"),
            }
        )
    ),
    s(
        {
            trig = "impl-trait",
            dscr = "impl … for … { … }",
        },
        fmta(
            [[
            impl <> for <> {
                <>
            }
            ]],
            {
                i(1, "Trait"),
                i(2, "Type"),
                i(3, "// add code here"),
            }
        )
    ),
    s({
        trig = "mod",
        dscr = "mod …;",
    }, fmt("mod {};", { i(1, "name") })),
    s(
        {
            trig = "mod-block",
            dscr = "mod … { … }",
        },
        fmta(
            [[
            mod <> {
                    <>,
            }
            ]],
            {
                i(1, "name"),
                i(2, "// add code here"),
            }
        )
    ),
    s({
        trig = "no_core",
        dscr = "#![no_core]",
    }, t("#![no_core]")),
    s({
        trig = "no_std",
        dscr = "#![no_std]",
    }, t("#![no_std]")),
    s(
        {
            trig = "repr",
            dscr = "#[repr(…)]",
        },
        fmta("#[repr(<>)]", {
            i(1, ""),
        })
    ),
    s(
        {
            trig = "macro_use",
            dscr = "#[macro_use(…)]",
        },
        fmta("#[macro_use(<>)]", {
            i(1, ""),
        })
    ),
}
