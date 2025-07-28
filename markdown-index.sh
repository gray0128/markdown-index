#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Add Markdown Index
# @raycast.mode silent
#
# Optional parameters:
# @raycast.packageName Markdown Tools
# @raycast.icon 📝
# @raycast.description Add index numbers to markdown headings
# @raycast.author libo
# @raycast.needsConfirmation false

set -euo pipefail

# 获取剪贴板内容
content=$(pbpaste)

# 检查剪贴板是否为空
if [[ -z "$content" ]]; then
    exit 1
fi

# 初始化计数器数组（使用普通数组，索引0-5对应标题级别1-6）
counters=(0 0 0 0 0 0)

# 初始化状态变量
in_code_block=false
processed_lines=()
heading_count=0

# 处理每一行
while IFS= read -r line; do
    # 检查是否进入或退出代码块
    if [[ "$line" =~ ^\`\`\`.*$ ]]; then
        if [[ "$in_code_block" == "true" ]]; then
            in_code_block=false
        else
            in_code_block=true
        fi
        processed_lines+=("$line")
        continue
    fi
    
    # 如果在代码块内，直接添加原行
    if [[ "$in_code_block" == "true" ]]; then
        processed_lines+=("$line")
        continue
    fi
    
    # 检查是否为标题行
    if [[ "$line" =~ ^(#{1,6})[[:space:]]+(.*)$ ]]; then
        # 提取标题级别和内容
        hashes="${BASH_REMATCH[1]}"
        title_content="${BASH_REMATCH[2]}"
        level=${#hashes}
        
        # 移除已有的序号（如果存在）
        # 匹配模式：数字.数字.数字... 后跟点和空格
        title_content=$(echo "$title_content" | sed -E 's/^[0-9]+(\.[0-9]+)*\.[[:space:]]+//')
        
        # 更新计数器（数组索引从0开始，所以level-1）
        ((counters[$((level-1))]++))
        
        # 重置下级计数器
        for ((i=level+1; i<=6; i++)); do
            counters[$((i-1))]=0
        done
        
        # 生成序号
        index_number=""
        for ((i=1; i<=level; i++)); do
            if [[ ${counters[$((i-1))]} -gt 0 ]]; then
                if [[ -n "$index_number" ]]; then
                    index_number="${index_number}.${counters[$((i-1))]}"
                else
                    index_number="${counters[$((i-1))]}"
                fi
            fi
        done
        
        # 构建新的标题行
        new_line="$hashes $index_number. $title_content"
        processed_lines+=("$new_line")
        ((heading_count++))
    else
        # 非标题行，直接添加
        processed_lines+=("$line")
    fi
done <<< "$content"

# 检查是否找到了标题
if [[ $heading_count -eq 0 ]]; then
    exit 1
fi

# 将处理后的内容写回剪贴板
processed_content=$(printf "%s\n" "${processed_lines[@]}")
echo "$processed_content" | pbcopy