-- clangd 的inlay hints 默认开启 https://clangd.llvm.org/config#inlayhints
return {
    settings = {},
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    cmd = {
        -- see clangd --help-hidden
        "clangd",
        "--background-index",
        -- by default, clang-tidy use -checks=clang-diagnostic-*,clang-analyzer-*
        -- to add more checks, create .clang-tidy file in the root directory
        -- and add Checks key, see https://clang.llvm.org/extra/clang-tidy/
        "--clang-tidy",
        -- "--clang-tidy-checks=-*,llvm-*,clang-analyzer-*,modernize-*,-modernize-use-trailing-return-type",
        "--completion-style=bundled",
        -- "--completion-style=detailed",
        "--cross-file-rename",
        "--header-insertion=iwyu",
        "--offset-encoding=utf-16",

        "--fallback-style=Google",
        "--all-scopes-completion",
        "--log=error",
        "--suggest-missing-includes",
        "--cross-file-rename",
        "--pch-storage=memory", -- could also be disk
        "--folding-ranges",
        "--enable-config", -- clangd 11+ supports reading from .clangd configuration file
        -- "--limit-references=1000",
        -- "--limit-resutls=1000",
        -- "--malloc-trim",
        -- "--header-insertion=never",
        -- "--query-driver=<list-of-white-listed-complers>"
    },
}
