## --help
用法：`comman --help`
快速查询指令的选项

---
## man page(男人页)
用法：`man comman`
查询`comman`的具体用法

man page 左上角指令名称后代号解析：
| 代号 | 代表内容 |
|-|-|
|*1|用户在 shell 环境中可以操作的指令或可执行文件|
|2|系统核心可呼叫的函数与工具等|
|3|一些常用的函数(function)与函式库(library)，大部分为 C 的函式库(libc)|
|4|装置文件的说明，通常在/dev 下的文件|
|*5|配置文件或者是某些文件的格式|
|6|游戏(games)|
|7|惯例与协议等，例如 Linux 文件系统、网络协议、ASCII code 等等的说明|
|*8|系统管理员可用的管理指令|
|9|跟 kernel 有关的文件|

man page 组成部分：
|代号|内容说明|
|-|-|
|NAME|简短的指令、数据名称说明|
|SYNOPSIS|简短的指令下达语法(syntax)简介|
|DESCRIPTION|较为完整的说明，最好细看|
|OPTIONS|针对SYNOPSIS部分中，有列举的所有可用的选项说明|
|COMMANDS|当这个程序(软件)执行的时候，可以在此程序(软件)中下达的指令|
|FILES|这个程序或数据所使用或参考或链接到的某些文件|
|SEE ALSO|可以参考的，跟这个指令或数据有关的其他说明|
|EXAMPLE|一些可以参考的范例|
* PS:可能还会有 Authors 或 Copyright

man page 常用按键：
|按键|进行工作|
|-|-|
|<kbd>空格键</kbd>|向下翻一页|
|<kbd>Page Down</kbd>|向下翻一页|
|<kbd>Page Up</kbd>|向上翻一页|
|<kbd>Home</kbd>|去到第一页|
|<kbd>End</kbd>|去到最后一页|
|`/string`|向[下]搜寻 string 这个字符串|
|`?string`|向[上]搜寻 string 这个字符串|
|<kbd>n,N</kbd>|利用 / 或 ? 来搜寻字符串时，可以用 n 来继续下一个搜寻 (不论是 / 或 ?) ，可以利用 N 来进行[反向]搜寻。举例来说，我以 /vbird 搜寻 vbird 字符串， 那么可以 n 继续往下查询，用 N 往上查询。若以 ?vbird 向上查询 vbird 字符串， 那我可以用 n 继续[向上]查询，用 N 反向查询。|
|<kbd>q</kbd>|退出 man page |

man page 搜索特定指令:
`man -f comman`  == `whatis comman`

与 man page 相关的文件：
`/usr/share/man`
`/etc/man_db.config`

