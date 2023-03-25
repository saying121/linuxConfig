scriptencoding utf-8

" F4编译运行
" nnoremap <silent><F1> :call CompileRunGcc()<CR>
func! CompileRunGcc()
    w
    setlocal splitright
    60vsplit
    if &filetype==#'c'
        if !isdirectory('cbuild')
            execute '! mkdir cbuild'
        endif
        exec '! gcc % -o cbuild/%<'
        exec 'term time ./cbuild/%<'
    elseif &filetype==#'cpp'
        if !isdirectory('c++build')
            execute '! mkdir c++build'
        endif
        exec '! g++ % -o c++build/%<'
        exec 'term time ./build/%<'
    elseif &filetype==#'java'
        if !isdirectory('javabuild')
            execute '! mkdir javabuild'
        endif
        exec '! javac -d ./javabuild/ %'
        exec 'term time java -cp ./javabuild/ %<'
    elseif &filetype==#'sh'
        :term time bash %
    elseif &filetype==#'python'
        exec 'term time python3 %'
    elseif &filetype==#'lua'
        exec 'term time lua %'
    elseif &filetype==#'go'
        exec '! go build %<'
        exec 'term time go run %'
    endif
endfunc

" F3编译
" nnoremap <silent><F3> :call CompileGcc()<CR>
func! CompileGcc()
    exec 'w'
    if &filetype==#'c'
        if !isdirectory('cbuild')
            execute '! mkdir cbuild'
        endif
        exec '! gcc % -o cbuild/%<'
        " exec "term time ./cbuild/%<"
    elseif &filetype==#'cpp'
        if !isdirectory('c++build')
            execute '! mkdir c++build'
        endif
        exec '! g++ % -o c++build/%<'
        " exec "term time ./build/%<"
    elseif &filetype==#'java'
        if !isdirectory('javabuild')
            execute '! mkdir javabuild'
        endif
        exec '! javac -d ./javabuild/ %'
        " exec "term time java -cp ./javabuild/ %<"
    elseif &filetype==#'sh'
        " :term time bash %
    elseif &filetype==#'python'
        " exec "term time python3 %"
    elseif &filetype==#'lua'
        " exec "term time lua %"
    elseif &filetype==#'go'
        exec '! go build %<'
        " exec "term time go run %"
    endif
endfunc

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
