local api = vim.api
local keymap_buf = api.nvim_buf_set_keymap
local buf_del_keymap = api.nvim_buf_del_keymap

return {
    "jbyuki/venn.nvim",
    cmd = "VennT",
    config = function()
        -- venn.nvim: enable or disable keymappings
        function _G.Toggle_venn()
            local venn_enabled = vim.inspect(vim.b.venn_enabled)
            if venn_enabled == "nil" then
                vim.b.venn_enabled = true
                vim.cmd([[setlocal ve=all]])
                vim.cmd.setlocal([[ve=all]])

                -- draw a line on HJKL keystokes
                keymap_buf(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
                keymap_buf(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
                keymap_buf(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
                keymap_buf(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })

                keymap_buf(0, "v", "<CR>", ":VBox<CR>", { noremap = true })
                keymap_buf(0, "v", "<A-CR>", ":VFill<CR>", { noremap = true })
                keymap_buf(0, "v", "o", ":VBoxO<CR>", { noremap = true })

                keymap_buf(0, "v", "d", ":VBoxD<CR>", { noremap = true })
                keymap_buf(0, "v", "D", ":VBoxDO<CR>", { noremap = true })

                keymap_buf(0, "v", "f", ":VBoxH<CR>", { noremap = true })
                keymap_buf(0, "v", "F", ":VBoxHO<CR>", { noremap = true })

            else
                vim.cmd.setlocal("ve=")
                -- vim.cmd([[setlocal ve=]])

                buf_del_keymap(0, "n", "J")
                buf_del_keymap(0, "n", "K")
                buf_del_keymap(0, "n", "L")
                buf_del_keymap(0, "n", "H")
                buf_del_keymap(0, "v", "f")
                vim.b.venn_enabled = nil
            end
        end

        -- toggle keymappings
        api.nvim_create_user_command("VennT", Toggle_venn, {})
    end,
}
