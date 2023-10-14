return {
    "segeljakt/vim-silicon",
    build = "cargo install silicon",
    cmd = "Silicon",
    config = function()
        vim.g.silicon = {
            ["theme"] = "Dracula",
            ["font"] = "Hack",
            ["background"] = "#AAAAFF",
            ["shadow-color"] = "#555555",
            ["line-pad"] = 2,
            ["pad-horiz"] = 10,
            ["pad-vert"] = 10,
            ["shadow-blur-radius"] = 0,
            ["shadow-offset-x"] = 0,
            ["shadow-offset-y"] = 0,
            ["line-number"] = true,
            ["round-corner"] = true,
            ["window-controls"] = true,
        }
        local dir = "~/Pictures/code_snap/"
        local exists = vim.fn.isdirectory(dir) == 1
        if not exists then
            os.execute("mkdir -p " .. dir)
        end
        vim.cmd([[
            " let g:silicon['output'] = '~/Pictures/code_snap/silicon-{time:%Y-%m-%d-%H%M%S}.png'
            let g:silicon['output'] = 'silicon-{time:%Y-%m-%d-%H%M%S}.png'
        ]])
        -- local path = vim.api.nvim_eval("g:silicon['output']")

        -- vim.api.nvim_create_user_command("SiliconC", function()
        --     vim.cmd("Silicon")
        --     os.execute("wl-copy < " .. path)
        -- end, { nargs = 0 })
    end,
}
