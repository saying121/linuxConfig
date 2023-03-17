这是对 [linux-wallpaper](https://github.com/Almamu/linux-wallpaperengine) 的包装，先运行 `./cloneWallpaperShare.sh` 下载必要的依赖\( 只 clone 了仓库的 share 文件夹部分\)，非 **arch** 用户需要自行手动安装并把二进制文件放入`$PATH` 变量，然后运行 `systemctl --user start wallpaperengine` 就可以启动了。目前它不支持 web 壁纸，`systemctl --user restart wallpaperengine` 就能切换壁纸，有些 scene 的壁纸占用 cpu 会很高，也 `restart` 就好了。

服务 enable 没有效果，好像只能用别的办法让它开机启动。

原理就是调用 `./wallpaper.sh` 脚本，脚本就几行，看看就知道怎么自定义了。
