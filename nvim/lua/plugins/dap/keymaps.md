nvim-dap.lua

|          key           |          作用           | mode  |
| :--------------------: | :---------------------: | :---: |
| <kbd>\<space\>b</kbd>  | `dap.toggle_breakpoint` |   n   |
| <kbd>\<space\>B</kbd>  |  `dap.set_breakpoint`   |   n   |
|   <kbd>\<F5\></kbd>    |     `dap.continue`      | n,i,t |
|   <kbd>\<F6\></kbd>    |     `dap.step_over`     | n,i,t |
|   <kbd>\<F7\></kbd>    |     `dap.step_into`     | n,i,t |
|   <kbd>\<F8\></kbd>    |     `dap.step_out`      | n,i,t |
|   <kbd>\<F9\></kbd>    |     `dap.step_back`     | n,i,t |
|   <kbd>\<F10\></kbd>   |     `dap.run_last`      | n,i,t |
|   <kbd>\<F11\></kbd>   |     `dap.terminate`     | n,i,t |
| <kbd>\<space\>dr</kbd> |     `dap.repl.open`     |   n   |
| <kbd>\<space\>dl</kbd> |     `dap.run_last`      |   n   |
| <kbd>\<space\>lp</kbd> |  `dap.set_breakpoint`   |   n   |

---

nvim-dap-ui.lua

|          key           |     作用     | mode |
| :--------------------: | :----------: | :--: |
| <kbd>\<space\>dt</kbd> | `dapui.toggle` | n,t  |

---

persistent-breakpoints.lua

|           key           |                   作用                    | mode |
| :---------------------: | :---------------------------------------: | :--: |
| <kbd>\<leader\>tb</kbd> |     `persistent.toggle_breakpoint()`      |  n   |
| <kbd>\<leader\>sc</kbd> | `persistent.set_conditional_breakpoint()` |  n   |
| <kbd>\<leader\>cl</kbd> |   `persistent.clear_all_breakpoints()`    |  n   |
