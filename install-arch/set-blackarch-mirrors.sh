#!/bin/bash

echo -e "\e[1;33m
******************************************
****  Add blackarch input: 1          ****
****  Rankmirrors blackarch input: 2  ****
****  default: do nothing             ****
******************************************
\e[0m
"

read -r answer

if [[ $answer = 1 ]]; then
    [[ -d ~/Downloads ]] || mkdir ~/Downloads
    curl -o ~/Downloads/BlackArch.sh -O https://blackarch.org/strap.sh

    chmod +x ~/Downloads/BlackArch.sh

    sudo ~/Downloads/BlackArch.sh
elif [[ $answer = 2 ]]; then

    echo '
    Server = https://mirror.sjtu.edu.cn/blackarch/$repo/os/$arch
    Server = https://mirrors.nju.edu.cn/blackarch/$repo/os/$arch
    Server = http://mirrors.nju.edu.cn/blackarch/$repo/os/$arch
    Server = https://mirrors.tuna.tsinghua.edu.cn/blackarch/$repo/os/$arch
    Server = https://mirrors.ustc.edu.cn/blackarch/$repo/os/$arch
    Server = http://mirrors.aliyun.com/blackarch/$repo/os/$arch
    Server = https://mirrors.aliyun.com/blackarch/$repo/os/$arch
    ' | rankmirrors -n all - |
        sudo tee /etc/pacman.d/blackarch-mirrorlist
fi
