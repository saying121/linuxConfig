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

return {
    "Olical/conjure",
    build = "cargo install evcxr_repl",
    cond = false,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    event = require("public.utils").boot_event(ft),
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
