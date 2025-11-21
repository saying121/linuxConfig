vim.opt.listchars = {
    tab = "> ",
    leadmultispace = "│   ",
    nbsp = "+",
    trail = "·",
    extends = "⇒", -- →
    precedes = "⇐", -- ←
}

vim.g.vimsyn_embed = "lPr"
vim.g.maplocalleader = ","

vim.opt.spell = true
vim.opt.spelllang = { "en_us" }

if vim.fn.has("nvim-0.10.0") == 1 then
    vim.opt.smoothscroll = true
end

local buf_height = math.floor(vim.fn.winheight(0) / 2)
vim.o.scrolloff = math.max(0, buf_height - 20)

vim.keymap.set("n", "gp", "<cmd>pu 0<cr>", { desc = "Paste below" })
vim.keymap.set("n", "gP", "<cmd>-1pu 0<cr>", { desc = "Paste above" })
