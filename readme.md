# 个人应用配置

![桌面图像](./pictures/wayland.png)

<!--toc:start-->
- [个人应用配置](#个人应用配置)
  - [先运行](#先运行)
  - [如果要使用本配置，执行下面代码，包含 `ranger` 的插件](#如果要使用本配置执行下面代码包含-ranger-的插件)
    - [也可以执行](#也可以执行)
  - [Clone 完成后](#clone-完成后)
  - [Nvidia，自行选择是否安装，最好看 archwiki](#nvidia自行选择是否安装最好看-archwiki)
  - [zsh](#zsh)
- [License](#license)
<!--toc:end-->

除去 arch 安装脚本部分。
高度个性化，谨慎使用。

`./linkConfig.sh` 会尝试取代现有配置，运行时会提示，回车为不取代，输入 **yes** 才尝试取代。

## 如果要使用本配置，执行下面代码，包含 `ranger` 的插件

```bash
git clone --recursive https://github.com/saying121/.linuxConfig.git ~/.linuxConfig
```

### 也可以执行

```bash
$ git clone https://github.com/saying121/.linuxConfig.git ~/.linuxConfig
# 然后拉子自模块
$ git submodule update --init --recursive
```

## Nvidia，自行选择是否安装，最好看 archwiki

```bash
# 安装后运行mkinitcpio
# nvidia/nvidia-open-dkms ,二选一
pacman -Qs nvidia
# cuda
# cuda-tools
# egl-wayland
# lib32-libvdpau
# libvdpau
# libxnvctrl
# nvidia-open-dkms
# nvidia-settings
# nvidia-utils
# nvtop
# opencl-nvidia
# supergfxctl
# lib32-nvidia-utils
```

wayland 直接(也可安装nvidia)

```bash
yay -S nouveau-fw xf86-video-nouveau
```

## zsh

如果安装 zi 框架失败就执行 `sh -c "$(curl -fsSL get.zshell.dev)"`

如果有插件没有安装完成，用 `zi update`

## License

[MIT](./LICENSE)
