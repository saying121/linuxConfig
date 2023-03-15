return {
    "edluffy/hologram.nvim",
    lazy = true,
    config = function()
        require("hologram").setup({
            auto_display = false, -- WIP automatic markdown image display, may be prone to breaking
        })

        -- local function image()
        --     require('test_image')
        -- end
        -- vim.keymap.set('n', '<leader>p', image(), { noremap = true, silent = true })
    end,
}
