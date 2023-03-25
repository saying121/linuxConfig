scriptencoding utf-8
if system('uname --kernel-release | grep -c WSL')>=1
    let g:bracey_browser_command = 'msedge.exe'
endif
