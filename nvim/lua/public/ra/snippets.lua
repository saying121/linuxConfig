local styles = {
    mis = { "", "#?,?,2e,2E,p" },
    accuracy = { "accuracy", ".accuracy,+.accuracy,.1$" },
    base = { "base", "#b,#o,#x,#X,x" },
    align = { "align", "5,05,<5,>5,^5" },
}
local postfix_prln = {}
local prln = {}

local k
for _, value in pairs(styles) do
    k = "prln!" .. value[1]
    prln[k] = {
        prefix = k,
        body = 'println!("{:${1|' .. value[2] .. '|}}", $2);$0',
        description = "Insert an `println!`",
        scope = "expr",
    }
end

for _, value in pairs(styles) do
    k = "prvar_" .. value[1]
    postfix_prln[k] = {
        postfix = k,
        body = 'println!(r##"(| ${receiver} |) ${2:->} {:${1|' .. value[2] .. '|}}"##, ${receiver});$0',
        description = "Wrap the expression in a `println!`",
        scope = "expr",
    }
end

local e_key, body
for _, value in pairs(styles) do
    k = "prln_" .. value[1]
    body = 'println!("{:${1|' .. value[2] .. '|}}", ${receiver});$0'
    postfix_prln[k] = {
        postfix = k,
        body = body,
        description = "Wrap the expression in a `println!`",
        scope = "expr",
    }
    e_key = "e" .. k
    postfix_prln[e_key] = {
        postfix = e_key,
        body = "e" .. body,
        description = "Wrap the expression in a `eprintln!`",
        scope = "expr",
    }
end

local postfix = {
    ["Mutex::new"] = {
        postfix = "Mutex",
        body = "Mutex::new(${receiver})",
        description = "Put the expression into a `Mutex`",
        requires = "std::sync::Mutex",
        scope = "expr",
    },
    ["RefCell::new"] = {
        postfix = "RefCell",
        body = "RefCell::new(${receiver})",
        description = "Put the expression into a `RefCell`",
        requires = "std::cell::RefCell",
        scope = "expr",
    },
    ["Cell::new"] = {
        postfix = "Cell",
        body = "Cell::new(${receiver})",
        description = "Put the expression into a `Cell`",
        requires = "std::cell::Cell",
        scope = "expr",
    },
    ["Arc::new"] = {
        postfix = "Arc",
        body = "Arc::new(${receiver})",
        description = "Put the expression into an `Arc`",
        requires = "std::sync::Arc",
        scope = "expr",
    },
    ["Arc::clone"] = {
        postfix = "Arc_clone",
        body = "Arc::clone(&${receiver})",
        description = "Put the expression into an `Arc::clone`",
        requires = "std::sync::Arc",
        scope = "expr",
    },
    ["Arc::downgrade"] = {
        postfix = "downgrade",
        body = "Arc::downgrade(&${receiver})",
        description = "Put the expression into a `Arc::downgrade`",
        requires = "std::sync::Arc",
        scope = "expr",
    },
    ["Rc::new"] = {
        postfix = "Rc",
        body = "Rc::new(${receiver})",
        description = "Put the expression into a `Rc`",
        requires = "std::rc::Rc",
        scope = "expr",
    },
    ["Rc::clone"] = {
        postfix = "Rc_clone",
        body = "Rc::clone(&${receiver})",
        description = "Put the expression into a `Rc::clone`",
        requires = "std::rc::Rc",
        scope = "expr",
    },
    ["Weak::clone"] = {
        postfix = "Weak_clone",
        body = "Weak::clone(&${receiver})",
        description = "Put the expression into a `Weak::clone`",
        requires = "std::rc::Weak",
        scope = "expr",
    },
    ["Box::pin"] = {
        postfix = "pinbox",
        body = "Box::pin(${receiver})",
        description = "Put the expression into a pinned `Box`",
        requires = "std::boxed::Box",
        scope = "expr",
    },
    Err = {
        postfix = "Err",
        body = "Err(${receiver})",
        description = "Wrap the expression in a `Result::Err`",
        scope = "expr",
    },
    Ok = {
        postfix = "Ok",
        body = "Ok(${receiver})",
        description = "Wrap the expression in a `Result::Ok`",
        scope = "expr",
    },
    Some = {
        postfix = "Some",
        body = "Some(${receiver})",
        description = "Wrap the expression in an `Option::Some`",
        scope = "expr",
    },
    dbg_d = {
        postfix = "dbg_d",
        body = {
            "#[cfg(debug_assertions)]",
            "dbg!(${receiver});$0",
        },
        description = "Wrap the expression in an debug `dbg!`",
        scope = "expr",
    },
    dbgr_d = {
        postfix = "dbgr_d",
        body = {
            "#[cfg(debug_assertions)]",
            "dbg!(&${receiver});$0",
        },
        description = "Wrap the expression in a ref `dbg!`",
        scope = "expr",
    },
    Br = {
        postfix = "Br",
        body = {
            "{$1",
            "    ${receiver}",
            "$0}",
        },
        description = "Wrap the expression in a `{\n}`",
        scope = "expr",
    },
}

