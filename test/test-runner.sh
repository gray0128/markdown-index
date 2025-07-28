#!/bin/bash

# 测试运行器
# 用于自动化测试markdown-index.sh脚本的功能

set -euo pipefail

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 测试计数器
total_tests=0
passed_tests=0
failed_tests=0

# 脚本路径
SCRIPT_PATH="../markdown-index.sh"

# 测试函数
run_test() {
    local test_name="$1"
    local input="$2"
    local expected="$3"
    
    echo -e "${YELLOW}运行测试: $test_name${NC}"
    
    # 将输入复制到剪贴板
    echo "$input" | pbcopy
    
    # 运行脚本（silent模式下不会有输出）
    if "$SCRIPT_PATH" >/dev/null 2>&1; then
        # 获取处理后的内容
        result=$(pbpaste)
        
        # 比较结果
        if [[ "$result" == "$expected" ]]; then
            echo -e "${GREEN}✅ 测试通过: $test_name${NC}"
            ((passed_tests++))
        else
            echo -e "${RED}❌ 测试失败: $test_name${NC}"
            echo "期望输出:"
            echo "$expected"
            echo "实际输出:"
            echo "$result"
            echo "---"
            ((failed_tests++))
        fi
    else
        echo -e "${RED}❌ 脚本执行失败: $test_name${NC}"
        ((failed_tests++))
    fi
    
    ((total_tests++))
    echo
}

# 测试用例1：基础多级标题
test1_input="# 第一章
## 第一节
### 第一小节
### 第二小节
## 第二节
# 第二章"

test1_expected="# 1. 第一章
## 1.1. 第一节
### 1.1.1. 第一小节
### 1.1.2. 第二小节
## 1.2. 第二节
# 2. 第二章"

# 测试用例2：包含代码块
test2_input="# 代码示例

这是一个代码块：

\`\`\`python
# 这不是标题
def hello():
    print(\"Hello World\")
\`\`\`

## 函数说明"

test2_expected="# 1. 代码示例

这是一个代码块：

\`\`\`python
# 这不是标题
def hello():
    print(\"Hello World\")
\`\`\`

## 1.1. 函数说明"

# 测试用例3：已有序号（重复运行）
test3_input="# 1. 第一章
## 1.1. 第一节
### 1.1.1. 第一小节
## 1.2. 第二节
# 2. 第二章"

test3_expected="# 1. 第一章
## 1.1. 第一节
### 1.1.1. 第一小节
## 1.2. 第二节
# 2. 第二章"

# 测试用例4：空内容
test4_input=""
test4_expected=""  # 这个测试应该失败，因为脚本会报错

# 测试用例5：无标题内容
test5_input="这是普通文本
没有标题
只是一些段落"
test5_expected=""  # 这个测试应该失败，因为脚本会报错

echo -e "${YELLOW}开始运行markdown-index.sh测试套件${NC}"
echo "===========================================\n"

# 检查脚本是否存在
if [[ ! -f "$SCRIPT_PATH" ]]; then
    echo -e "${RED}错误: 找不到脚本文件 $SCRIPT_PATH${NC}"
    exit 1
fi

# 运行测试
run_test "基础多级标题" "$test1_input" "$test1_expected"
run_test "包含代码块" "$test2_input" "$test2_expected"
run_test "已有序号重复运行" "$test3_input" "$test3_expected"

# 特殊测试：空内容（应该失败）
echo -e "${YELLOW}运行测试: 空内容处理${NC}"
echo "" | pbcopy
if "$SCRIPT_PATH" >/dev/null 2>&1; then
    echo -e "${RED}❌ 测试失败: 空内容处理 (应该报错但没有报错)${NC}"
    ((failed_tests++))
else
    echo -e "${GREEN}✅ 测试通过: 空内容处理 (正确报错)${NC}"
    ((passed_tests++))
fi
((total_tests++))
echo

# 特殊测试：无标题内容（应该失败）
echo -e "${YELLOW}运行测试: 无标题内容处理${NC}"
echo "这是普通文本\n没有标题\n只是一些段落" | pbcopy
if "$SCRIPT_PATH" >/dev/null 2>&1; then
    echo -e "${RED}❌ 测试失败: 无标题内容处理 (应该报错但没有报错)${NC}"
    ((failed_tests++))
else
    echo -e "${GREEN}✅ 测试通过: 无标题内容处理 (正确报错)${NC}"
    ((passed_tests++))
fi
((total_tests++))
echo

# 输出测试结果
echo "===========================================\n"
echo -e "${YELLOW}测试结果总结:${NC}"
echo "总测试数: $total_tests"
echo -e "通过: ${GREEN}$passed_tests${NC}"
echo -e "失败: ${RED}$failed_tests${NC}"

if [[ $failed_tests -eq 0 ]]; then
    echo -e "\n${GREEN}🎉 所有测试通过！${NC}"
    exit 0
else
    echo -e "\n${RED}❌ 有 $failed_tests 个测试失败${NC}"
    exit 1
fi