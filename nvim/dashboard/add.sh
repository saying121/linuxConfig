#!/bin/bash

for file  in *
do
    # 第一列增加空格之类的
    # sed -i 's/^/                                                  /' $file

    # 去除多余空格
    nvim --headless $file +'w' +'q'
done
