# 对 [linux-wallpaper](https://github.com/Almamu/linux-wallpaperengine) 的包装

目前不支持 **web** 壁纸，`systemctl --user restart wallpaperengine` 就能切换壁纸，有些 **scene** 的壁纸占用 **cpu** 会很高，也 `restart` 就好了。

服务 `enable` 没有效果，好像只能用别的办法让它开机启动。
例如在 i3wm 配置里面添加

```i3config
exec systemctl --user start wallpaperengine.service
```

也可以用[ dex ](https://github.com/jceb/dex)等方法自启动。

原理就是调用 `./wallpaper.sh` 脚本，脚本就几行，看看就知道怎么自定义了。

服务中的执行路径可以自己修改

```bash
    sed -i.bak "s#ExecStart=.*/.linuxConfig/wallpaperengine/wallpaper.sh#ExecStart=$HOME/.linuxConfig/wallpaperengine/wallpaper.sh#" ~/.config/systemd/user/wallpaperengine.service
```

可以改为

```bash
    sed -i.bak "s#ExecStart=.*/path/to/wallpaper.sh#ExecStart=$HOME/path/to/wallpaper.sh#" ~/.config/systemd/user/wallpaperengine.service
```

有些不适宜的壁纸就不要订阅了，不知道怎么排除某些壁纸，真要看也不至于用这个。
