local api = vim.api
local lsp = vim.lsp

local M = {}

M.current_win = nil
local current_nsid = api.nvim_create_namespace("LuaSnipChoiceListSelections")

local function window_for_choiceNode(choiceNode)
    local buf = api.nvim_create_buf(false, true)
    local buf_text = {}
    local row_selection = 0
    local row_offset = 0
    local text
    for _, node in ipairs(choiceNode.choices) do
        text = node:get_docstring()
        -- find one that is currently showing
        if node == choiceNode.active_choice then
            -- current line is starter from buffer list which is length usually
            row_selection = #buf_text
            -- finding how many lines total within a choice selection
            row_offset = #text
        end
        vim.list_extend(buf_text, text)
    end

    api.nvim_buf_set_text(buf, 0, 0, 0, 0, buf_text)
    local w, h = lsp.util._make_floating_popup_size(buf_text, {})

    -- adding highlight so we can see which one is been selected.
    local extmark = api.nvim_buf_set_extmark(
        buf,
        current_nsid,
        row_selection,
        0,
        { hl_group = "AerialLine", end_line = row_selection + row_offset }
    )

    -- shows window at a beginning of choiceNode.
    local win = api.nvim_open_win(buf, false, {
        relative = "win",
        width = w,
        height = h,
        bufpos = choiceNode.mark:pos_begin_end(),
        style = "minimal",
        border = "rounded",
    })

    -- return with 3 main important so we can use them again
    return { win_id = win, extmark = extmark, buf = buf }
end

function M.choice_popup(choiceNode)
    -- build stack for nested choiceNodes.
    if M.current_win then
        api.nvim_win_close(M.current_win.win_id, true)
        api.nvim_buf_del_extmark(M.current_win.buf, current_nsid, M.current_win.extmark)
    end
    local create_win = window_for_choiceNode(choiceNode)
    M.current_win = {
        win_id = create_win.win_id,
        prev = M.current_win,
        node = choiceNode,
        extmark = create_win.extmark,
        buf = create_win.buf,
    }
end

function M.update_choice_popup(choiceNode)
    -- if M.current_win == nil then
    --     return
    -- end
    api.nvim_win_close(M.current_win.win_id, true)
    api.nvim_buf_del_extmark(M.current_win.buf, current_nsid, M.current_win.extmark)
    local create_win = window_for_choiceNode(choiceNode)
    M.current_win.win_id = create_win.win_id
    M.current_win.extmark = create_win.extmark
    M.current_win.buf = create_win.buf
end

function M.choice_popup_close()
    -- if M.current_win == nil then
    --     return
    -- end
    api.nvim_win_close(M.current_win.win_id, true)
    api.nvim_buf_del_extmark(M.current_win.buf, current_nsid, M.current_win.extmark)
    -- now we are checking if we still have previous choice we were in after exit nested choice
    M.current_win = M.current_win.prev
    if M.current_win then
        -- reopen window further down in the stack.
        local create_win = window_for_choiceNode(M.current_win.node)
        M.current_win.win_id = create_win.win_id
        M.current_win.extmark = create_win.extmark
        M.current_win.buf = create_win.buf
    end
    -- M.current_win = nil
end

return M
