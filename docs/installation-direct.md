# 直接替换版本安装指南

本指南将帮助您在 Raycast 中安装和配置 `markdown-index-direct.sh` 脚本，实现直接替换选中内容的 Markdown 标题序号功能。

## 前置要求

### 系统要求

- **操作系统**：macOS 10.15 或更高版本
- **Raycast**：已安装 Raycast 应用
- **系统权限**：需要授予辅助功能和自动化权限

### 权限说明

直接替换版本需要额外的系统权限：

- **辅助功能权限**：用于读取选中内容和执行文本替换
- **自动化权限**：用于模拟键盘操作（Cmd+C 和 Cmd+V）

## 安装步骤

### 1. 下载脚本

```bash
# 克隆项目（如果还没有）
git clone https://github.com/your-username/markdown-index.git
cd markdown-index

# 或者直接下载脚本文件
curl -O https://raw.githubusercontent.com/your-username/markdown-index/main/markdown-index-direct.sh
```

### 2. 设置脚本权限

```bash
# 给脚本添加执行权限
chmod +x markdown-index-direct.sh
```

### 3. 在 Raycast 中添加脚本

1. **打开 Raycast 设置**
   - 启动 Raycast（⌘ + Space）
   - 输入 "Settings" 并回车
   - 或者使用快捷键 ⌘ + ,

2. **添加脚本目录**
   - 点击左侧的 "Extensions"
   - 点击右上角的 "+" 按钮
   - 选择 "Add Script Directory"
   - 选择包含 `markdown-index-direct.sh` 的目录

3. **配置脚本**
   - 在扩展列表中找到 "Markdown Index Direct"
   - 点击脚本名称进入设置
   - 设置快捷键（建议：⌘ + ⌥ + M）

### 4. 配置系统权限

#### 辅助功能权限

1. **打开系统偏好设置**
   - 点击苹果菜单 → 系统偏好设置
   - 选择 "安全性与隐私"

2. **配置辅助功能**
   - 点击 "隐私" 标签
   - 在左侧列表中选择 "辅助功能"
   - 点击锁图标并输入密码
   - 点击 "+" 添加 Raycast 应用
   - 确保 Raycast 旁边的复选框已勾选

#### 自动化权限

1. **在隐私设置中**
   - 选择 "自动化"
   - 找到 Raycast 条目
   - 展开并确保相关权限已启用

2. **首次运行时**
   - 系统会弹出权限请求对话框
   - 点击 "允许" 授予权限

## 验证安装

### 基本功能测试

1. **准备测试内容**
   - 在任何文本编辑器中输入以下内容：
   ```markdown
   # 测试标题
   ## 子标题
   ### 小节标题
   ```

2. **执行测试**
   - 选中上述 Markdown 内容
   - 使用配置的快捷键触发脚本
   - 验证内容是否自动替换为：
   ```markdown
   # 1. 测试标题
   ## 1.1. 子标题
   ### 1.1.1. 小节标题
   ```

### 权限验证

如果脚本无法正常工作，请检查：

1. **辅助功能权限**
   - 系统偏好设置 → 安全性与隐私 → 隐私 → 辅助功能
   - 确认 Raycast 已添加并启用

2. **自动化权限**
   - 系统偏好设置 → 安全性与隐私 → 隐私 → 自动化
   - 确认 Raycast 的相关权限已启用

## 故障排除

### 常见问题

#### 1. 脚本无响应

**可能原因**：
- 缺少系统权限
- 没有选中内容
- 选中内容不包含 Markdown 标题

**解决方案**：
- 检查并配置系统权限
- 确保选中了包含 # 标题的文本
- 在终端中手动测试脚本

#### 2. 权限被拒绝

**错误信息**："Operation not permitted" 或类似权限错误

**解决方案**：
```bash
# 重新配置权限
# 1. 在系统偏好设置中移除 Raycast
# 2. 重新添加 Raycast
# 3. 重启 Raycast 应用
```

#### 3. 内容替换失败

**可能原因**：
- 应用不支持程序化文本替换
- 选中内容格式不正确
- 系统剪贴板被其他程序占用

**解决方案**：
- 在不同的文本编辑器中测试
- 检查 Markdown 格式是否正确
- 重启相关应用程序

#### 4. 脚本找不到

**错误信息**："Command not found" 或脚本路径错误

**解决方案**：
```bash
# 检查脚本路径和权限
ls -la markdown-index-direct.sh

# 确保脚本有执行权限
chmod +x markdown-index-direct.sh

# 检查脚本语法
bash -n markdown-index-direct.sh
```

### 调试方法

#### 1. 终端测试

```bash
# 在终端中直接运行脚本
./markdown-index-direct.sh

# 检查脚本输出和错误信息
./markdown-index-direct.sh 2>&1
```

#### 2. 权限检查

```bash
# 检查当前用户权限
whoami

# 检查文件权限
ls -la markdown-index-direct.sh
```

#### 3. 系统日志

```bash
# 查看系统日志中的相关错误
log show --predicate 'process == "Raycast"' --last 1h
```

## 卸载

### 从 Raycast 中移除

1. **打开 Raycast 设置**
   - 启动 Raycast
   - 进入 Settings → Extensions

2. **移除脚本**
   - 找到 "Markdown Index Direct"
   - 点击右侧的设置图标
   - 选择 "Remove from Raycast"

### 清理文件

```bash
# 删除脚本文件
rm markdown-index-direct.sh

# 删除整个项目目录（如果不再需要）
rm -rf markdown-index/
```

### 撤销系统权限

1. **移除辅助功能权限**
   - 系统偏好设置 → 安全性与隐私 → 隐私 → 辅助功能
   - 选择 Raycast 并点击 "-" 移除

2. **重置自动化权限**
   - 系统偏好设置 → 安全性与隐私 → 隐私 → 自动化
   - 取消勾选 Raycast 的相关权限

## 更新

### 更新脚本

```bash
# 如果使用 Git
cd markdown-index
git pull origin main

# 或者重新下载
curl -O https://raw.githubusercontent.com/your-username/markdown-index/main/markdown-index-direct.sh
chmod +x markdown-index-direct.sh
```

### 更新后验证

- 重新运行验证测试
- 检查新功能是否正常工作
- 确认权限设置仍然有效

## 自定义配置

### 修改快捷键

1. **在 Raycast 中**
   - Settings → Extensions
   - 找到 "Markdown Index Direct"
   - 点击当前快捷键进行修改

### 修改脚本行为

可以编辑脚本文件来自定义行为：

```bash
# 编辑脚本
nano markdown-index-direct.sh

# 常见自定义选项：
# - 修改序号格式
# - 调整标题级别支持
# - 更改错误处理方式
```

## 注意事项

### 安全考虑

- **权限最小化**：只授予必要的系统权限
- **来源验证**：确保脚本来源可信
- **定期检查**：定期检查权限使用情况

### 性能影响

- **内存使用**：脚本运行时会短暂占用系统资源
- **响应时间**：大文档处理可能需要几秒钟
- **系统负载**：频繁使用不会对系统造成明显影响

### 兼容性

- **应用支持**：并非所有应用都支持程序化文本替换
- **格式限制**：只处理纯文本格式的 Markdown 内容
- **系统版本**：需要 macOS 10.15 或更高版本

## 总结

直接替换版本通过自动化文本操作提供了更便捷的用户体验，但需要额外的系统权限配置。正确配置权限后，它能够显著提高 Markdown 文档编辑的效率。

如果在安装过程中遇到问题，请参考故障排除部分或考虑使用复制粘贴版本作为替代方案。