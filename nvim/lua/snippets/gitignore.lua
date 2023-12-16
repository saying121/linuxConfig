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

local mis = [[
# Miscellaneous
*.log
logs/*
nohup.out
.vale.ini
styles/
/.vscode
.idea
node_modules/
silicon-*
build_rust/
build_c_cpp/
build_go/
flamegraph/
flamegraph.svg
perf.data*
]]

return {
    s(
        {
            trig = "rust",
            priority = 30000,
            dscr = describe,
        },
        fmta([[
# Generated by Cargo
# will have compiled files and executables
debug/
/target

# About test file
*.profraw

# These are backup files generated by rustfmt
**/*.rs.bk

<>

]] .. mis, { i(1, [[Cargo.lock]]) }, {})
    ),
    s(
        {
            trig = "mis",
            priority = 30000,
            dscr = describe,
        },
        fmta( mis, {}, {})
    ),
}
