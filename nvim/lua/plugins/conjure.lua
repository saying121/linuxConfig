local ft = {
    lua = "lua",
    rust = "rs",
    python = "py",
    fennel = "fnl",
    clojure = "clj",
    janet = "jnt",
    racket = "rkt",
    scheme = "scm",
    clisp = "lisp",
    julia = "jl",
}

local events = {}

for _, value in pairs(ft) do
    table.insert(events, "UIEnter *." .. value)
    table.insert(events, "BufNew *." .. value)
end
return {
    "Olical/conjure",
    build = "cargo install evcxr_repl",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "PaterJason/cmp-conjure",
    },
    cond = true,
    event = events,
    -- keys = {
    --     { ",E", mode = "v" },
    -- },
    cmd = {
        "ConjureEval",
        "ConjureEvalVisual",
        "ConjureConnect",
    },
    config = function()
        vim.g["conjure#mapping#doc_word"] = false

        local keymap = vim.keymap.set
        local opts = { noremap = true, silent = true }
        keymap("x", ",E", ":ConjureEvalVisual<CR>", opts)
    end,
}
