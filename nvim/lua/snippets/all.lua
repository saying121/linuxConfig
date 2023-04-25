return {
    s("trigger", {
        t({ "wow text, line1." }),
        i(1),
        t({ "", "wow text, line2." }),
        i(2),
        t({ "", "wow text, line3." }),
        i(0),
    }),
    s("trigger1", {
        i(1, "First"),
        t("::"),
        sn(2, {
            i(1, "second"),
            t(":"),
            i(2, "third"),
        }),
    }),
    s("func", {
        i(1, "first1 "),
        f(function(args, snip)
            return args[1][1] .. "" .. args[1][2] .. args[2][1] .. " end"
        end, { ai[2], ai[1] }),
        i(2, { "second2 ", "return3 ", " 1 " }),
    }),
    s("abs", {
        i(1, "text_of_first "),
        i(2, { "first_line_of_second", "second_line_of_second" }),
        f(function(args, snip)
            return args[1][1] .. args[2][1]
        end, { 2, 1 }),
    }),
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
    s(
        "trig6",
        c(1, {
            t("ugh boring ,a node"),
            i(nil, "edit something..."),
            f(function(args)
                return "stell text"
            end, {}),
        })
    ),
    s(
        "trig7",
        sn(1, {
            t("basicall"),
            i(1, "and"),
        })
    ),
    s("isn", {
        isn(1, {
            t({ "indented as deep trigger", "and next line" }),
        }, ""),
    }),
    s("isn2", {
        isn(1, t({ "//This is", "A multiline", "comment" }), "$PARENT_INDENT//"),
    }),
    s("trig8", {
        t("text: "),
        i(1),
        t({ "", "copy: " }),
        d(2, function(args)
            -- the returned snippetNode doesn't need a position; it's inserted
            -- "inside" the dynamicNode.
            return sn(nil, {
                -- jump-indices are local to each snippetNode, so restart at 1.
                i(1, args[1]),
            })
        end, { 1 }),
    }),
}