local exprs = {
    -- ["return"] = {
    --     prefix = { "rt", "return" },
    --     body = {
    --         "return $1;",
    --     },
    --     description = "return …;",
    --     scope = "expr",
    -- },
    let = {
        prefix = { "let" },
        body = {
            "let ${1:var} = $2;$0",
        },
        description = "let … = …;",
        scope = "expr",
    },
    letm = {
        prefix = { "letm" },
        body = {
            "let mut ${1:var} = $2;$0",
        },
        description = "let mut … = …;",
        scope = "expr",
    },
    ["tracing_env"] = {
        prefix = { "tracing_env" },
        body = {
            "use std::io;",
            "use tracing_subscriber::{",
            "    prelude::__tracing_subscriber_SubscriberExt, util::SubscriberInitExt, EnvFilter,",
            "};",
            "",
            "/// It is also possible to set the `RUST_LOG` environment variable for other level.",
            "pub fn log_init() {",
            [[    let env_filter = EnvFilter::try_from_default_env().unwrap_or_else(|_| EnvFilter::new("warn"));]],
            "    let stderr_layer = tracing_subscriber::fmt::layer().with_writer(io::stderr);",
            "",
            "    tracing_subscriber::Registry::default()",
            "        .with(stderr_layer)",
            "        .with(env_filter)",
            "        .init();",
            "}",
        },
        requires = { "tracing_subscriber", "tracing" },
        description = "subscriber debug",
        scope = "expr",
    },
    ["tracing"] = {
        prefix = { "tracing_subscriber", "log_sub" },
        body = {
            "tracing_subscriber::fmt()",
            "    .with_max_level(tracing::Level::DEBUG)",
            "    .with_test_writer()",
            "    .init();",
        },
        requires = { "tracing_subscriber", "tracing" },
        description = "subscriber debug",
        scope = "expr",
    },
    ["tracing_appender"] = {
        prefix = { "tracing_appender", "log_sub" },
        body = {
            [[let appender = rolling::never("some/path", "xxx.log");]],
            "let (non_blocking, _guard) = tracing_appender::non_blocking(appender);",
            "",
            [[let env_filter = EnvFilter::try_from_default_env().unwrap_or_else(|_| EnvFilter::new("info"));]],
            "",
            "let file_layer = fmt::layer() .with_thread_ids(true) .with_level(true) .with_ansi(false) .with_writer(non_blocking);",
            "",
            "let formatting_layer = fmt::layer() .pretty() .with_writer(std::io::stderr);",
            "",
            "Registry::default() .with(env_filter) .with(formatting_layer) .with(file_layer) .init();",
        },
        requires = {
            "tracing_appender::rolling",
            "tracing_subscriber::fmt",
            "tracing_subscriber::prelude::__tracing_subscriber_SubscriberExt",
            "tracing_subscriber::util::SubscriberInitExt",
            "tracing_subscriber::EnvFilter",
            "tracing_subscriber::Registry",
        },
        description = "subscriber debug",
        scope = "expr",
    },
    dbg_d_expr = {
        prefix = { "dbg_d" },
        body = {
            "#[cfg(debug_assertions)]",
            "dbg!($1);",
        },
        -- description = "type … = …;",
        scope = "expr",
    },
    dbgr_d_expr = {
        prefix = { "dbgr_d" },
        body = {
            "#[cfg(debug_assertions)]",
            "dbg!(&$1);",
        },
        -- description = "type … = …;",
        scope = "expr",
    },
    thread_spawn = {
        prefix = { "spawn", "tspawn" },
        body = {
            "thread::spawn(move || {",
            "\t$1",
            "});$0",
        },
        description = "Insert a thread::spawn call",
        requires = "std::thread",
        scope = "expr",
    },
    thread_sleep = {
        prefix = { "sleep", "tsleep" },
        body = {
            "thread::sleep($1);$0",
        },
        description = "Insert a thread::sleep",
        requires = "std::thread",
        scope = "expr",
    },
    tokio_spawn = {
        prefix = { "tkspawn" },
        body = {
            "tokio::spawn(async move {",
            "\t$1",
            "});$0",
        },
        description = "Insert a tokio::spawn call",
        requires = "tokio",
        scope = "expr",
    },
    thread_local = {
        body = { "thread_local!(static ${1:STATIC}: ${2:Type} = ${4:init});" },
        description = "thread_local!(static …: … = …);",
        prefix = "thread_local",
        scope = "expr",
    },
}

