local vfn = vim.fn
local ft = {
    tex = "tex",
    bib = "bib",
    plaintex = "plaintex",
}

---@type LazySpec
return {
    "lervag/vimtex",
    ft = {
        "tex",
        "bib",
        "plaintex",
    },
    event = require("public.utils").boot_event(ft),
    config = function()
        local opts, keymap = { silent = true, noremap = true }, vim.keymap.set
        keymap("n", "<C-p>", "<cmd>VimtexView<CR>", opts)
        -- Viewer options: One may configure the viewer either by specifying a built-in
        -- viewer method:
        vim.g.vimtex_view_method = "zathura"

        -- Or with a generic interface:
        -- vim.g.vimtex_view_general_viewer = "okular"
        -- vim.g.vimtex_view_general_options = "--unique file:@pdf#src:@line@tex"

        -- VimTeX uses latexmk as the default compiler backend. If you use it, which is
        -- strongly recommended, you probably don't need to configure anything. If you
        -- want another compiler backend, you can change it as follows. The list of
        -- supported backends and further explanation is provided in the documentation,
        -- see ":help vimtex-compiler".
        vim.g.vimtex_compiler_method = "latexmk"
        vim.g.vimtex_compiler_latexmk = {
            -- 编译目标目录
            build_dir = vfn.getcwd() .. "/build_tex/" .. vfn.expand("%:t:r"),
        }

        -- Most VimTeX mappings rely on localleader and this can be changed with the
        -- following line. The default is usually fine and is the symbol "\".
        vim.g.maplocalleader = ","
    end,
}
