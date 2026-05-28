#!/usr/bin/env bash

bold=$(tput bold)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
cyan=$(tput setaf 6)
normal=$(tput sgr0)

time_with_color() {
    "$@"
    LEC=$?
    printf "\n"
    echo -n "${bold}${cyan}<<<<<<<<<<<<<<<<<< time >>>>>>>>>>>>>>>>>>${bold}${normal}"
    echo -n "$yellow"
    # return $LEC
}

time time_with_color "$@"

# 结束变色
echo -n "${normal}"

# 剩余文字蓝色
echo -n "${blue}"

# 命令是否成功执行
exit $LEC

# \e[0m：重置所有属性，将终端颜色设置为默认颜色。
#  背景，字体
# \e[40;30m：黑色
# \e[41;31m：红色
# \e[42;32m：绿色
# \e[43;33m：黄色
# \e[44;34m：蓝色
# \e[45;35m：洋红色
# \e[46;36m：青色
# \e[47;37m：白色
#
# \e,\033 等价
#
#
# echo -e '\e[47;30m 白底黑字 \e[0m'
#
# 字体属性的值可以是,取代背景区域
# 0（重置所有属性）
# 1（高亮）
# 4（下划线）
# 5（闪烁）
# 7（反显）等。
#
#
# echo -e '\e[背景;字体 白底黑字 \e[0m'
