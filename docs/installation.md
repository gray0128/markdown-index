# 安装说明

## 前置要求

- macOS 系统
- 已安装 [Raycast](https://www.raycast.com/)
- 基本的终端操作知识

## 安装步骤

### 1. 下载脚本

将 `markdown-index.sh` 脚本下载到本地目录，建议放在以下位置之一：

```bash
# 选项1：用户脚本目录
~/Scripts/markdown-index.sh

# 选项2：Raycast脚本目录
~/.config/raycast/scripts/markdown-index.sh

# 选项3：项目目录
~/Documents/github/markdown-index/markdown-index.sh
```

### 2. 设置执行权限

```bash
chmod +x /path/to/markdown-index.sh
```

### 3. 在Raycast中添加脚本

#### 方法1：通过Raycast设置

1. 打开 Raycast
2. 搜索并打开 "Script Commands"
3. 点击右上角的 "+" 按钮
4. 选择 "Add Script Directory"
5. 选择包含 `markdown-index.sh` 的目录

#### 方法2：通过文件系统

1. 将脚本复制到 Raycast 的脚本目录：
   ```bash
   cp markdown-index.sh ~/.config/raycast/scripts/
   ```

2. 重启 Raycast 或刷新脚本列表

### 4. 验证安装

1. 在任意文本编辑器中创建一个包含markdown标题的测试文件：
   ```markdown
   # 第一章
   ## 第一节
   ### 第一小节
   ```

2. 选中这些文本并复制（Cmd+C）

3. 打开 Raycast（Cmd+Space）

4. 搜索 "Add Markdown Index" 并执行（脚本会静默处理，不显示界面）

5. 回到原文本编辑器，粘贴结果（Cmd+V），应该看到：
   ```markdown
   # 1. 第一章
   ## 1.1. 第一节
   ### 1.1.1. 第一小节
   ```

**注意**：脚本使用 silent 模式，执行时不会显示任何界面或反馈信息，处理完成后可以直接粘贴结果。

## 故障排除

### 脚本未出现在Raycast中

1. 检查脚本是否有执行权限：
   ```bash
   ls -la /path/to/markdown-index.sh
   ```
   应该显示类似 `-rwxr-xr-x` 的权限

2. 检查脚本的Raycast元数据是否正确

3. 重启Raycast应用

### 脚本执行失败

1. 在终端中直接运行脚本测试：
   ```bash
   echo "# 测试标题" | pbcopy
   /path/to/markdown-index.sh
   pbpaste
   ```

2. 检查错误信息并参考使用说明

### 权限问题

如果遇到权限问题，确保：

1. 脚本文件有执行权限
2. Raycast有访问脚本目录的权限
3. 系统允许运行未签名的脚本

## 卸载

要卸载脚本：

1. 从Raycast脚本目录中删除文件：
   ```bash
   rm ~/.config/raycast/scripts/markdown-index.sh
   ```

2. 或者在Raycast的Script Commands设置中移除脚本目录

3. 重启Raycast

## 更新

要更新脚本：

1. 下载新版本的脚本文件
2. 替换旧文件
3. 确保执行权限正确
4. 重启Raycast（如果需要）

## 自定义配置

### 修改快捷键

在Raycast中可以为脚本设置自定义快捷键：

1. 打开Raycast设置
2. 找到 "Add Markdown Index" 脚本
3. 点击右侧的快捷键设置
4. 设置你喜欢的快捷键组合

### 修改脚本参数

可以编辑脚本文件顶部的Raycast元数据来自定义：

- `@raycast.title` - 脚本显示名称
- `@raycast.icon` - 脚本图标
- `@raycast.description` - 脚本描述
- `@raycast.packageName` - 包名