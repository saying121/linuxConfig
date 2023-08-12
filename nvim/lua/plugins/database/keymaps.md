vim-dadbod-ui

|          key           |        作用         | mode |
| :--------------------: | :-----------------: | :--: |
| <kbd>\<leader\>d</kbd> | <cmd>DBUIToggle<cr> |  n   |

参考 :h dadbod.txt,链接数据库

例:
mysql://[<user>[:<password>]@][<host>[:<port>]]/[database]
mysql://root:123456@127.0.0.1:3306

连接失败可以在ui里面按下 <kbd>R</kbd> 刷新

```vimdoc
                                                *dadbod-clickhouse*
ClickHouse

    clickhouse://[<host>[:port]]/[<database>]
    clickhouse:[database]

Use the `secure` query parameter to enable TLS.

                                                *dadbod-impala*
Impala

    impala://[<host>[:<port>]]/[<database>]

                                                *dadbod-jq*
jq

    jq:relative/path
    jq:/absolute/path
    jq:C:/windows/path

An empty path runs jq without input, see the --null-input parameter.

                                                *dadbod-mongodb*
MongoDB

    mongodb://[<user>[:<password>]@][<host>[:<port>]]/[<database>]
    mongodb:[<database>]

Any valid MongoDB connection string URI can be used.

                                                *dadbod-mysql*
MySQL

    mysql://[<user>[:<password>]@][<host>[:<port>]]/[database]
    mysql://[<user>[:<password>]@][<%2Fsocket%2Fpath>]/[<database>]
    mysql:[<database>]

Query parameters such as `login-path`, `protocol`, `ssl-ca`, `ssl-cert`, and
`ssl-key` are passed as the corresponding command line options.

                                                *dadbod-oracle*
Oracle

    oracle://[<user>[:<password>]@][<host>][:<port>]/[<database>]
    oracle:<user>/<password>@[//]<host>[:<port>]/<database>

                                                *dadbod-osquery*
osquery

    osquery:relative/path
    osquery:/absolute/path
    osquery:C:/windows/path

An empty path portion uses an in-memory database, which is how osquery is
typically invoked.

                                                *dadbod-postgresql*
PostgreSQL

    postgresql://[<user>[:<password>]@][<host>[:<port>]]/[<database>]
    postgresql://[<user>[:<password>]@][<%2Fsocket%2Fpath>]/[<database>]
    postgresql:[<database>]

Any valid PostgreSQL connection URI can be used.  The postgres:// variant is
also accepted.

                                                *dadbod-presto*
Presto

    presto://[<host>[:<port>]]/[<catalog>[/<schema>]]

                                                *dadbod-redis*
Redis

    redis://[[unused[:<password>]@]<host>]/[<database-number>]
    redis:[<database-number>]

Redis doesn't have a username, so use a dummy one in the URL if a password is
required.

                                                *dadbod-sqlserver*
SQL Server

    sqlserver://[<user>[:<password>]@][<host>][:<port>]/[<database>]
    sqlserver://[<host>[:<port>]][;user=<user>][;...]

Supported query parameters are `secure` and `trustServerCertificate`, which
correspond to connection properties of the same name.

To set the `integratedSecurity` connection property and use a trusted
connection, omit the user and password.

                                                *dadbod-sqlite*
SQLite

    sqlite:relative/path
    sqlite:/absolute/path
    sqlite:C:/windows/path
    sqlite:///relative/or/absolute/path

In the wild, uses of sqlite:///path vary on whether the path is relative or
absolute, so both are checked.  The preferred form is sqlite:path, which
avoids this ambiguity.

An empty path portion uses an in-memory database, which is occasionally useful
for an interactive invocation.
```
