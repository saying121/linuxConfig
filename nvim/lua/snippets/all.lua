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

local ext_opts = {
    -- these ext_opts are applied when the node is active (e.g. it has been
    -- jumped into, and not out yet).
    active =     -- this is the table actually passed to `nvim_buf_set_extmark`.
{
        -- highlight the text inside the node red.
        hl_group = "Error",
    },
    -- these ext_opts are applied when the node is not active, but
    -- the snippet still is.
    passive = {
        -- add virtual text on the line of the node, behind all text.
        virt_text = { { "virtual text!!", "WarningMsg" } },
    },
    -- and these are applied when both the node and the snippet are inactive.
    snippet_passive = {},
}

return {
    s("ext_opt", {
        i(1, "text1", {
            node_ext_opts = ext_opts,
        }),
        t({ "", "" }),
        i(2, "text2", {
            node_ext_opts = ext_opts,
        }),
    }),
    -- s("trigger1", {
    --     i(1, "First"),
    --     t("::"),
    --     sn(2, {
    --         i(1, "second"),
    --         t(":"),
    --         i(2, "third"),
    --     }),
    -- }),
    -- s("func", {
    --     i(1, "first1 "),
    --     f(function(args, snip)
    --         return args[1][1] .. "" .. args[1][2] .. args[2][1] .. " end"
    --     end, { ai[2], ai[1] }),
    --     i(2, { "second2 ", "return3 ", " 1 " }),
    -- }),
    -- s("abs", {
    --     i(1, "text_of_first "),
    --     i(2, { "first_line_of_second", "second_line_of_second" }),
    --     f(function(args, snip)
    --         return args[1][1] .. args[2][1]
    --     end, { 2, 1 }),
    -- }),
    -- postfix(".br", {
    --     f(function(_, parent)
    --         return "[" .. parent.snippet.env.POSTFIX_MATCH .. "]"
    --     end, {}),
    -- }),
    -- postfix(".brl", {
    --     l("[" .. l.POSTFIX_MATCH .. "]"),
    -- }),
    -- postfix({ trig = ".brd" }, {
    --     d(1, function(_, parent)
    --         return sn(nil, { t("[" .. parent.env.POSTFIX_MATCH .. "]") })
    --     end),
    -- }),
    -- s(
    --     "trig6",
    --     c(1, {
    --         t("ugh boring ,a node"),
    --         i(nil, "edit something..."),
    --         f(function(args)
    --             return "stell text"
    --         end, {}),
    --     })
    -- ),
    -- s(
    --     "trig7",
    --     sn(1, {
    --         t("basicall"),
    --         i(1, "and"),
    --     })
    -- ),
    -- s("isn", {
    --     isn(1, {
    --         t({ "indented as deep trigger", "and next line" }),
    --     }, ""),
    -- }),
    -- s("isn2", {
    --     isn(1, t({ "//This is", "A multiline", "comment" }), "$PARENT_INDENT//"),
    -- }),
    -- s("trig8", {
    --     t("text: "),
    --     i(1),
    --     t({ "", "copy: " }),
    --     d(2, function(args)
    --         -- the returned snippetNode doesn't need a position; it's inserted
    --         -- "inside" the dynamicNode.
    --         return sn(nil, {
    --             -- jump-indices are local to each snippetNode, so restart at 1.
    --             i(1, args[1]),
    --         })
    --     end, { 1 }),
    -- }),
}
