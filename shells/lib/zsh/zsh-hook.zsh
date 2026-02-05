#!/usr/bin/env zsh

# Enhance git clone so that it will cd into the newly cloned directory
autoload -Uz add-zsh-hook
typeset -g last_cloned_dir

# Preexec: Detect 'git clone' command and set last_cloned_dir so we can cd into it
_git_clone_preexec() {
    local full_cmd="$1"
    local first_word="${full_cmd%% *}"

    # 1. 获取别名的完整定义
    local expanded="$aliases[$first_word]"

    # 2. 如果存在别名，将原始命令中的别名部分替换掉
    # 例如：把 'gcl https://...' 替换为 'git clone --recurse-submodules https://...'
    if [[ -n "$expanded" ]]; then
        full_cmd="${expanded}${full_cmd#$first_word}"
    fi

    # 3. 现在匹配完整的展开后的命令
    # 使用 [[ ... ]] 匹配是否以 git 开头且包含 clone
    if [[ "$full_cmd" =~ "^git.*clone" ]]; then
        # 获取最后一个参数（通常是 URL 或 目录名）
        local last_arg="${full_cmd##* }"

        # 排除掉以 - 开头的参数
        if [[ "$last_arg" != -* ]]; then
            if [[ "$last_arg" =~ ^(https?|git@|ssh://|git://) ]]; then
                last_cloned_dir=$(basename "$last_arg" .git)
            else
                last_cloned_dir="$last_arg"
            fi
        fi
    fi
}

# Precmd: Runs before prompt is shown, and we can cd into our last_cloned_dir
_git_clone_precmd() {
  if [[ -n "$last_cloned_dir" ]]; then
    if [[ -d "$last_cloned_dir" ]]; then
      printf " \e[32m->\e[0m cd %s\n" "$last_cloned_dir"
      cd "$last_cloned_dir"
    fi
    # Reset
    last_cloned_dir=
  fi
}

add-zsh-hook preexec _git_clone_preexec
add-zsh-hook precmd _git_clone_precmd
