scriptencoding utf-8

let g:coc_global_extensions = [
            \ 'coc-clangd',
            \ 'coc-java',
            \ 'coc-snippets',
            \ 'coc-tsserver',
            \ 'coc-pyright',
            \ 'coc-explorer',
            \ 'coc-css',
            \ 'coc-json'
            \ ]
set hidden
nmap <M-CR> <Plug>(coc-codeaction)
"重构函数或重命名,会打开窗口预览
nmap <space>rf <Plug>(coc-refactor)
nmap <space>rn <Plug>(coc-rename)

nmap <silent>[d <Plug>(coc-diagnostic-prev)
nmap <silent>]d <Plug>(coc-diagnostic-next)

nmap <silent>gd <Plug>(coc-definition)
nmap <silent>gy <Plug>(coc-type-definition)

nmap <silent>gi <Plug>(coc-implementation)
nmap <silent>gr <Plug>(coc-references)

nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction

"集成statusline
function! StatusDiagnostic() abort
    let info = get(b:, 'coc_diagnostic_info', {})
    if empty(info) | return '' | endif
    let msgs = []
    if get(info, 'error', 0)
        call add(msgs, 'E' . info['error'])
    endif
    if get(info, 'warning', 0)
        call add(msgs, 'W' . info['warning'])
    endif
    return join(msgs, ' ') . ' ' . get(g:, 'coc_status', '')
endfunction

" 补全
inoremap <silent><expr> z<space> coc#refresh()
" tab补全
function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ CheckBackspace() ? "\<Tab>" :
            \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
"enter确认
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
