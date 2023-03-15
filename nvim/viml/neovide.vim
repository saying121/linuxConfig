scriptencoding utf-8

set guifont=hack\ nerd\ font:h9.0   ":w4.5
" g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
let g:neovide_transparency = 0.8
let g:transparency = 0.8
let g:neovide_background_color = '#0f1117'.printf('%x', float2nr(255 * g:transparency))

let g:neovide_floating_blur_amount_x = 2.0
let g:neovide_floating_blur_amount_y = 2.0
let g:neovide_hide_mouse_when_typing = v:true
" 刷新率
let g:neovide_refresh_rate = 60
" no focus 刷新率
let g:neovide_refresh_rate_idle = 5
" setting g:neovide_no_idle to a boolean value will force neovide to redraw all the time. this can be a quick hack if animations appear to stop too early.
let g:neovide_no_idle = v:true
" let g:neovide_fullscreen = v:true
" 显示帧率
" let g:neovide_profiler = v:true
let g:neovide_input_use_logo = v:false  " v:true on macOS

let g:neovide_cursor_animation_length=0.06
let g:neovide_cursor_trail_size = 0.8
let g:neovide_cursor_vfx_mode = 'pixiedust'
let g:neovide_cursor_vfx_opacity = 200.0
let g:neovide_cursor_vfx_particle_lifetime = 1.2
let g:neovide_cursor_vfx_particle_density = 10.0
let g:neovide_cursor_vfx_particle_speed = 10.0
" augroup Resresh
"     autocmd!
"     autocmd WinEnter,InsertLeave * normal <C-l>
" augroup END
