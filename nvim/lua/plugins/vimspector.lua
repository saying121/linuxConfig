return {
    "puremourning/vimspector",
    build = "python3 install_gadget.py --all",
    cond = false,
    keys = {
        { "<space>b", mode = "n" },
        { "<space>B", mode = "n" },
        -- { "<leader>tb", mode = "n" },
        -- { "<leader>sc", mode = "n" },
        -- { "<leader>cl", mode = "n" },
    },
    config = function()
        local kemap, opts = vim.keymap.set, { silent = true, noremap = true }
        kemap({ "n", "x" }, "<leader>di", ":VimspectorBalloonEval", opts)

        kemap("n", "<space>b", "<Plug>VimspectorToggleBreakpoint<cr>", opts)
        kemap("n", "<space>B", "<Plug>VimspectorAddFunctionBreakpoint<cr>", opts)

        kemap("n", "<F5>", "<Plug>VimspectorContinue<cr>", opts)
        kemap("n", "<F6>", "<Plug>VimspectorStepInto<cr>", opts)
        kemap("n", "<F7>", "<Plug>VimspectorStepOver<cr>", opts)
        kemap("n", "<F8>", "<Plug>VimspectorStepOut<cr>", opts)

        kemap("n", "<F11>", "<Plug>VimspectorStop<cr>", opts)

        local conf = {}
        local cf_dir = os.getenv("HOME") .. "/.config/nvim/lua/vimspector-config/"
        for _, val in ipairs(vim.fn.readdir(cf_dir)) do
            local a = vim.fn.join(vim.fn.readfile(cf_dir .. val))
            local tb = vim.json.decode(a)
            table.insert(conf, tb)
        end
        vim.g.vimspector_configurations = conf

        -- vim.g.vimspector_enable_mappings = "HUMAN"
        -- vim.g.vimspector_install_gadgets = { "debugpy", "vscode-cpptools", "CodeLLDB" }
        -- vim.g.vimspector_base_dir = vim.fn.stdpath("config") .. "/lua/vimspector-config"
    end,
}
