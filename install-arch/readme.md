# 简述脚本的使用

<!--toc:start-->
- [简述脚本的使用](#简述脚本的使用)
  - [运行顺序](#运行顺序)
  - [set-pacman 脚本说明](#set-pacman-脚本说明)
  - [可选的](#可选的)
    - [设置 blackarch 源，随意](#设置-blackarch-源随意)
    - [Athena 源，不过我添加失败了](#athena-源不过我添加失败了)
  - [一些衍生发行版，安装 Athena 基于 arch 的发行版 的说明。](#一些衍生发行版安装-athena-基于-arch-的发行版-的说明)
<!--toc:end-->

---

## 运行顺序

自行想办法复制此目录下脚本到 live 环境，然后使用。

运行 `1*` 之前，先用 `./set-mirrors.sh` 或 `./set-fast-mirrors.sh` 设置软件源,这两个脚本会调用 `./set-pacman.sh` 脚本设置， 不可改变它们和 `./set-pacman.sh` 脚本的位置关系。

挂载后运行 `1*`，根据提示继续运行 `2*` `3*` `4*`

---

## set-pacman 脚本说明

-   设置并行下载软件包的数量为 40
-   开启一些软件源

-   会安装[ aur ](<https://wiki.archlinuxcn.org/wiki/Arch_%E7%94%A8%E6%88%B7%E8%BD%AF%E4%BB%B6%E4%BB%93%E5%BA%93_(AUR)>)助手[ yay、paru ](https://wiki.archlinuxcn.org/wiki/AUR_%E5%8A%A9%E6%89%8B)

---

## 可选的

-   `./set-chaotic-aur-mirrors.sh` 预构建的 aur 软件 ，可以加快 aur 安装，推荐使用
-   安装 `archlinux-tweak-tool-git` 可以开启 arcolinux 源，推荐

---

### 设置 blackarch 源，随意

[`./set-blackarch-mirrors.sh`](https://blackarch.org/)

```bash
# 查看 blackarch 软件
sudo pacman -Sgg | grep blackarch | cut -d' ' -f2 | sort -u

# 查看 组/种类
sudo pacman -Sg | grep blackarch
sudo pacman -S blackarch-<上面的结果>
```

---

### Athena 源，不过我添加失败了

[Athena 源](https://github.com/Athena-OS/athena-repository)

把这些加到 `/etc/pacman.conf` 里面:

```confini
[athena-repository]
SigLevel = Optional TrustedOnly
Server = https://athena-os.github.io/$repo/$arch
```

终端执行:

```bash
sudo pacman-key --recv-keys A3F78B994C2171D5 --keyserver keyserver.ubuntu.com
```

如果收到错误, 继续执行直到密钥导入.

---

## 一些衍生发行版，安装 Athena 基于 arch 的发行版 的说明。

[Athena OS](https://github.com/Athena-OS/athena-iso/releases)

[方法来源](https://github.com/Athena-OS/athena-iso/issues/23)

1. 流畅访问 google,github
2. 修改 `/etc/calamares/modules/welcome.conf`: 把 `internetCheckUrl:   "http://example.com"` 换成 `internetCheckUrl:   "http://www.baidu.com"` .
   如果不行, 删除 `- internet` 下的 `required` 部分.
