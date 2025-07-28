#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Markdown Index Direct
# @raycast.mode silent
# @raycast.packageName Markdown Tools
# @raycast.description 直接为选中的 Markdown 内容添加多级序号，无需复制粘贴
# @raycast.author libo
# @raycast.authorURL https://github.com/libo
# @raycast.icon 📝

# 获取并处理选中的文本内容
process_selected_text() {
    osascript -e '
        tell application "System Events"
            try
                # 复制选中内容到剪贴板
                keystroke "c" using command down
                delay 0.1
                set selectedText to the clipboard
                
                # 检查是否有选中内容
                if selectedText is "" then
                    return "ERROR:NO_SELECTION"
                end if
                
                # 检查是否包含 Markdown 标题
                if selectedText does not contain "#" then
                    return "ERROR:NO_HEADERS"
                end if
                
                return selectedText
            on error
                return "ERROR:FAILED"
            end try
        end tell
    '
}


# 处理 Markdown 标题序号的函数
process_markdown() {
    local content="$1"
    local processed_content=""
    local counters=(0 0 0 0 0 0)  # 支持6级标题
    local in_code_block=false
    local code_block_type=""
    
    while IFS= read -r line; do
        # 检查代码块状态
        if [[ $line =~ ^\`\`\`.*$ ]]; then
            if [ "$in_code_block" = false ]; then
                in_code_block=true
                code_block_type="$line"
            else
                in_code_block=false
                code_block_type=""
            fi
            processed_content+="$line"$'\n'
            continue
        fi
        
        # 如果在代码块中，直接添加行
        if [ "$in_code_block" = true ]; then
            processed_content+="$line"$'\n'
            continue
        fi
        
        # 检查是否为标题行
        if [[ $line =~ ^(#{1,6})[[:space:]](.*)$ ]]; then
            local hashes="${BASH_REMATCH[1]}"
            local title_content="${BASH_REMATCH[2]}"
            local level=${#hashes}
            
            # 移除已有的序号（如果存在）
            title_content=$(echo "$title_content" | sed -E 's/^[0-9]+(\.[0-9]+)*\.[[:space:]]+//')
            
            # 更新当前级别的计数器
            counters[$((level-1))]=$((${counters[$((level-1))]} + 1))
            
            # 重置下级计数器
            for ((i=level; i<6; i++)); do
                counters[$i]=0
            done
            
            # 生成序号
            local number=""
            for ((i=0; i<level; i++)); do
                local counter_val=${counters[$i]}
                if [ $counter_val -gt 0 ]; then
                    if [ -n "$number" ]; then
                        number+="."
                    fi
                    number+="$counter_val"
                fi
            done
            
            # 添加处理后的标题行
            processed_content+="$hashes $number. $title_content"$'\n'
        else
            # 非标题行直接添加
            processed_content+="$line"$'\n'
        fi
    done <<< "$content"
    
    # 移除最后的换行符
    processed_content=${processed_content%$'\n'}
    echo "$processed_content"
}

# 主函数
main() {
    # 保存原始剪贴板内容
    local original_clipboard
    original_clipboard=$(pbpaste)
    
    # 获取选中的文本
    local selected_text
    selected_text=$(process_selected_text)
    
    # 检查错误
    if [[ "$selected_text" == ERROR:* ]]; then
        # 恢复原始剪贴板内容
        echo "$original_clipboard" | pbcopy
        exit 1
    fi
    
    # 处理 Markdown 内容
    local processed_content
    processed_content=$(process_markdown "$selected_text")
    
    # 将处理后的内容复制到剪贴板并直接粘贴
    echo "$processed_content" | pbcopy
    
    # 直接粘贴替换（选中状态应该还在）
    osascript -e '
        tell application "System Events"
            keystroke "v" using command down
        end tell
    '
    
    # 恢复原始剪贴板内容
    echo "$original_clipboard" | pbcopy
}

# 执行主函数
main