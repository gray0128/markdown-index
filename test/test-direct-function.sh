#!/bin/bash

# 测试 process_markdown 函数
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

# 测试用的 Markdown 内容
test_content="# 第一章

这是第一章的内容。

## 第一节

这是第一节的内容。

### 小节1

这是小节1的内容。

### 小节2

这是小节2的内容。

## 第二节

这是第二节的内容。

# 第二章

这是第二章的内容。

\`\`\`bash
# 这是代码块
echo \"hello\"
\`\`\`

## 代码后的章节

这是代码后的章节。"

echo "测试输入:"
echo "$test_content"
echo ""
echo "处理结果:"
process_markdown "$test_content"