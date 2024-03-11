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
    ["sync::Weak::clone"] = {
        postfix = "sync_Weak_clone",
        body = "Weak::clone(&${receiver})",
        description = "Put the expression into a `sync::Weak::clone`",
        requires = "std::sync::Weak",
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

local prefix = {
    ["let-else"] = {
        prefix = { "let-else" },
        body = {
            [[let ${1:var} = ${2:var} else {
                ${3:return;}
            };$0]],
        },
        description = "Insert a async call",
        scope = "expr",
    },
    async = {
        prefix = { "async" },
        body = {
            "async $0",
        },
        description = "Insert a async call",
        scope = "expr",
    },
    unsafe = {
        prefix = { "unsafe" },
        body = {
            "unsafe {",
            "\t$1",
            "}$0",
        },
        description = "Insert a unsafe call",
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
    letm = {
        prefix = { "letm" },
        body = {
            "let mut ${1:var} = $2;$0",
        },
        description = "let mut … = …;",
        scope = "expr",
    },
    ["return"] = {
        prefix = { "rt", "return" },
        body = {
            "return $1;",
        },
        description = "return …;",
        scope = "expr",
    },
    ["tracing"] = {
        prefix = { "tracing_subscriber", "log_sub" },
        body = {
            "tracing_subscriber::fmt()",
            ".with_max_level(tracing::Level::DEBUG)",
            ".with_test_writer()",
            ".init();",
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
}

local friendly = {
    assert = {
        body = { "assert!(${1});" },
        description = "assert!(…);",
        prefix = "assert",
    },
    assert_eq = {
        body = { "assert_eq!(${1}, ${2});" },
        description = "assert_eq!(…, …);",
        prefix = "assert_eq",
    },
    debug_assert_eq = {
        body = { "debug_assert_eq!(${1}, ${2});" },
        description = "debug_assert_eq!(…, …)",
        prefix = "debug_assert_eq",
    },
    debug_assert_ne = {
        body = { "debug_assert_ne!(${1}, ${2});" },
        description = "debug_assert_ne!(…, …)",
        prefix = "debug_assert_ne",
    },
    bench = {
        body = {
            "#[bench]",
            "fn ${1:name}(b: &mut test::Bencher) {",
            "    ${2:b.iter(|| ${3:/* benchmark code */})}",
            "}",
        },
        description = "#[bench]",
        prefix = "bench",
    },
    concat_idents = {
        body = { "concat_idents!(${1})" },
        description = "concat_idents!(…)",
        prefix = "concat_idents",
    },
    format = {
        body = { 'format!("${1}"${2})' },
        description = "format!(…)",
        prefix = "format",
    },
    format_args = {
        body = { 'format_args!("${1}"${2})' },
        description = "format_args!(…)",
        prefix = "format_args",
    },
    ["inline-fn"] = {
        body = { "#[inline]", "pub fn ${1:name}() {", "    ${2:unimplemented!();}", "}" },
        description = "inlined function",
        prefix = "inline-fn",
    },
    let = {
        body = { "let ${1:var} = ${2:expr};" },
        description = "let … = …;",
        prefix = "letv",
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
    option_env = {
        body = { 'option_env!("${1}")' },
        description = 'option_env!("…")',
        prefix = "option_env",
    },
    panic = {
        body = { 'panic!("${1}"${2});' },
        description = "panic!(…);",
        prefix = "panic",
    },
    print = {
        body = { 'print!("$1"$2);$0' },
        description = "print!(…);",
        prefix = "print",
    },
    println = {
        body = { 'println!("$1"$2);$0' },
        description = "println!(…);",
        prefix = "println",
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
    write = {
        body = { 'write!(${1}, "${2}")' },
        description = "write!(…)",
        prefix = "write",
    },
    writeln = {
        body = { 'writeln!(${1}, "${2}")' },
        description = "writeln!(…, …)",
        prefix = "writeln",
    },
}

return vim.tbl_deep_extend("force", postfix, prln, postfix_prln, prefix, friendly)
