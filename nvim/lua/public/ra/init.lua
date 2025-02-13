---@diagnostic disable: duplicate-doc-field

---@class RustAnzlyzerConfig
---@field rust-analyzer RustAnzlyzerConfigInner

---@class RustAnzlyzerConfigInner
---@field assist Assist
---@field cachePriming CachePriming
---@field cargo Cargo
---@field checkOnSave boolean
---@field check Check
---@field completion table
---@field diagnostics table
---@field files table
---@field highlightRelated table
---@field hover table
---@field imports table
---@field inlayHints table
---@field interpret table
---@field joinLines  table
---@field lens table
---@field linkedProjects string[]
---@field lru table
---@field notifications table
---@field numThreads integer|nil
---@field procMacro table
---@field references table
---@field rename table
---@field runnables table
---@field rust table
---@field rustc table
---@field rustfmt table|nil
---@field semanticHighlighting table
---@field signatureInfo table
---@field typing table
---@field workspace table

---@class CachePriming
---@field enable boolean
---@field numThreads integer

---@class Assist
---@field emitMustUse boolean
---@field expressionFillDefault string

---@class Cargo
---@field autoreload boolean
---@field buildScripts table
---@field cfgs string[]
---@field extraArgs string[]
---@field extraEnv string[]
---@field features? string[]|string
---@field noDefaultFeatures boolean
---@field sysroot string
---@field sysrootQueryMetadata boolean
---@field sysrootSrc string|nil
---@field target string|nil
---@field unsetTest string[]

---@class Check
---@field allTargets boolean
---@field targets string|string[]|nil
---@field command string
---@field extraArgs string[]

local snippets = require("public.ra.snippets")

local function extra_args_()
    local handle = io.popen("rustup show active-toolchain")
    if not handle then
        return nil
    end
    local res = handle:read("*a")
    if string.find(res, "nightly") then
        return nil
    end
    handle:close()
    return {
        "+nightly",
    }
end
local extra_args = extra_args_()

