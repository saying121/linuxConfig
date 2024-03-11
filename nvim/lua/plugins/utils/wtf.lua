---@type LazySpec
return {
    "piersolenski/wtf.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
        -- Default AI popup type
        popup_type = "popup", -- | "horizontal" | "vertical",
        -- An alternative way to set your API key
        openai_api_key = "sk-xxxxxxxxxxxxxx",
        -- ChatGPT Model
        openai_model_id = "gpt-3.5-turbo",
        -- Send code as well as diagnostics
        context = true,
        -- Set your preferred language for the response
        language = "english",
        -- Any additional instructions
        additional_instructions = "Start the reply with 'OH HAI THERE'",
        -- Default search engine, can be overridden by passing an option to WtfSeatch
        search_engine = "google", -- | "duck_duck_go" | "stack_overflow" | "github",
        -- Callbacks
        hooks = {
            request_started = nil,
            request_finished = nil,
        },
        -- Add custom colours
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
    cmd = {
        "WtfSeatch",
        "Wtf",
    },
}
