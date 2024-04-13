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
vim.o.scrolloff = buf_height - 10
