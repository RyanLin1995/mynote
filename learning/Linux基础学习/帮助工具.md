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

搜索特定指令的man page 文件:
通过关键字为指令名查找 `man -f string`  == `whatis string`
通过关键字为说明查找`man -k string` == `apropos string`
要使用这两个命令，需要先在root底下`mandb`建立数据库才行

与 man page 相关的文件夹：
`/usr/share/man`
`/etc/man_db.config`
`/usr/local/man`

---
## info page
用法：`info comman`
Linux 特有的在线求助方式。将文件数据拆成一个一个的段落，每个段落用自己的页面来撰写，并且在各个页面中还有类似网页的『超链接』来跳到各不同的页面中，每个独立的页面也被称为一个节点(node)

info page 常用按键
|按键|进行工作|
|-|-|
|<kbd>空格键</kbd>|向下翻一页|
|<kbd>Page Down</kbd>|向下翻一页|
|<kbd>Page Up</kbd>|向上翻一页|
|<kbd>tab</kbd>|在 node 之间移动，有 node 的地方，通常会以 * 显示|
|<kbd>Enter</kbd>|当光标在 node 上面时，按下 Enter 可以进入该 node|
|<kbd>b</kbd>|移动光标到该 info 画面当中的第一行|
|<kbd>e</kbd>|移动光标到该 info 画面当中的最后一行|
|<kbd>n</kbd>|前往下一个 node 处|
|<kbd>p</kbd>|前往上一个 node 处|
|<kbd>u</kbd>|向上移动一层|
|<kbd>s,/</kbd>|在 info page 当中进行搜寻|
|<kbd>H</kbd>|显示求助选单|
|<kbd>q</kbd>|退出info page|

与info page 相关的文件夹：
`/usr/share/info`

---
## 其他有用文件：
`/usr/share/doc`:
放置了软件的说明文档

---
## 总结
* 在终端机模式中，如果你知道某个指令，但却忘记了相关选项与参数，请先善用 --help 的功能来查询相关信息
* 当有任何你不知道的指令或文件格式这种玩意儿，但是你想要了解他，请赶快使用 man 或者是 info 来查询
* 而如果你想要架设一些其他的服务，或想要利用一整组软件来达成某项功能时，请赶快到 /usr/share/doc 底下查一查有没有该服务的说明档喔
