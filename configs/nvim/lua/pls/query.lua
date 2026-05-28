local api = vim.api
local ts = vim.treesitter

-- Get a compatible vim range (1 index based) from a TS node range.
--
-- TS nodes start with 0 and the end col is ending exclusive.
-- They also treat a EOF/EOL char as a char ending in the first
-- col of the next row.
---comment
---@param range integer[]
---@param buf integer|nil
---@return integer, integer, integer, integer
local function get_vim_range(range, buf)
    ---@type integer, integer, integer, integer
    local srow, scol, erow, ecol = unpack(range)
    srow = srow + 1
    scol = scol + 1
    erow = erow + 1

    if ecol == 0 then
        -- Use the value of the last col of the previous row instead.
        erow = erow - 1
        if not buf or buf == 0 then
            ecol = vim.fn.col({ erow, "$" }) - 1
        else
            ecol = #vim.api.nvim_buf_get_lines(buf, erow - 1, erow, false)[1]
        end
        ecol = math.max(ecol, 1)
    end

    return srow, scol, erow, ecol
end

---@param node TSNode
local function get_rows(node)
    local start_row, _, end_row, _ = get_vim_range({ ts.get_node_range(node) }, 0)
    return vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, true)
end

vim.keymap.set("n", "ttt", function()
    local cursor = api.nvim_win_get_cursor(0)
    local pos = { cursor[1] - 1, cursor[2] }

    local cline = api.nvim_get_current_line()
    if not string.find(cline, "fn ") then
        local temp = vim.fn.searchpos("fn ", "bcn", vim.fn.line("w0"))
        pos = { temp[1] - 1, temp[2] }
    end

    local node = ts.get_node({ pos = pos })

    if node == nil or node:type() ~= "function_item" then
        vim.notify("not found function item, please use inside function", vim.log.levels.ERROR)
        return
    end

    local b = get_rows(node)
    if b == nil then
        return
    end
    local rust_code = table.concat(b, "\n")
    print(rust_code)
end)

vim.keymap.set("n", "<leader>ht", function()
    local lnum = vim.fn.line(".")
    vim.print(lnum)
    local temp = vim.lsp.inlay_hint.get({
        bufnr = 0,
        range = {
            start = { line = lnum - 1, character = 0 },
            ["end"] = { line = lnum, character = 0 },
        },
    })
    vim.print(temp)
end)

return { a = 1 }
