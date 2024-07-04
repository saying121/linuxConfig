#!/bin/bash

if [[ $1 ]]; then
    sudo input-remapper-control --command stop --device "Keyboard K380 Keyboard" --preset "capslock+"
    sudo input-remapper-control --command stop --device "AT Translated Set 2 keyboard" --preset "capslock+"
    sudo input-remapper-control --command stop --device "SINO WEALTH Gaming KB " --preset "capslock+"
    sudo input-remapper-control --command stop --device "HID 046a:0011" --preset "capslock+"
else
    sudo input-remapper-control --command start --device "Keyboard K380 Keyboard" --preset "capslock+"
    sudo input-remapper-control --command start --device "AT Translated Set 2 keyboard" --preset "capslock+"
    sudo input-remapper-control --command start --device "SINO WEALTH Gaming KB " --preset "capslock+"
    sudo input-remapper-control --command start --device "HID 046a:0011" --preset "capslock+"
fi
