scriptencoding utf-8

function! GitBranch()
    return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
    let l:branchname = GitBranch()
    return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

function! LinuxRelease()
    if has('win32')
        let l:prompy_symbol=' '
        return prompy_symbol
    elseif has('mac')
        let l:prompy_symbol=' '
        return prompy_symbol
    endif
    if system('env | grep -c TERMUX_VERSION')
        let l:prompy_symbol=' '
        return prompy_symbol
    endif
    let l:releases={
                \'arch'         :' ',
                \'kali'         :' ',
                \'ubuntu'       :' ',
                \'suse'         :' ',
                \'manjaro'      :' ',
                \'pop'          :' ',
                \}
    " 这个shell语句比lsb_release+awk快
    let l:key=system("awk -F= '/^ID/{print $2}' </etc/os-release")
    " 貌似获取的key后面多了什么值，切割来获取纯净的字符串
    let l:key=split(key)[0]
    if has_key(releases, key)
        let l:prompy_symbol=releases[key]
        return prompy_symbol
    else
        let l:prompy_symbol=' '
        return prompy_symbol
    endif
endfunction

func! FileType()
    let l:filetypes = {
                \ 'c'                       :' ',
                \ 'cpp'                     :'ﭱ ',
                \ 'java'                    :' ',
                \ 'javascript'              :' ',
                \ 'html'                    :' ',
                \ 'json'                    :' ',
                \ 'sh'                      :' ',
                \ 'python'                  :' ',
                \ 'lua'                     :' ',
                \ 'go'                      :' ',
                \ 'vim'                     :' ',
                \ 'markdown'                :' ',
                \ 'txt'                     :' ',
                \ 'text'                    :' ',
                \ 'log'                     :' ',
                \ 'help'                    :' ',
                \ 'rust'                    :' ',
                \ 'dapui_watches'           :' ',
                \ 'dapui_stacks'            :' ',
                \ 'dapui_breakpoints'       :' ',
                \ 'dapui_scopes'            :' ',
                \ 'dapui_console'           :' ',
                \ 'dap-repl'                :' ',
                \ 'NvimTree'                :'串 ',
                \ 'lspsagafinder'           :' ',
                \ ''                        :' ',
                \}

    if has_key(filetypes, &filetype)
        let l:prompy_symbol=filetypes[&filetype]
        return prompy_symbol
    else
        return '[' . &filetype . ']'
    endif
endfunc

set laststatus=2                                            " 显示状态栏信息


set statusline=%1*\%{StatuslineGit()}                       " git分支
set statusline+=%2*\%.50F\                                  " 显示文件名和文件路径 (%<应该可以去掉)
set statusline+=%=%3*\%m%{FileType()}%<%r%w\%*              " 显示文件类型及文件状态
set statusline+=%8*%{LinuxRelease()}%*                      " 显示系统
set statusline+=%4*\[%{&fenc}]\%*                           " 文件编码
set statusline+=%5*\ row:%l/%L\|col:%c\ %*                  " 显示光标所在行和列
set statusline+=%6*\%3p%%\%*                                " 显示光标前文本所占总文本的比例
hi User1 guifg=Olivedrab
hi User2 guifg=blue
" hi User7 guifg=red
hi User8 guifg=beige
hi User3 guifg=Turquoise
hi User4 guifg=Darkgray
hi User5 guifg=Cyan
hi User6 guifg=green
" %  (...%)定义一个项目组
" %{n}* 高亮组，颜色
" %B 光标下字符的十六进制
" %b 光标下的十进制形式
" %N 打印机页号
" %O 十六进制显示文件字符偏移
" %a 多行文本中，显示（{current}of{arguements}）,只有一行就为空
" %o 光标前的字符数，包括光标下的字符
" %v 虚列号
" %w 预览窗口显示[Preview]
" %{expr} 表达式结果
" %number *\ ... \%*和对应，后面设置的颜色样式会应用到中的部分hi User<number>hi User<number>%number *\ ... \%*...
" %< 如果状态行过长，在何处换行
" %F 完整文件路径名
" %f 缓冲区文件路径
" %t 文件名，无路径
" %.50F 文件路径名长度不超过50，超过则进行缩写
" %= 在此之后的内容，显示在状态栏上时右对齐
" %Y 显示缓冲区类型
" %y 文件类型
" %M 文件改过就显示+
" %m 如果缓冲区已修改则表示为[+]
" %R 只读缓冲区显示RO
" %r 如果缓冲区为只读则表示为[RO]
" %H 帮助缓冲区显示为HLP
" %h 如果为帮助显示为缓冲区[Help]
" %w 如果为预览窗口则显示为[Preview]
" %W 预览窗口就显示PRV
" %{&ff} 显示文件系统类型
" %{&fenc} 显示文件编码
" %l 光标所在行数
" %L 文件总行数
" %n 缓冲区行号
" %c 光标所在列数
" %V 列数,与%c相同显示空字符串
" %p 当前行数占总行数的的百分比
" cterm：设置粗体，斜体，正体;guifg,ctermfg：前景色;ctermbg：背景色
