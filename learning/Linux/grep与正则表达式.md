## 按行截取信息：grep
用法：`grep [-acinv] [--color=auto] '搜索字符串' 文件名`

|选项与参数|说明|
|-a|将二进制(binary)文件以 text 文件的方式进行搜寻数据|
|-c|仅显示搜寻结果的行号|
|-i|忽略大小写|
|-n|显示行号|
|-v|反向选择，即只显示与关键字无关的内容|
|--color=auto|自动高亮找到的关键字|

例子：
1. 找到 last 中的非 reboot 用户：`last | grep -v reboot`
2. 找到 /etc/passwd 中的 nologin 用户：`grep nologin /etc/passwd`

## 正则表达式(Regular Expression)

