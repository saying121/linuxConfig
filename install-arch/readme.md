# 简述脚本的使用
自行想办法复制此目录下脚本到live环境，然后使用。

运行1之前，先用 `./set-mirrors.sh` 或 `./set-fast-mirrors.sh` 设置软件源,这两个脚本会调用 `./set-pacman.sh` 脚本设置， 不可改变它们和 `./set-pacman.sh` 脚本的位置关系。

挂载后运行1，根据提示继续运行234

## set-pacman 脚本说明
会安装[ aur ](https://wiki.archlinuxcn.org/wiki/Arch_%E7%94%A8%E6%88%B7%E8%BD%AF%E4%BB%B6%E4%BB%93%E5%BA%93_(AUR))助手[ yay、paru ](https://wiki.archlinuxcn.org/wiki/AUR_%E5%8A%A9%E6%89%8B) 和加速版`pacman` :[ powerpill ](https://wiki.archlinuxcn.org/wiki/Powerpill),在其他脚本中会优先使用`powerpill`。

其中powerpill 需要签名文件所以需要判/etc/pacman.conf 文件是否有[ SigLevel ](https://wiki.archlinuxcn.org/wiki/Powerpill#%E7%96%91%E9%9A%BE%E8%A7%A3%E7%AD%94)字段