local items = {
    main = {
        prefix = { "main" },
        body = {
            "fn main() {",
            "    ${0:unimplemented!();}",
            "}",
        },
        description = "fn main() { … }",
        scope = "item",
    },
    tokio_main = {
        prefix = { "tokio_main" },
        body = {
            "#[tokio::main]",
            "async fn main() {",
            "    ${0:unimplemented!();}",
            "}",
        },
        description = "async fn main() { … }",
        requires = "tokio",
        scope = "item",
    },
    tokio_head = {
        prefix = { "tokio_head" },
        body = {
            "#[tokio::main]",
        },
        description = "Add #[tokio::main]",
        requires = "tokio",
        scope = "item",
    },
    tokio_test = {
        prefix = { "tokio_test" },
        body = {
            [=[#[tokio::test(${1:flavor = "multi_thread",} worker_threads = ${2:10})]]=],
        },
        description = "Add #[tokio::test]",
        requires = "tokio",
        scope = "item",
    },
    no_std = {
        prefix = { "no_std" },
        body = {
            "#![no_std]",
        },
        description = "#![no_std]",
        scope = "item",
    },
    no_core = {
        prefix = { "no_core" },
        body = {
            "#![no_core]",
        },
        description = "#![no_core]",
        scope = "item",
    },
    alloc_add = {
        prefix = { "alloc_add" },
        body = {
            "extern crate alloc;",
        },
        description = "add `extern crate alloc;`",
        scope = "item",
    },
    feature = {
        prefix = { "feature" },
        body = {
            "#![feature($0)]",
        },
        description = "Insert a feature",
        scope = "item",
    },
    extern_fn = {
        prefix = { "extern-fn" },
        body = {
            'extern "C" fn ${1:name}(${2:arg}: ${3:Type}) -> ${4:RetType} {',
            "    ${5:// add code here}",
            "}",
        },
        description = 'extern "C" fn …(…) { … }',
        scope = "item",
    },
    extern_mod = {
        prefix = { "extern-mod" },
        body = {
            'extern "${1:C}" {',
            "    ${2:// add code here}",
            "}",
        },
        description = 'extern "C" { … }',
        scope = "item",
    },
    pub_trait = {
        prefix = { "pub-trait" },
        body = {
            "pub trait ${1:Name} {",
            "    ${2:}",
            "}",
        },
        description = "pub trait",
        scope = "item",
    },
    extern_crate = {
        prefix = { "extern-crate" },
        body = {
            "extern crate ${1:name};",
        },
        description = "extern crate …;",
        scope = "item",
    },
    bench = {
        body = {
            "#[bench]",
            "fn ${1:name}(b: &mut test::Bencher) {",
            "    ${2:b.iter(|| ${3:/* benchmark code */})}",
            "}",
        },
        -- requires = {
        --     "test::Bencher",
        -- },
        description = "#[bench]",
        prefix = "bench",
        scope = "item",
    },
    impl_trait = {
        prefix = { "impl_trait" },
        body = {
            "impl ${1:Trait} for ${2:Type} {",
            "    $3",
            "}",
        },
        description = "impl … for … { … }",
        scope = "item",
    },
    mod = {
        prefix = { "mod" },
        body = {
            "mod ${1:name};",
        },
        description = "mod …;",
        scope = "item",
    },
    mod_block = {
        prefix = { "mod_block" },
        body = {
            "mod ${1:name} {",
            "    $2,",
            "}",
        },
        description = "mod … { … }",
        scope = "item",
    },
    ["inline-fn"] = {
        body = { "#[inline]", "pub fn ${1:name}() {", "    ${2:unimplemented!();}", "}" },
        description = "inlined function",
        prefix = "inline-fn",
    },
    let = {
        prefix = { "let" },
        body = {
            "let ${1:var} = $2;$0",
        },
        description = "let … = …;",
        scope = "expr",
    },
    letm = {
        prefix = { "letm" },
        body = {
            "let mut ${1:var} = $2;$0",
        },
        description = "let mut … = …;",
        scope = "expr",
    },
    match_opt = {
        body = {
            "match ${1:expr} {",
            "    Some(${2:expr}) => ${3:expr},",
            "    ${4:None} => ${5:expr},",
            "}",
        },
        description = "match … { … }",
        prefix = "match_option",
    },
    match_res = {
        body = {
            "match ${1:expr} {",
            "    Ok(${2:expr}) => ${3:expr},",
            "    Err(${4:err}) => ${5:expr},",
            "}",
        },
        description = "match … { … }",
        prefix = "match_res",
    },
    thread_local = {
        body = { "thread_local!(static ${1:STATIC}: ${2:Type} = ${4:init});" },
        description = "thread_local!(static …: … = …);",
        prefix = "thread_local",
    },
    try = {
        body = { "try!(${1})" },
        description = "try!(…)",
        prefix = "try",
    },
}

local attrs = {
    expect = {
        prefix = { "expect" },
        body = {
            [=[#${1:!}[expect($2, reason = "$3")]]=],
        },
        description = "expect lint",
        scope = "item",
    },
    allow = {
        prefix = { "allow" },
        body = {
            [=[#${1:!}[allow($2, reason = "$3")]]=],
        },
        description = "allow lint",
        scope = "item",
    },
    deny = {
        prefix = { "deny" },
        body = {
            "#${1:!}[deny($2)]",
        },
        description = "#![deny(…)]",
        scope = "item",
    },
    warn = {
        prefix = { "warn" },
        body = {
            "#${1:!}[warn($2)]",
        },
        description = "#![warn(…)]",
        scope = "item",
    },
    cfg = {
        prefix = { "cfg" },
        body = {
            "#[cfg($1)]",
        },
        description = "#[cfg(…)]",
        scope = "item",
    },
    cfg_attr = {
        prefix = { "cfg_attr" },
        body = {
            "#[cfg_attr($1, $2)]",
        },
        description = "#[cfg(…)]",
        scope = "item",
    },
    derive = {
        prefix = { "derive" },
        body = {
            "#[derive($1)]",
        },
        description = "#![derive(…)]",
        scope = "item",
    },
    repr = {
        prefix = { "repr" },
        body = {
            "#[repr($1)]",
        },
        description = "#[repr(…)]",
        scope = "item",
    },
    macro_use = {
        prefix = { "macro_use" },
        body = {
            "#[macro_use($1)]",
        },
        description = "#[macro_use(…)]",
        scope = "item",
    },
}

local item_expr = {
    static = {
        prefix = { "static" },
        body = {
            "static ${1:STATIC}: ${2:Type} = ${3:init};",
        },
        description = "static …: … = …;",
        scope = "item",
    },
    static_ = {
        prefix = { "static" },
        body = {
            "static ${1:STATIC}: ${2:Type} = ${3:init};",
        },
        description = "static …: … = …;",
        scope = "expr",
    },
    const = {
        prefix = { "const" },
        body = {
            "const ${1:CONST}: ${2:Type} = ${3:init};",
        },
        description = "const …: … = …;",
        scope = "item",
    },
    const_ = {
        prefix = { "const" },
        body = {
            "const ${1:CONST}: ${2:Type} = ${3:init};",
        },
        description = "const …: … = …;",
        scope = "expr",
    },
    enum = {
        prefix = { "enum" },
        body = {
            "#[derive(Clone, Copy)]",
            "#[derive(Debug)]",
            "#[derive(Default)]",
            "#[derive(PartialEq, Eq, PartialOrd, Ord)]",
            "enum ${1:Name} {",
            "    ${2:Variant},",
            "}",
        },
        description = "enum … { … }",
        scope = "item",
    },
    enum_ = {
        prefix = { "enum" },
        body = {
            "#[derive(Clone, Copy)]",
            "#[derive(Debug)]",
            "#[derive(Default)]",
            "#[derive(PartialEq, Eq, PartialOrd, Ord)]",
            "enum ${1:Name} {",
            "    ${2:Variant},",
            "}",
        },
        description = "enum … { … }",
        scope = "expr",
    },
    struct = {
        prefix = { "struct" },
        body = {
            "#[derive(Clone, Copy)]",
            "#[derive(Debug)]",
            "#[derive(Default)]",
            "#[derive(PartialEq, Eq, PartialOrd, Ord)]",
            "pub struct ${1:Name} {",
            "    ${2:field}: ${3:()},",
            "}",
        },
        description = "struct … { … }",
        scope = "item",
    },
    struct_ = {
        prefix = { "struct" },
        body = {
            "#[derive(Clone, Copy)]",
            "#[derive(Debug)]",
            "#[derive(Default)]",
            "#[derive(PartialEq, Eq, PartialOrd, Ord)]",
            "pub struct ${1:Name} {",
            "    ${2:field}: ${3:()},",
            "}",
        },
        description = "struct … { … }",
        scope = "expr",
    },
    struct_tuple = {
        prefix = { "struct_tuple" },
        body = {
            "#[derive(Clone, Copy)]",
            "#[derive(Debug)]",
            "#[derive(Default)]",
            "#[derive(PartialEq, Eq, PartialOrd, Ord)]",
            "pub struct ${1:Name}(${2:()});",
        },
        description = "struct …(…);",
        scope = "item",
    },
    struct_tuple_ = {
        prefix = { "struct_tuple" },
        body = {
            "#[derive(Clone, Copy)]",
            "#[derive(Debug)]",
            "#[derive(Default)]",
            "#[derive(PartialEq, Eq, PartialOrd, Ord)]",
            "pub struct ${1:Name}(${2:()});",
        },
        description = "struct …(…);",
        scope = "expr",
    },
    struct_unit = {
        prefix = { "struct_unit" },
        body = {
            "#[derive(Clone, Copy)]",
            "#[derive(Debug)]",
            "#[derive(Default)]",
            "#[derive(PartialEq, Eq, PartialOrd, Ord)]",
            "pub struct ${1:Name};",
        },
        description = "struct …;",
        scope = "item",
    },
    struct_unit_ = {
        prefix = { "struct_unit" },
        body = {
            "#[derive(Clone, Copy)]",
            "#[derive(Debug)]",
            "#[derive(Default)]",
            "#[derive(PartialEq, Eq, PartialOrd, Ord)]",
            "pub struct ${1:Name};",
        },
        description = "struct …;",
        scope = "expr",
    },
    type = {
        prefix = { "type" },
        body = {
            "type ${1:Alias} = ${2:Type};",
        },
        description = "type … = …;",
        scope = "item",
    },
    type_ = {
        prefix = { "type" },
        body = {
            "type ${1:Alias} = ${2:Type};",
        },
        description = "type … = …;",
        scope = "expr",
    },
}

local rr = vim.tbl_deep_extend("error", postfix, prln, postfix_prln, exprs, items, attrs, item_expr)
return rr
