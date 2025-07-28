# Markdown Index 脚本架构设计

## Raycast脚本规范要求

基于官方文档研究，Raycast脚本需要包含以下元数据：

### 必需参数
- `@raycast.schemaVersion 1` - API版本
- `@raycast.title` - 脚本显示名称
- `@raycast.mode` - 执行模式

### 可选参数
- `@raycast.packageName` - 包名
- `@raycast.icon` - 图标（emoji或文件路径）
- `@raycast.description` - 描述
- `@raycast.author` - 作者
- `@raycast.needsConfirmation` - 是否需要确认

## 脚本架构设计

### 1. 脚本模式选择

选择 `@raycast.mode silent` 模式：
- 静默处理，不显示 Raycast 界面
- 避免干扰用户当前的工作流程
- 处理完成后用户可以直接在原程序中粘贴结果
- 提供更流畅的用户体验

### 2. 核心功能模块

```bash
#!/bin/bash

# Raycast元数据
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

# 主要功能模块：
# 1. 获取剪贴板内容
# 2. 解析和处理markdown
# 3. 生成序号
# 4. 写回剪贴板
# 5. 静默退出
```

### 3. 数据流设计

```
用户选中文本 → 复制到剪贴板 → 调用脚本 → 处理内容 → 写回剪贴板 → 显示结果
```

### 4. 核心算法设计

#### 4.1 标题识别算法
```bash
# 使用正则表达式识别markdown标题
# 模式：^(#{1,6})\s+(.*)$
# 提取：标题级别（#的数量）和标题内容
```

#### 4.2 代码块保护算法
```bash
# 识别代码块边界
# 三重反引号：```
# 四空格缩进代码块
# 在代码块内的内容跳过处理
```

#### 4.3 序号生成算法
```bash
# 维护层级计数器数组
# counters[1]=0, counters[2]=0, counters[3]=0...
# 根据标题级别更新对应计数器
# 重置下级计数器
```

### 5. 错误处理策略

- 剪贴板为空：提示用户先选中内容
- 无markdown标题：提示没有找到可处理的标题
- 处理失败：显示具体错误信息
- 成功处理：显示处理的标题数量

### 6. 文件结构

```
markdown-index/
├── README.md
├── todolist.md
├── architecture.md
├── markdown-index.sh          # 主脚本文件
├── test/
│   ├── test-cases.md          # 测试用例
│   └── test-runner.sh         # 测试脚本
└── docs/
    ├── installation.md        # 安装说明
    └── usage.md              # 使用说明
```

### 7. 实现优先级

1. **Phase 1**: 基础功能实现
   - 剪贴板操作
   - 基本标题识别
   - 简单序号生成

2. **Phase 2**: 增强功能
   - 代码块保护
   - 多级标题处理
   - 错误处理完善

3. **Phase 3**: 优化和测试
   - 边缘情况处理
   - 性能优化
   - 全面测试

### 8. 技术细节

#### 8.1 剪贴板操作
```bash
# 读取剪贴板
content=$(pbpaste)

# 写入剪贴板
echo "$processed_content" | pbcopy
```

#### 8.2 字符串处理
```bash
# 使用sed进行文本替换
# 使用awk进行复杂文本处理
# 使用grep进行模式匹配
```

#### 8.3 状态管理
```bash
# 使用关联数组管理计数器
declare -A counters
# 使用布尔变量管理状态
in_code_block=false
```

## 下一步行动

1. 实现基础的markdown-index.sh脚本
2. 创建测试用例
3. 逐步完善功能
4. 集成到Raycast
5. 编写文档