#!/bin/bash

polybartheme() {
	git clone --depth=1 https://github.com/adi1090x/polybar-themes.git
	cd polybar-themes || return
	chmod +x setup.sh
	./setup.sh
	cd ..
	rm -rf polybar-themes
}
if [[ ! -d ~/.config/polybar/hack ]]; then
	polybartheme
fi

# sudo pacman -S --needed pkg-config libuv cairo libxcb python3 xcb-proto xcb-util-image xcb-util-wm python-sphinx python-packaging \
# 	xcb-util-cursor xcb-util-xrm xcb-util-xrm alsa-lib libpulse mpd libmpdclient libcurl-compat libcurl-gnutls wireless_tools
#
# sudo systemctl enable mpd
# sudo systemctl start mpd

# sed -i "s#^;;password = mysecretpassword#password = mysecretpassword#" ~/.config/polybar/hack/modules.ini

# sed -i "s#^;*host = 127.0.0.1#host = 127.0.0.1#" ~/.config/polybar/hack/modules.ini
# sed -i "s#^;*port = 6600#port = 7000#" ~/.config/polybar/hack/modules.ini

# rm ~/.config/polybar/hack/modules.ini
cat ~/.linuxConfig/i3/polybar/hack-modules.ini >~/.config/polybar/hack/modules.ini

# rm ~/.config/polybar/hack/user_modules.ini
cat ~/.linuxConfig/i3/polybar/hack-user_modules.ini >~/.config/polybar/hack/user_modules.ini

# rm ~/.config/polybar/hack/config.ini
cat ~/.linuxConfig/i3/polybar/hack-config.ini >~/.config/polybar/hack/config.ini

echo '#!/usr/bin/env bash

~/.linuxConfig/rofi/launcher.sh ' >~/.config/polybar/hack/scripts/launcher.sh

installSystray() {

    which powerpill >/dev/null
	if [[ $? == 0 ]]; then
		pacMan="powerpill -S --needed --noconfirm"
	else
		pacMan="pacman -S --needed --noconfirm"
	fi
	sudo $pacMan libayatana-appindicator gtk3
    unset pacMan
}
