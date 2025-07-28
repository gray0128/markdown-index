-- Markdown 标题自动编号脚本
-- 功能：为选中的 Markdown 文本标题添加层级编号

tell application "System Events"
    set frontApp to name of first application process whose frontmost is true
end tell

tell application frontApp
    -- 获取当前选中的文本
    set selectedText to ""
    try
        set selectedText to the clipboard
        -- 保存原始剪贴板内容以便恢复
        set originalClipboard to the clipboard
        -- 复制选中内容到剪贴板
        keystroke "c" using command down
        delay 0.1 -- 等待复制完成
        set selectedText to the clipboard
    on error
        display dialog "无法获取选中内容，请确保已选择文本" buttons {"确定"} default button 1
        return
    end try

    -- 如果没有选中内容则提示
    if selectedText is "" then
        display dialog "未选中任何文本" buttons {"确定"} default button 1
        set the clipboard to originalClipboard
        return
    end if

    -- 处理文本并添加编号
    set numberedText to addMarkdownIndex(selectedText)

    -- 将处理后的文本粘贴回原处
    set the clipboard to numberedText
    delay 0.1 -- 等待剪贴板更新
    keystroke "v" using command down
    delay 0.1
    -- 恢复原始剪贴板内容
    set the clipboard to originalClipboard
end tell

-- 核心处理函数：为 Markdown 标题添加编号
on addMarkdownIndex(contentText)
    set lineSeparator to linefeed
    set lines to paragraphs of contentText
    set indexBase to "##" -- 标题标记，可根据需要修改
    set isInCodeBlock to false
    set levelCounts to {} -- 存储各级标题的计数
    set newLines to {}

    repeat with lineText in lines
        set currentLine to lineText as string
        
        -- 检测代码块（```标记）
        if currentLine starts with "```" then
            set isInCodeBlock to not isInCodeBlock
            copy currentLine to end of newLines
            continue repeat
        end if
        
        -- 代码块内的内容不处理
        if isInCodeBlock then
            copy currentLine to end of newLines
            continue repeat
        end if
        
        -- 检查是否是标题行
        set trimmedLine to (do shell script "echo " & quoted form of currentLine & " | xargs")
        if trimmedLine starts with indexBase then
            -- 计算标题级别
            set level to 0
            set currentChar to ""
            repeat while level < length of trimmedLine
                set level to level + 1
                set currentChar to character level of trimmedLine
                if currentChar is not equal to indexBase then
                    set level to level - 1
                    exit repeat
                end if
            end repeat
            
            -- 调整计数数组
            if level > length of levelCounts then
                -- 新增级别
                repeat (level - length of levelCounts) times
                    set end of levelCounts to 0
                end repeat
            else if level < length of levelCounts then
                -- 降低级别，截断计数数组
                set levelCounts to items 1 through level of levelCounts
            end if
            
            -- 更新当前级别计数
            set item level of levelCounts to (item level of levelCounts) + 1
            
            -- 生成编号前缀
            set prefix to ""
            repeat with i from 1 to level
                set prefix to prefix & (item i of levelCounts as string) & "."
            end repeat
            
            -- 移除可能存在的旧编号
            set cleanedLine to currentLine
            set regexPattern to "^(\\s*" & indexBase & "+)\\s*(\\d+\\.)*\\s*"
            set cleanedLine to do shell script "echo " & quoted form of cleanedLine & " | sed -E 's/" & regexPattern & "/\\1 /'"
            
            -- 添加新编号
            set newLine to (characters 1 through (level + (offset of indexBase in cleanedLine) - 1) of cleanedLine as string) & prefix & " " & (text (level + (offset of indexBase in cleanedLine) of cleanedLine as string))
            
            -- 处理可能的空格问题
            set newLine to do shell script "echo " & quoted form of newLine & " | sed -E 's/  +/ /g'"
            copy newLine to end of newLines
        else
            -- 非标题行直接保留
            copy currentLine to end of newLines
        end if
    end repeat
    
    -- 拼接处理后的行
    set AppleScript's text item delimiters to lineSeparator
    set resultText to newLines as string
    set AppleScript's text item delimiters to ""
    return resultText
end addMarkdownIndex

display dialog "标题编号已完成" buttons {"确定"} default button 1