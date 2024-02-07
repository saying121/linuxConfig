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

if vim.fn.has("nvim-0.10.0") == 1 then
    vim.opt.smoothscroll = true
end
