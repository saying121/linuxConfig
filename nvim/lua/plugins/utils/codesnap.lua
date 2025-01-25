---@alias theme 'bamboo'|'sea'|'peach'|'grape'|'dusk'|'summer'

---@type LazySpec
return {
    "mistricky/codesnap.nvim",
    build = "make",
    cmd = {
        "CodeSnap",
        "CodeSnapSave",
        "CodeSnapASCII",
        "CodeSnapHighlight",
        "CodeSnapSaveHighlight",
    },
    opts = {
        save_path = "~/Pictures/codesnap",
        has_breadcrumbs = false,
        show_workspace = false,
        has_line_number = true,
        ---@type theme
        bg_theme = "sea",
        bg_x_padding = 20,
        bg_y_padding = 82,
        -- bg_padding = 20,
        watermark = "saying121",
    },
}
