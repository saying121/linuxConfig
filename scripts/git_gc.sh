#!/usr/bin/env bash

git gc --prune=now

# 大文件
git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -5 | awk '{print$1}')"

# 把命令中的 yourFileName 改成上一步获取到的文件名称。
git filter-branch --force --index-filter "git rm --cached --ignore-unmatch 'yourFileName'" --prune-empty --tag-name-filter cat -- --all

git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
git reflog expire --expire=now --all
git gc --prune=now

# pack 的空间使用情况
git count-objects -v

rm -rf .git/refs/original/
git reflog expire --expire=now --all
git gc --prune=now
