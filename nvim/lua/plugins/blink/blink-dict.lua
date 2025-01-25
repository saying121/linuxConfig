-- local prefix = "~/.local/share/nvim/Trans/"

---@type LazySpec
return {
    "Kaiser-Yang/blink-cmp-dictionary",
    dependencies = "nvim-lua/plenary.nvim",
    -- build = "sqlite3 "
    --     .. vim.fn.expand(prefix .. "ultimate.db")
    --     .. ' "select word from stardict"'
    --     .. " >"
    --     .. vim.fn.expand(prefix .. "neovim.dict"),
    lazy = true,
}
