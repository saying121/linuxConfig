lspsaga.lua

|          keys           |             作用             | mode |
| :---------------------: | :--------------------------: | :--: |
|      <kbd>gh</kbd>      | 查看函数或变量调用和定义位置 |  n   |
|   <kbd>\<M-CR\></kbd>   |         code action          | n,x  |
| <kbd>\<space\>rn</kbd>  |      重命名变量或者函数      |  n   |
| <kbd>\<space\>Rn</kbd>  |   整个项目里面寻找要修改的   |  n   |
|      <kbd>gD</kbd>      |         小窗预览定义         |  n   |
|      <kbd>gd</kbd>      |         前往定义文件         |  n   |
|      <kbd>gY</kbd>      |       小窗预览类型定义       |  n   |
|      <kbd>gy</kbd>      |       前往类型定义文件       |  n   |
| <kbd>\<space\>gg</kbd>  |         查看本行诊断         |  n   |
|      <kbd>[d</kbd>      |        前一个诊断位置        |  n   |
|      <kbd>]d</kbd>      |        下一个诊断位置        |  n   |
|      <kbd>[e</kbd>      |        上一个错误位置        |  n   |
|      <kbd>e]</kbd>      |        下一个错误位置        |  n   |
| <kbd>\<leader\>ol</kbd> |           outline            |  n   |
|      <kbd>K</kbd>       |    帮助文档，折叠预览等等    |  n   |
|      <kbd>ck</kbd>      |         持久帮助文档         |  n   |
| <kbd>\<leader\>ci</kbd> | <cmd>Lspsaga incoming_calls  |  n   |
| <kbd>\<leader\>co</kbd> | <cmd>Lspsaga outgoing_calls  |  n   |
|   <kbd>\<M-a\></kbd>    |           悬浮终端           | n,t  |

---

rust-crates.lua

|     keys      |       作用        | mode |
| :-----------: | :---------------: | :--: |
| <kbd>ct</kbd> | 是否显示版本信息  |  n   |
| <kbd>cr</kbd> |     重新加载      |  n   |
| <kbd>cf</kbd> |     查看功能      |  n   |
| <kbd>cd</kbd> |     查看依赖      |  n   |
| <kbd>cu</kbd> |    升级 crate     |  n   |
| <kbd>cu</kbd> |    升级选中的     |  x   |
| <kbd>K</kbd>  | 帮助文档(lspsaga) |  n   |

---

rust-tools.lua

|          keys          |      作用       | mode |
| :--------------------: | :-------------: | :--: |
|   <kbd>\<M-f\></kbd>   | rust 专用 hover |  n   |
|     <kbd>mk</kbd>      |  向上移动 item  |  n   |
|     <kbd>mj</kbd>      |  向下移动 item  |  n   |
| <kbd>\<leader\>R</kbd> | 查看可 run 项目 |  n   |
|   <kbd>\<C-g\></kbd>   | 打开 Cargo.toml |  n   |
|  <kbd>\<S-CR\></kbd>   |     展开宏      |  n   |

---

trouble.lua

|          keys          |     作用     | mode |
| :--------------------: | :----------: | :--: |
| <kbd>\<space\>ll</kbd> | 列出文档诊断 |  n   |
| <kbd>\<space\>lw</kbd> |  工作区诊断  |  n   |

---

neogen.lua

|         keys         |              作用               | mode |
| :------------------: | :-----------------------------: | :--: |
| <kbd>\<C-S-e\></kbd> |         整个文件的文档          | n, x |
| <kbd>\<C-S-a\></kbd> | 自动判断生成文档，函数,class 等 | n, x |
