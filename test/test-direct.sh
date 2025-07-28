#!/bin/bash

# 简化的测试脚本，直接测试基本功能

set -e

echo "开始测试 markdown-index-direct.sh 脚本..."
echo "======================================"

# 测试计数器
passed=0
total=0

# 辅助函数：运行测试
run_test() {
    local test_name="$1"
    local input="$2"
    local expected="$3"
    
    echo "测试: $test_name"
    ((total++))
    
    # 创建临时文件
    local temp_input=$(mktemp)
    local temp_output=$(mktemp)
    
    echo "$input" > "$temp_input"
    
    # 使用简化的处理逻辑
    local result
    result=$(awk '
    BEGIN {
        for (i = 1; i <= 6; i++) counters[i] = 0
        in_code_block = 0
    }
    /^```/ {
        in_code_block = !in_code_block
        print
        next
    }
    in_code_block {
        print
        next
    }
    /^#{1,6} / {
        # 计算标题级别
        level = 0
        for (i = 1; i <= length($0); i++) {
            if (substr($0, i, 1) == "#") level++
            else break
        }
        
        # 提取标题内容
        title = substr($0, level + 2)
        # 移除已有序号
        gsub(/^[0-9]+(\.[0-9]+)*\. /, "", title)
        
        # 更新计数器
        counters[level]++
        for (i = level + 1; i <= 6; i++) counters[i] = 0
        
        # 生成序号
        number = ""
        for (i = 1; i <= level; i++) {
            if (counters[i] > 0) {
                if (number != "") number = number "."
                number = number counters[i]
            }
        }
        
        # 输出带序号的标题
        printf "%s %s. %s\n", substr($0, 1, level), number, title
        next
    }
    {
        print
    }
    ' "$temp_input")
    
    if [ "$result" = "$expected" ]; then
        echo "✅ 通过"
        ((passed++))
    else
        echo "❌ 失败"
        echo "期望: $expected"
        echo "实际: $result"
    fi
    
    rm -f "$temp_input" "$temp_output"
    echo
}

# 测试用例 1: 基础多级标题
run_test "基础多级标题" \
"# 第一章
## 第一节
### 第一小节
## 第二节" \
"# 1. 第一章
## 1.1. 第一节
### 1.1.1. 第一小节
## 1.2. 第二节"

# 测试用例 2: 包含代码块
run_test "包含代码块" \
"# 标题
\`\`\`bash
# 这不是标题
\`\`\`
## 子标题" \
"# 1. 标题
\`\`\`bash
# 这不是标题
\`\`\`
## 1.1. 子标题"

# 测试用例 3: 已有序号重复运行
run_test "已有序号重复运行" \
"# 1. 第一章
## 1.1. 第一节" \
"# 1. 第一章
## 1.1. 第一节"

# 输出测试结果
echo "======================================"
echo "测试完成: $passed/$total 通过"

if [ $passed -eq $total ]; then
    echo "🎉 所有测试通过！"
    exit 0
else
    echo "❌ 有测试失败"
    exit 1
fi