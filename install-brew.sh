# echo >> /Users/saying/.zprofile
# echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/saying/.zprofile
# eval "$(/opt/homebrew/bin/brew shellenv)"

brew install clash-verge-rev bash
brew install make cmake xmake pkg-config-wrapper
brew install fzf fd ripgrep bottom eza
brew install coreutils fnm
brew install neovim utf8proc kitty wezterm
brew install thefuck starship
brew install bash-language-server lua-language-server taplo

brew install deno
brew install imagemagick
brew install lua lua@5.1 -f

brew install --cask nikitabobko/tap/aerospace
brew tap FelixKratz/formulae
brew install borders
brew services start borders

brew install bat mdcat
brew install ctpv lf yazi chafa

brew install rustup sccache

~/.linuxConfig/nvim/rust.sh

brew install anhoder/go-musicfox/go-musicfox

brew install font-hack-nerd-font font-noto-sans-cjk

brew install kanata karabiner-elements
# /Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate
#
# KANATA_PATH="$HOME/.cargo/bin/kanata"
# KANATA_CFG_PATH="$HOME/.linuxConfig/configs/kanata.kbd"
# SUDOERS_FILE="/etc/sudoers.d/kanata"
#
# # Create a sudoers file entry for kanata
# echo "$(whoami) ALL=(ALL) NOPASSWD: $KANATA_PATH" | sudo tee "$SUDOERS_FILE" > /dev/null

sudo softwareupdate --install-rosetta
brew install background-music

brew install --cask hiddenbar
xattr -dr com.apple.quarantine /Applications/Hidden\ Bar.app

brew install stats
brew install iproute2mac

brew install atuin
brew services start atuin

brew install frpc
brew services start frpc

brew install teraldeer
brew install betterdisplay

brew install marksman tailwindcss-language-server stylua lolcat
brew install markdownlint-cli2 codespell

defaults write com.apple.dock springboard-rows -int 8
defaults write com.apple.dock springboard-columns -int 9
defaults write com.apple.dock ResetLaunchPad -bool TRUE
killall Dock

brew install quarylabs/quary/sqruff

brew reinstall zsh
brew reinstall pcre pcre2
# shit not work
# sudo chsh -s `/opt/homebrew/bin/zsh` $USER
sudo dscl . -create "/Users/${USER}" UserShell $(brew --prefix)/bin/zsh

brew install github gh
