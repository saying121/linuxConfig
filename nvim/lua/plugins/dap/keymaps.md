nvim-dap.lua

|    key    |         作用          | mode  |
| :-------: | :-------------------: | :---: |
| <space>b  | dap.toggle_breakpoint |   n   |
| <space>B  |  dap.set_breakpoint   |   n   |
|   <F5>    |    `dap.continue`     | n,i,t |
|   <F6>    |    `dap.step_over`    | n,i,t |
|   <F7>    |    `dap.step_into`    | n,i,t |
|   <F8>    |    `dap.step_out`     | n,i,t |
|   <F9>    |    `dap.step_back`    | n,i,t |
|   <F10>   |    `dap.run_last`     | n,i,t |
|   <F11>   |    `dap.terminate`    | n,i,t |
| <space>dr |    `dap.repl.open`    |   n   |
| <space>dl |    `dap.run_last`     |   n   |
| <space>lp | `dap.set_breakpoint`  |   n   |

---

nvim-dap-ui.lua

|    key    |     作用     | mode |
| :-------: | :----------: | :--: |
| <space>dt | dapui.toggle | n,t  |

---

persistent-breakpoints.lua

|    key     |                  作用                   | mode |
| :--------: | :-------------------------------------: | :--: |
| <leader>tb |     persistent.toggle_breakpoint()      |  n   |
| <leader>sc | persistent.set_conditional_breakpoint() |  n   |
| <leader>cl |   persistent.clear_all_breakpoints()    |  n   |
