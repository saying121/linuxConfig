local my_ft = require("public.ft")

local M = {
    filetypes = { "toml" },
    settings = {},
}

local ft = my_ft.filename["Cargo.toml"]
if type(ft) == "string" then
    table.insert(M.filetypes, ft)
end

return M
