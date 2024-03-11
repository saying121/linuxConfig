---@type LazySpec
return {
    "SeniorMars/typst.nvim",
    -- ft = "typst",
    event = {
        "BufNew *.typ",
        "UIEnter *.typ",
    },
    config = function() end,
}
