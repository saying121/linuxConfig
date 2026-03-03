#!/usr/bin/env zsh

# Enhance git clone and cargo new so that it will cd into the newly created directory
autoload -Uz add-zsh-hook
typeset -g last_create_dir

# Preexec: Detect 'git clone' or 'cargo new' command and set last_cloned_dir so we can cd into it
_create_dir_preexec() {
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
                last_create_dir=$(basename "$last_arg" .git)
            else
                last_create_dir="$last_arg"
            fi
        fi
    # 检测 cargo new 命令
    elif [[ "$full_cmd" =~ "^cargo.*new" ]]; then
        # 解析参数，找到第一个不以 - 开头的参数作为项目名称
        local args=(${=full_cmd})
        local project_name=""

        # 跳过前两个词（cargo 和 new）
        for ((i=3; i<=${#args}; i++)); do
            local arg="${args[$i]}"
            if [[ "$arg" != -* ]]; then
                project_name="$arg"
                break
            fi
        done

        if [[ -n "$project_name" ]]; then
            last_create_dir="$project_name"
        fi
    fi
}

# Precmd: Runs before prompt is shown, and we can cd into our last_cloned_dir
_create_dir_precmd() {
  if [[ -n "$last_create_dir" ]]; then
    if [[ -d "$last_create_dir" ]]; then
      printf " \e[32m->\e[0m cd %s\n" "$last_create_dir"
      cd "$last_create_dir"
    fi
    # Reset
    last_create_dir=
  fi
}

add-zsh-hook preexec _create_dir_preexec
add-zsh-hook precmd _create_dir_precmd
