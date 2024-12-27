#!/bin/bash

echo -e "\e[1;33m
******************************************
****  Add blackarch input: 1          ****
****  default: do nothing             ****
******************************************
\e[0m
"

[[ -d ~/Downloads ]] || mkdir ~/Downloads
curl -o ~/Downloads/BlackArch.sh -O https://blackarch.org/strap.sh

chmod +x ~/Downloads/BlackArch.sh

sudo ~/Downloads/BlackArch.sh
