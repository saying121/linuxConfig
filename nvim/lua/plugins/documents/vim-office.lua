return {
    "konfekt/vim-office",
    -- cond = function()
    --     if string.find(vim.fn.expand("%:e"), value) then
    --         return true
    --     end
    --     return false
    -- end,
    config = function()
        vim.g.office_tesseract = "-l eng+ita"
    end,
}