---@type RustAnzlyzerConfig
return {
    ["rust-analyzer"] = {
        assist = {
            emitMustUse = false, -- Whether to insert #[must_use] when generating as_ methods for enum variants.
            expressionFillDefault = "todo", -- Placeholder expression to use for missing expressions in assists.
        },
        cachePriming = {
            enable = true, -- Warm up caches on project load.
            numThreads = 0, -- How many worker threads to handle priming caches. The default 0 means to pick automatically.
        },
        cargo = {
            autoreload = true,
            targetDir = true,
            buildScripts = {
                enable = true,
                invocationLocation = "workspace", -- 指定运行生成脚本的工作目录。-“workspace”：在工作区的根目录中运行工作区的构建脚本。
                -- 这与设置为 once 的 rust-analyzer.cargo.buildScripts.invocationStrategy 不兼容。
                -- “root”：在项目的根目录中运行构建脚本。此配置仅在设置了 rust-analyzer.cargo.buildScripts.overrideCommand 时有效。
                invocationStrategy = "per_workspace",
                overrideCommand = nil,
                rebuildOnSave = true,
                useRustcWrapper = true,
            },
            cfgs = {}, -- List of cfg options to enable with the given values.
            extraArgs = {
                -- "--offline"
            }, -- 传递给每个 cargo 调用的额外参数。
            extraEnv = {}, -- 在工作区内运行 cargo、rustc 或其他命令时将设置的额外环境变量。用于设置 RUSTFLAGS。
            -- features = "all", -- 要激活的功能列表。将其设置为 "all" 以将 --all-features 传递给cargo。
            noDefaultFeatures = false, -- 是否将 --no-default-features 传递给cargo
            sysroot = "discover", -- sysroot的相对路径，或“discover”以尝试通过“rustc--print sysroot”自动找到它。
            sysrootQueryMetadata = false, -- Whether to run cargo metadata on the sysroot library allowing rust-analyzer to analyze third-party dependencies of the standard libraries.
            sysrootSrc = nil, -- 系统根库源的相对路径。如果未设置，则默认为 {cargo.sysroot}/lib/rustlib/src/rust/library 。
            target = nil, -- 编译目标覆盖(target triple).
            unsetTest = {}, -- 取消设置指定板条箱的隐含 #[cfg(test)] 。
        },
        checkOnSave = false,
        check = {
            allTargets = true,
            command = "clippy", -- 用于 cargo check 的命令。
            extraArgs = { "--no-deps", "--message-format=json-diagnostic-rendered-ansi" }, -- cargo check 的额外参数。
            extraEnv = {}, -- 运行 cargo check 时将设置的额外环境变量。扩展 rust-analyzer.cargo.extraEnv 。
            -- 要激活的功能列表。默认为 rust-analyzer.cargo.features 。设置为 "all" ，将 --all-features 传递给Cargo。
            -- features = "all",
            invocationLocation = "workspace", -- 指定运行检查的工作目录。-“workspace”：对相应工作区的根目录中的工作区进行检查。
            -- 如果 rust-analyzer.cargo.checkOnSave.invocationStrategy 设置为 once ，则返回到“root”。-“root”：在项目的根目录中运行检查。
            -- 此配置仅在设置了 rust-analyzer.cargo.buildScripts.overrideCommand 时有效。
            invocationStrategy = "per_workspace", -- 指定运行checkOnSave命令时要使用的调用策略。
            -- 如果设置了 per_workspace ，则将对每个工作区执行该命令。如果设置了 once ，则该命令将执行一次。
            -- 此配置仅在设置了 rust-analyzer.cargo.buildScripts.overrideCommand 时有效。
            noDefaultFeatures = nil, -- 是否将 --no-default-features 传递给Cargo。
            -- overrideCommand = { "cargo", "clippy", "--tests", "--message-format=json-diagnostic-rendered-ansi" },

            -- 检查特定目标。如果为空，则默认为 rust-analyzer.cargo.target 。
            -- 可以是单个目标，例如 "x86_64-unknown-linux-gnu" 或目标列表，例如 ["aarch64-apple-darwin", "x86_64-apple-darwin"] 。
            targets = nil,

            workspace = true,
        },
        completion = {
            autoimport = { enable = true },
            termSearch = { enable = true },
            autoself = { enable = true },
            callable = { snippets = "fill_arguments" }, -- completion 函数时是否添加括号和参数片段。
            limit = nil, -- 要返回的最大 completion 次数。如果 None ，则极限为无穷大。
            postfix = { enable = true }, -- Whether to show postfix snippets like dbg, if, not, etc.
            privateEditable = { enable = true },
            snippets = { custom = snippets },
        },
        diagnostics = {
            enable = true,
            disabled = {
                "proc-macro-disabled",
                "unfulfilled_lint_expectations",
                -- rustc 的 lint 已经有这些了
                "unused_variables",
                "unused_mut", -- rustc 更准确

                -- clippy 的 lint 已经有这些了
                "needless_return",
            }, -- 要禁用的rust-analyzer诊断列表。
            experimental = { enable = false }, -- 是否显示可能比平时有更多假阳性的实验性rust-analyzer仪诊断。
            remapprefix = {}, -- 解析诊断文件路径时要替换的前缀的映射。这应该是传递给 rustc 的内容作为 --remap-path-prefix 的反向映射。
            warningsAsHint = {}, -- 应以提示严重性显示的警告列表。
            warningsAsInfo = {
                "unused_variables",
            },
            styleLints = { enable = true },
        },
        files = {
            excludeDirs = {}, -- rust-analyzer 将忽略这些目录。它们是相对于工作区根目录的，不支持glob。您可能还需要将文件夹添加到Code的 files.watcherExclude 中。
            watcher = "client", -- 控制文件监视实现。
        },
        highlightRelated = {
            breakPoints = { enable = true }, -- 当光标位于 break 、 loop 、 while 或 for 关键字上时，启用相关引用的高亮显示。
            closureCaptures = { enable = true }, -- 当光标位于闭包的 | 或move关键字上时，启用对闭包的所有捕获的高亮显示。
            exitPoints = { enable = true }, -- 当光标位于 return 、 ? 、 fn 或返回类型箭头（ → ）上时，启用所有退出点的高亮显示。
            references = { enable = true }, -- 当光标位于任何标识符上时，启用相关引用的高亮显示。
            yieldPoints = { enable = true }, -- 当光标位于任何 async 或 await 关键字上时，启用高亮显示循环或块上下文的所有断点。
        },
        hover = {
            actions = {
                enable = true, -- 是否在Rust文件中显示悬停操作。
                run = { enable = true },
                debug = { enable = true },
                gotoTypeDef = { enable = true }, -- Whether to show Go to Type Definition action. Only applies when rust-analyzer.hover.actions.enable is set.
                implementations = { enable = false }, -- Whether to show Implementations action. Only applies when rust-analyzer.hover.actions.enable is set.
                references = { enable = false }, -- Whether to show References action. Only applies when rust-analyzer.hover.actions.enable is set.
            },
            documentation = {
                enable = true, -- Whether to show documentation on hover.
                keywords = { enable = false }, -- Whether to show keyword hover popups.
            },
            links = { enable = true }, -- Use markdown syntax for links on hover.
            memoryLayout = {
                enable = true,
                alignment = "hexadecimal",
                niches = false,
                offset = "hexadecimal",
            },
        },
        imports = {
            granularity = {
                enforce = false,
                group = "module", --[[ crate ]]
                enable = true,
            },
            group = { enable = true },
            merge = { glob = true },
            preferNoStd = false,
            preferPrelude = true,
            prefix = "self", -- crate, self, plain
        },
        inlayHints = {
            bindingModeHints = { enable = true },
            chainingHints = { enable = true },
            closingBraceHints = { enable = true, minLines = 40 },
            closureCaptureHints = { enable = false },
            closureReturnTypeHints = { enable = "always" }, -- never
            closureStyle = "impl_fn",
            discriminantHints = { enable = "always" },
            expressionAdjustmentHints = { -- reborrow, loop的返回值
                enable = "always",
                hideOutsideUnsafe = true,
                mode = "prefix",
                -- mode = "postfix ",
            },
            lifetimeElisionHints = { enable = "always", useParameterNames = true },
            maxLength = 20,
            parameterHints = { enable = true },
            renderColons = true,
            typeHints = { enable = true, hideClosureInitialization = false, hideNamedConstructor = false },
        },
        interpret = { tests = false },
        joinLines = {
            joinAssignments = true, -- Join lines merges consecutive declaration and initialization of an assignment.
            joinElseIf = true, -- Join lines inserts else between consecutive ifs.
            removeTrailingComma = true, -- Join lines removes trailing commas.
            unwrapTrivialBlock = true, -- Join lines unwraps trivial blocks.
        },
        lens = {
            enable = true,
            debug = { enable = true },
            forceCustomCommands = true,
            implementations = { enable = true },
            location = "end_of_line", -- "above_name",
            references = {
                adt = { enable = true },
                enumVariant = { enable = true },
                method = { enable = true },
                trait = { enable = true },
            },
        },
        linkedProjects = {}, -- 禁用项目自动发现以支持显式指定的项目集。
        -- 元素必须是指向 Cargo.toml 、 rust-project.json 或rust-project.json格式的JSON对象的路径。
        lru = {
            capacity = 512, -- rust-analyzer 保存在内存中的语法树数。默认值为 128。
            query = { capacities = {} }, -- 设置指定查询的 lru 容量。
        },
        notifications = {
            cargoTomlNotFound = true, -- 是否显示 can’t find Cargo.toml 错误消息。
            unindexedProject = true,
        },
        numThreads = nil, -- 主循环中有多少工作线程。默认的 null 表示自动拾取。
        procMacro = {
            enable = true,
            attributes = { enable = true },
            ignored = {
                ["async-trait"] = { "async_trait" },
                ["tonic"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
            },
            server = nil,
        },
        references = {
            excludeImports = true, -- Exclude imports from find-all-references.
            excludeTests = false, -- Exclude tests from find-all-references.
        },
        rename = { allowExternalItems = false }, -- Allow renaming of items not belonging to the loaded workspaces.
        runnables = {
            command = nil,
            extraArgs = {}, -- 要传递给cargo的可运行程序（如测试或二进制文件）的其他参数。例如，它可能是 --release 。
        },
        rust = { analyzerTargetDir = nil }, -- Optional path to a rust-analyzer specific target directory. This prevents rust-analyzer’s cargo check from locking the Cargo.lock at the expense of duplicating build artifacts.
        rustc = { source = nil }, -- Path to the Cargo.toml of the rust compiler workspace, for usage in rustc_private projects, or "discover" to try to automatically find it if the rustc-dev component is installed.
        rustfmt = {
            extraArgs = extra_args,
            -- overrideCommand = fmt,
            rangeFormatting = { enable = true },
        },
        semanticHighlighting = {
            doc = { comment = { inject = { enable = true } } },
            nonStandardTokens = true,
            operator = {
                enable = true,
                specialization = { enable = true }, -- 为运算符使用专门的语义标记。
            },
            punctation = {
                enable = true, -- 使用语义标记作为标点符号。
                specialization = { enable = true }, -- 对标点符号使用专门的语义标记。
                separate = {
                    macro = { bang = true }, -- 启用后，rust-analyzer将为宏调用的 ! 发出一个标点符号语义标记。
                },
            },
            strings = { enable = true },
        },
        signatureInfo = {
            detail = "full", -- Show full signature of the callable. Only shows parameters if disabled.
            documentation = { enable = false },
        },
        typing = {
            autoClosingAngleBrackets = { enable = true }, -- 键入泛型参数列表的左尖括号时是否插入右尖括号。
        },
        workspace = {
            symbol = {
                search = {
                    kind = "only_types", -- Workspace symbol search kind.
                    limit = 128, -- 限制从工作空间符号搜索返回的项目数（默认为128）。
                    -- 一些客户端，如vs code，在结果筛选时发布新的搜索，
                    -- 并且不要求在初始搜索中返回所有结果。其他客户要求提前获得所有结果，可能需要更高的限额。
                    scope = "workspace",
                },
            },
        },
    },
}
