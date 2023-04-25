scriptencoding utf-8


" nnoremap <silent><leader>s :call CheckChineseMark()<CR>:w<CR>
" vnoremap <silent><leader>s :call CheckChineseMark()<CR>:w<CR>
function! CheckChineseMark()
    "依次检查
    if search('。')
        let s:line=search('。')
        execute s:line . 's/。/\./g'
    endif

    if search('，')
        let s:line=search('，')
        execute s:line . 's/，/,/g'
    endif

    if search('；')
        let s:line=search('；')
        execute s:line . 's/；/,/g'

    endif

    if  search('？')
        let s:line=search('？')
        execute s:line . 's/？/?/g'
    endif

    if search('：')
        let s:line=search('：')
        execute s:line . 's/：/\:/g'
    endif

    if search('‘')
        let s:line=search('‘')
        execute s:line . "s/‘/\'/g"
    endif

    if search('’')
        let s:line=search('’')
        execute s:line . "s/’/\'/g"
    endif

    if search('”')
        let s:line=search('”')
        execute s:line . "s/”/\"/g"
    endif

    if search('“')
        let s:line=search('“')
        execute s:line . "s/“/\"/g"
    endif

    if search('《')
        let s:line=search('《')
        execute s:line . 's/《/\</g'
    endif

    if search('》')
        let s:linie=search('》')
        execute s:line . 's/》/\>/g'
    endif

    if search('——')
        let s:line=search('——')
        execute s:line . 's/——/-/g'
    endif

    if search('）')
        let s:line=search('）')
        execute s:line . 's/）/\)/g'
    endif

    if search('（')
        let s:line=search('（')
        execute s:line . 's/（/\(/g'
    endif

    if search('……')
        let s:line=search('……')
        execute s:line . 's/……/^/g'
    endif

    if search('￥')
        let s:line=search('￥')
        execute s:line . 's/￥/$/g'
    endif

    if search('！')
        let s:line=search('！')
        execute s:line . 's/！/!/g'
    endif

    if search('·')
        let s:line=search('·')
        execute s:line . 's/·/`/g'
    endif

endfunction

function! MoveToPrevTab()
    "there is only one window
    if tabpagenr('$') == 1 && winnr('$') == 1
        return
    endif
    "preparing new window
    let l:tab_nr = tabpagenr('$')
    let l:cur_buf = bufnr('%')
    if tabpagenr() != 1
        close!
        if l:tab_nr == tabpagenr('$')
            tabprev
        endif
        sp
    else
        close!
        exe '0tabnew'
    endif
    "opening current buffer in new window
    exe 'b'.l:cur_buf
endfunc

function! MoveToNextTab()
    "there is only one window
    if tabpagenr('$') == 1 && winnr('$') == 1
        return
    endif
    "preparing new window
    let l:tab_nr = tabpagenr('$')
    let l:cur_buf = bufnr('%')
    if tabpagenr() < tab_nr
        close!
        if l:tab_nr == tabpagenr('$')
            tabnext
        endif
        sp
    else
        close!
        tabnew
    endif
    "opening current buffer in new window
    exe 'b'.l:cur_buf
endfunc

" 把tab移动到buffer里面
nnoremap mt :call MoveToNextTab()<cr>
nnoremap mT :call MoveToPrevTab()<cr>
