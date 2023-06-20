lspsaga.lua

|    keys    |             作用             | mode |
| :--------: | :--------------------------: | :--: |
|     gh     | 查看函数或变量调用和定义位置 |  n   |
|   <M-CR>   |         code action          | n,x  |
| <space>rn  |      重命名变量或者函数      |  n   |
| <space>Rn  |   整个项目里面寻找要修改的   |  n   |
|     gD     |         小窗预览定义         |  n   |
|     gd     |         前往定义文件         |  n   |
|     gY     |       小窗预览类型定义       |  n   |
|     gy     |       前往类型定义文件       |  n   |
| <space>gg  |         查看本行诊断         |  n   |
|     [d     |        前一个诊断位置        |  n   |
|     ]d     |        下一个诊断位置        |  n   |
|     [e     |        上一个错误位置        |  n   |
|     e]     |        下一个错误位置        |  n   |
| <leader>ol |           outline            |  n   |
|     K      |    帮助文档，折叠预览等等    |  n   |
|     ck     |         持久帮助文档         |  n   |
| <leader>ci | <cmd>Lspsaga incoming_calls  |  n   |
| <leader>co | <cmd>Lspsaga outgoing_calls  |  n   |
|   <M-a>    |           悬浮终端           | n,t  |

---

rust-crates.lua

| keys |       作用        | mode |
| :--: | :---------------: | :--: |
|  ct  | 是否显示版本信息  |  n   |
|  cr  |     重新加载      |  n   |
|  cf  |     查看功能      |  n   |
|  cd  |     查看依赖      |  n   |
|  cu  |    升级 crate     |  n   |
|  cu  |    升级选中的     |  x   |
|  K   | 帮助文档(lspsaga) |  n   |

---

rust-tools.lua

|   keys    |      作用       | mode |
| :-------: | :-------------: | :--: |
|   <M-f>   |   专用 hover    |  n   |
|    mk     |  向上移动 item  |  n   |
|    mj     |  向下移动 item  |  n   |
| <leader>R | 查看可 run 项目 |  n   |
|   <C-g>   | 打开 Cargo.toml |  n   |
|  <S-CR>   |     展开宏      |  n   |

---

trouble.lua

|   keys    |     作用     | mode |
| :-------: | :----------: | :--: |
| <space>ll | 列出文档诊断 |  n   |
| <space>lw |  工作区诊断  |  n   |

---

neogen.lua

|  keys   |              作用               | mode |
| :-----: | :-----------------------------: | :--: |
| <C-S-f> |         整个文件的文档          | n, x |
| <C-S-a> | 自动判断生成文档，函数,class 等 | n, x |
