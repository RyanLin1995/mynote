## 什么是 Shell
管理整个计算机硬件的其实是操作系统的核心(kernel)，但是核心是需要被保护的，因此我们一般透过 shell 来跟核心沟通，即透过 Shell 将我们输入的指令与 Kernel 沟通，好让 Kernel 可以控制硬件。

Shell 是可以与操作系统核心沟通的一个应用程序，即壳程序。壳程序其实是操作系统提供给用户的一个接口，可以让用户通过这个壳程序把指令传给操作系统核心或其他应用程序

狭义的 Shell 指的是指令列程序，如 Powershell，bash
广义的 Shell 指的是指令列程序，图形接口等可以调用系统核心与其他软件的应用程序

在 Linux 中，可以透过 `cat /etc/shells` 查看支持的 Shell

---
## Bash
### 什么是 Bash
Bash(Bourne Again SHell): 即 /bin/bash, Linux 预设的 Shell， 兼容 sh(Bourne SHell)。
主要优点有:
1. 命令编修能力(history)：可以通过上下键查询历史指令，最多保存一千条，保存位置为~/.bash_history
2. 命令与文件补全功能([tab])：可以通过 [tab] 自动补全
3. 命令别名设定功能(alias)：可以通过 `alias` 查询所有的别名，也可以通过 `alias '别名'='命令'`设置新的别名
4. 工作控制、前景背景控制(job control, foreground, background)：前、背景的控制
5. 程序化脚本(shell scripts)：可以编写 Shell scrips
6. 通配符(Wildcard)：即 *
7. 快速编辑：让光标移动到整个指令串的最前面 ([ctrl]+a) 或最后面 ([ctrl]+e)；从光标处向前删除指令串 ([ctrl]+u) 及向后删除指令串 ([ctrl]+k)
8. 转义字符：\

### Bash 常用组合键
|组合键|作用|
|-|-|
|<kbd>ctrl</kbd> + <kbd>c</kbd>|终止目前程序|
|<kbd>ctrl</kbd> + <kbd>d</kbd>|结束输入(End of file)|
|<kbd>ctrl</kbd> + <kbd>m</kbd>|等同于 Enter|
|<kbd>ctrl</kbd> + <kbd>s</kbd>|暂停屏幕输出(冻结程序)|
|<kbd>ctrl</kbd> + <kbd>q</kbd>|恢复屏幕输出(恢复程序)|
|<kbd>ctrl</kbd> + <kbd>u</kbd>|删除整行|
|<kbd>ctrl</kbd> + <kbd>z</kbd>|暂停目前程序|

### 查看指令为 Bash 内建指令还是外部指令: type
用法: `type -tpa name`

|选项与参数|说明|
|-|-|
||不加任何选项与参数时，type 会显示出 name 是外部指令还是 bash 内建指令|
|-t|当加入 -t 参数时，type 会将 name 以这些字眼显示出他的意义: file(表示为外部指令)，alias(表示该指令为命令别名所设定的名称)，builtin(表示该指令为 bash 内建的指令功能)|
|-p|如果后面接的 name 为外部指令时，才会显示完整文件名|
|-a|会由 PATH 变量定义的路径中，将所有含 name 的指令都列出来，包含 alias|

### 父程序与子程序
在登录到 Linux 并且获得 bash 后，该 bash 会作为一个独立的程序，并获得 PID。那么在这个程序下下达的任何指令，都是由这个程序衍生出来的，所下达的指令就被称为子程序

图解:
![ppid.gif](https://i.loli.net/2020/11/29/LZJlN6zAmdsG4QB.gif)

如图所示，在原有的 bash 中执行了另一个 bash，那么新的 bash 即为原本 bash 的子程序。新输入的所有制令都会在这个新的 bash 中运行，只有退出(exit)这个 bash，才能回到父程序的 bash 中

PS:
子程序仅会继承父程序的环境变量，不会继承父程序的自定义变量，如果需要继承父程序的变量，可以使用`export` 命令

**父进程与子进程怎么共享变量**
父进程与子进程变量共享关系到内存
* 当启动一个 shell，操作系统会分配一内存区块给 shell 使用，此内存内之变量可让子程序取用
* 若在父程序利用 export 功能，可以让自定义变量的内容写到上述的内存区块当中(环境变量)；
* 当加载另一个 shell 时 (亦即启动子程序，而离开原本的父程序了)，子 shell 可以将父 shell 的环境变量所在的内存区块导入自己的内存区块当中。

### Bash 中限制文件系统和程序: ulimit
在 bash 中可以使用 `ulimit` 对使用者进行资源限制
用法: `ulimit [-SHacdfltu] [配额]`

|选项与参数|说明|
|-|-|
|-H|hard limit，严格限制，即不可以超过该限制|
|-S|soft limit，警告限制，即可以超过这个限制，但超过这个限制会出现警告|
|-a|列出所有限制额度|
|-c|限制每个核心文件^1^的最大容量|
|-f|这个 shell 可以建立的最大文件容量，单位为Kbytes|
|-d|程序可以使用的最大断裂内存(segment)容量|
|-l|可用于锁定的内存量|
|-t|可使用的最大CPU时间，单位为秒|
|-u|单一用户可以使用的最大程序数量|

1. 当某些程序发生错误时，系统可能会将该程序在内存中的信息写成文件(除错用)，这种文件就被称为核心文件(core file)。

例子:
![图像 8.png](https://i.loli.net/2020/12/12/7SBkcAeXCHoK43U.png)

### 别名命令: alias
可以通过 alias 命令重命名命令
命名: `alias 新命令名="命令"`
单纯显示目前已存在别名: `alias`
取消命名: `unalias 新命令名`

例子:
![图像 1.png](https://i.loli.net/2020/12/13/BmZ7e4TrfLHcs6P.png)

### 历史命令: history
#### 可以通过 history 命令翻查之前输入过的命令
用法: `history [n]`
用法: `history [-c]`
用法: `histroy [-arw] histfiles`

|选项与参数|说明|
|-|-|
|n|数字，代表要列出多少行最近执行的命令|
|-c|将 shell 中的所有 history 内容清空|
|-a|将目前新增的 history 命令添加到 histfiles 中，若没有加 histfiles ，预设写入 ~/.bash_history|
|-r|将 histfiles 的内容读到目前这个 shell 的 history 中|
|-w|将目前的 history 内容写入 histfiles 中|

#### 特殊的历史命令使用方法: !
用法: `!number` 或 `!command`
用法: `!!`

|选项与参数|说明|
|-|-|
|number|代表第几个命令。`!number` 指的是通过 `history` 查出相应的历史命令号码，再通过 `!历史命令号码` 执行命令|
|command|由最近的命令向前搜寻命令开头为 command 的命令，并执行|
|!!|就是执行上一个指令(相当于按<kbd>↑</kbd>后，按 <kbd>Enter</kbd>)|

#### history 读取与记录过程:
* 当以 bash 登入 Linux 主机之后，系统会主动的由家目录的 ~/.bash_history 读取以前曾经执行过的命令，保存的上限与 bash 的 HISTFILESIZE 变量设定值有关
* 历史命令在注销时，会将最近的 HISTFILESIZE 笔记录到~/.bash_history中。例如本次登入主机后，共下达了 100 次命令，等注销时，系统就会将 101~1100 这总共 1000 笔历史命令 更新到
 ~/.bash_history 当中。
* 也可以用 history -w 强制立刻写入到 ~/.bash_history。写入时如果超过 HISTFILESIZE 限制，那么旧的记录会被删除，仅保留最新的

#### history 记录时间
* 想在 history 里显示时间，可以通过修改 HISTTIMEFORMAT 这个history 会读取的环境变量，给 history 增加时间戳。

* 通过给目前的 bash 设置环境变量 HISTTIMEFORMAT 以显示时间戳:
  1. 临时生效: export HISTTIMEFORMAT="%F %T \`whoami\` "
  2. 当前用户永久生效: 在 `~/.bash_profile` 最后一行添加 export HISTTIMEFORMAT="%F %T \`whoami\` " 然后 `source ~/.bash_profile`
  3. 全局用户永久生效: 在 `/etc/profile` 最后一行添加 export HISTTIMEFORMAT="%F %T \`whoami\` " 然后 `source /etc/profile`

### 命令搜寻顺序
一般情况下可以通过 `type -a 命令` 来显示一个命令的搜寻顺序

命令搜寻顺序如下:
1. 以相对/绝对路径执行命令，例如 `/bin/ls` 或 `./ls` ；
2. 由 alias 找到该命令来执行；
3. 由 bash 内建的(builtin)命令来执行；
4. 透过 $PATH 这个变量的顺序搜寻到的第一个命令来执行。

### Bash 进站与欢迎信息
想修改 tty1-tty7 的登录欢迎信息，可以修改 /etc/issue 文件

|issue代码|意义|
|-|-|
|\d|本地端日期|
|\l|终端机接口|
|\m|硬件的等级(i386/i486/i586/i686...)|
|\n|主机网络名称|
|\O|Domain name|
|\r|操作系统的发行版本(相当于uname -r)|
|\t|本地端时间|
|\S|操作系统的名称|
|\v|操作系统的版本|

PS:
Bash 还可以设置登陆显示信息，即使用者登录后会显示(例如告警系统维护时间)，可以修改 /etc/motd

例子:
1. 修改登陆欢迎信息为如下:
![1.png](https://i.loli.net/2020/12/19/sJVBbW6lq1hc3nx.png)
具体命令: 修改 /etc/issue 文件为下图:
![2.png](https://i.loli.net/2020/12/19/MPzgmFivsEUbheI.png)

2. 在登录时显示 Hello? 提示字符
具体命令: 在 /etc/motd 文件增加 Hello? 字符

---
## Bash 环境配置文件
要想设置自己的 Bash，例如创建别名命令，自定义变量等，光在 Bash 中输出后，在注销 Bash 就消失。想要永久生效，需要将其写入 Bash 的环境变量配置文件中。

Linux 中的 shell 分为 login shell 与 non-login shell
* login shell: 取得 bash 时需要完整的登入流程的，就称为 login shell。如用账号与密码登陆 tty1 ~ tty7 取得的 bash 就称为 login shell。login shell 会读取 /etc/profile(系统整体设定) 与 ~/.bash_profile 或 ~/.bash_login 或 ~/.profile(使用者设定) 来规划 bash 的环境

* non-login shell: 只取得 bash 接口的方法而不需要重复登入的。如在原本的 bash 环境下再次下达 bash 命令，所得到的 bash (子程序) 就是 non-login shell。non-login shell 仅读取 ~/.bashrc

**图解 login shell:**
![centos7_bashrc_1.gif](https://linux.vbird.org/linux_basic/centos7/0320bash/centos7_bashrc_1.gif)

实线的的方向是主线流程，虚线的方向则是被呼叫的配置文件

### login shell 会读取的配置文件
#### 1. 系统整体设置 /etc/profile
包括以下变量:
* PATH: 会依据 UID 决定 PATH 变量要不要含有 sbin 的系统指令目录
* MAIL: 依据账号设定好使用者的 mailbox 到 /var/spool/mail/账号名
* USER: 根据用户的账号设定此变量内容
* HOSTNAME: 依据主机的 hostname 命令决定此变量内容
* HISTSIZE: 历史命令记录笔数，默认设定为 1000 
* umask: 包括 root 默认为 022 而一般用户为 002 等

**同时 /etc/profile 还会读入以下外部程序:**
##### /etc/profile.d/*.sh
只要在 /etc/profile.d/ 这个目录内，扩展名为 .sh 且使用者能够具有 r 权限的，那么该文件就会被 /etc/profile 呼叫进来。目录底下的文件规范了 bash 操作接口的颜色、语系、ll 与 ls 指令的命令别名、vi 的命令别名、which的命令别名等等。如果需要帮所有使用者设定一些共享的命令别名时，可以在这个目录底下自行建立扩展名为 .sh 的文件，并将所需要的数据写入

##### /etc/locale.conf
由 /etc/profile.d/lang.sh 呼叫进来的,也是决定 bash 预设使用何种语系的重要配置文件

##### /usr/share/bash-completion/completions/*
由/etc/profile.d/bash_completion.sh 这个载入，关系到<kbd>tab</kbd>的自动补全功能

#### 2. 个人配置文件
个人配置文件按 bash 读取顺序分有:
1. ~/.bash_profile
2. ~/.bash_login
3. ~/.profile

Bash 的 login shell 只要读取到其中一个文件，就不会再读取其他文件。如果想修改个人的 Bash login shell，可以修改以上三个文件之一

### non-login shell 会读取的配置文件:  ~/.bashrc

non-login shell 这种非登入情况取得 bash 操作接口的环境配置文件是 ~/.bashrc 。在 ~/.bashrc 中还会调用  /etc/bashrc 帮 bash 定义出以下数据:

* 依据不同的 UID 规范出 umask 的值；
* 依据不同的 UID 规范出提示字符 (就是 PS1 变量)；
* 呼叫 /etc/profile.d/*.sh 的设定

PS:
1. /etc/bash 为 Red Hat 系统独有文件
2. 万一删除了 ~/.bashrc ，可以复制 /etc/skel/.bashrc 到家目录进行重新设置

### 其他相关配置文件
#### /etc/man_db.conf
该文件的规范了使用 man 命令时，man page 的路径。一般用户 tarball 安装软件时，把存放于 /usr/local/软件名称/man 的man page 手动添加到 /etc/man_db.conf 里

#### ~/.bash_history
历史命令的保存位置，上限与 HISTFILESIZE 有关。每次登入 bash 后，bash 会自动把所有历史命令加载到内存中

#### ~/.bash_logout
该文件记录了注销 bash 后，系统再帮我做完什么动作后才离开

### 读入配置文件: source(.)
一般情况下，修改了配置文件(系统的或个人的)都需要注销再登录才能生效。也可以通过`source`命令直接读取

用法: `source 配置文件名` 或 `. 配置文件名`

---
## 终端机环境设置
影响 tty1~tty7 环境设置的命令有 stty 跟 set，其中 stty 影响按键设置(如 <kbd>ctrl</kbd> + <kbd>c</kbd> 终止程序)；set 影响 终端机的设定值。一般情况下，Linux Distributions 已经设置好所有的环境，不建议再进行修改

### 查看/修改终端按键: stty
查看用法: `stty -a`
修改用法: `stty 内容 按键`

stty图示:
![图像 1.png](https://i.loli.net/2020/12/20/73YvE2qd4LFZs6x.png)

|字符|功能|
|-|-|
|intr|中断(interrupt)目前正在 run 的程序|
|quit|退出(quit)目前正在 run 的程序|
|erase|删除字符|
|kill|删除目前列上所有的文字|
|eof|End of file，输入结束|
|start|程序停止/冻结后重启启动/解冻|
|stop|停止程序(暂停屏幕输出)|
|susp|发送 terminal stop 的讯号给正在 run 的程序|

PS:
1. 图中的 ^ 表示 <kbd>ctrl</kbd>
2. 图中字母为大写，实际操作时不需要大写
3. ^? 表示退格键(backspace)
4. 修改按键例子: `stty quit ^A` (从<kbd>ctrl</kbd> + <kbd>c</kbd> 退出变为 <kbd>ctrl</kbd> + <kbd>a</kbd>退出) 

### 设置终端机设定值: set
set 命令除了可以显示变量设置外，还可以设定终端的输入/输出环境
用法: `set [-uvCHhmBx]`

|选项与参数|说明|
|-|-|
|u|默认不启用。若启用后，当使用未设定变量时，会显示错误信息|
|v|默认不启用。若启用后，在信息被输出前，会先显示信息的原始内容|
|x|默认不启用。若启用后，在命令被执行前，会显示命令内容(前面有 ++ 符号)|
|C|预设不启用。若使用 > 等，则若文件存在时，该文件不会被覆盖|
|h|默认启用。与历史命令有关|
|H|默认启用。与历史命令有关|
|m|默认启用。与工作管理有关|
|B|默认启用。与刮号 [] 的作用有关([] 代表中间有个指定的字符)|

例子:
1. 输出目前 set 设定值: `echo $-`

2. 设置/取消使用未定义变量时，则显示错误讯息: `set -/+u`

---
## Bash 中的通配符(wildcard)与特殊符号
**!!! Bash 中的通配符跟正则表达式是没有关系的**
|符号|意义|
|-|-|
|*|代表0到无穷个字符|
|?|代表至少有一个字符|
|[]|代表[]内的字符至少有一个，如[123]可能是1,2,3其中一个|
|[-]|代表编码顺序内的所有字符，如[1-9]，[a-z]|
|[^]|反向选择，如[^a]*，代表选择不以a开头的|

例子:
1. 找出 /etc 下所有 cron 开头的文档: `ll -d /etc/cron*`

2. 找出 /etc 下文件名字符长度刚好为6的文件: `ll -d /etc/??????`

3. 找出 /etc 下文件名还有数字的文件: `ll -d /etc/*[0-9]*`

4. 找出 /etc 下文件名开头不是小写字母的文件: `ll -d /etc/[^a-z]*`

---
## Bash 中的其他特殊符号
|符号|意义|
|-|-|
|#|注释，常用于 script 当中，在后的数据均不被执行|
|\\|转义字符，将特殊字符或通配符还原成一般字符|
|\||管线符(pipe)，分隔两个管线命令的界定|
|;|长命令分隔符：连续性命令的界定|
|~|用户的家目录|
|$|取用变量前导符：亦即是变量之前需要加的变量取代值|
|&|工作控制(job control)：将指令变成背景下工作|
|!|逻辑运算意义上的非(not)的意思|
|/|目录符号：路径分隔的符号|
|>, >>|数据流重导向：取代输出与累加输出|
|<, <<|数据流重导向：输入导向|
|' '|单引号，不具有变量置换的功能($ 中的命令变为纯文本)|
|" "|具有变量置换的功能($ 中的命令保留相关功能)|
|\` \`|两个 ` 中间为可以先执行的指令，亦可使用 $( )|
|( )|在中间为子 shell 的起始与结束|
|{ }|在中间为命令区块的组合|

---
## Bash 命令执行的判断: ;，&&，||
|符号|说明|
|-|-|
|cmd;cmd|同时执行多个命令|
|cmd1 && cmd2|若 cmd1 执行完毕且正确执行($?=0)，则开始执行 cmd2|
|cmd1 \|\| cmd2|若 cmd1 执行完毕且为错误($?≠0)，则开始执行 cmd2|

例子:
1. 在关闭电脑前先同步数据: `sync;sync;shutdown -h now`
2. 不清楚 /tmp/abc 是否存在，但就是要建立 /tmp/abc/hehe 文件:
`ls /tmp/abs || mkdir /tmp/abc && touch /tmp/abc/hehe`

   上述案例中，无论 /tmp/abc 目录是否存在，都必然会创建 hehe 文件，因为：
   * Linux 的命令都是从左往右执行的
   * 若 /tmp/abc 不存在，$?≠0，则因为 || 遇到不为 0 的 $?，故开始执行 `mkdir /tmp/abc`，由于 `mkdir /tmp/abc` 会成功进行，所以回传 $?=0。因为 && 遇到 $?=0 故会执行 `touch /tmp/abc/hehe`， hehe 被建立
   * 若 /tmp/abc 存在，$?=0，则因为 || 遇到 0 的 $? 不会进行，此时 $?=0 继续向后传，因为 && 遇到 $?=0 就开始建立 `/tmp/abc/hehe`， 最终 /tmp/abc/hehe 被建立
   * 图解:
![cmd_1.gif](https://linux.vbird.org/linux_basic/centos7/0320bash//cmd_1.gif)

3. 以 ls 测试 /tmp/test 是否存在，若存在则显示 "exist" ，若不存在，则显示 "not exist"
`ls /tmp/test && echo "exist" || echo "not exist"`
   * 上述案例中，因为要进行多次判断，必须使用 `cmd1 && cmd2 || cmd3` 的格式，不能调换 && 跟 || 的位置，不然永远会执行 cmd2 跟 cmd3

---
## 管线命令(管道符): |
如果需要把前一个命令得到的结果再处理，可以使用管道符 | 。

用法：`com1 | com2 | com3`

* 管道符 | 仅能处理由前一个指令传来的 standard output，对于 standard output 没有处理能力。如果需要处理 standard output，需要用数据流输出重定向 2&>1 或 &>。
* 对于管道符 | 后一个命令，需要是可以接收 standard input 的数据的命令(less,more,tail等)

---
## 管道命令(即用于处理数据来自stdin的命令)
### 截取命令: cut
截取命令就是将一段数据经过分析后，取出所想要的。或者是经由分析关键词，取得所想要的那一行。一般截取命令是以行为单位
#### 分解一行数据: cut
有特定分隔符的用法: `cut -d '分隔符' -f 段数`
有整齐排列的用法: `cut -c 字符区间`

|选项与参数|说明|
|-d|接分隔符，一般与 -f 一起使用|
|-f|接段数，依据 -d 的分隔字符将一段信息分区成为数段，用 -f 取出第几段|
|-c|以字符串(characters)为单位取出固定字符区间|

PS:
1. 有整齐排列的数据中如果有多个相连的空格，`cut` 只能每个去处理，不能一次性去掉

例子:
1. 截取 PATH 第二个字段的信息
![图像 2.png](https://i.loli.net/2020/12/28/T7AgQKBuvnzxVrj.png)

2. 截取 export 的数据并只保留 declare -x 后的信息(declare -x总共11个字符)
![图像 3.png](https://i.loli.net/2020/12/28/pEM6XJPRQx2fHk9.png)

3. 只取 last 的第一段结果
![图像 4.png](https://i.loli.net/2020/12/28/LcKP9hvmgNpQ165.png)

### 排序命令：sort，wc，uniq
#### 对数据进行排序：sort
用法：`sort [-fbMnrtuk] file or stdin`

|选项与参数|说明|
|-|-|
|-f|忽略大小写|
|-b|忽略最前边的空格|
|-M|以月份进行排序，如JAN，DEC等|
|-n|用纯数字进行排序(默认是用文字形态排序)|
|-r|反响排序|
|-u|即uniq，去重(即相同数据仅出现一次)|
|-t|分隔符，预设是<kbd>tab</kbd>进行分割|
|-k|以区间进行排序|

例子：
1. 对 /etc/passwd 的数据进行排序
![图像 2.png](https://i.loli.net/2020/12/29/QSB97yDA1rkKqNl.png)

2. 以 /etc/passwd 的数据的第三个区间进行排序
![图像 3.png](https://i.loli.net/2020/12/29/Tcr95aKvkSGLxVo.png)

#### 对数据去重: uniq
用法: `uniq [-ic]`

|选项与参数|说明|
|-|-|
|-i|忽略大小写|
|-c|计数|

PS：
1. uniq 的核心是对有重复显示的行，删除其他的只显示一个结果。因此通常需要结合排序(sort)命令一起使用 

例子：
1. 显示 last 中登陆过的用户名：`last | cut -d " " -f 1 | sort | uniq`

2. 计数 last 中的用户登录总次数：`last | cut -d " " -f 1 | sort | uniq -c`

#### 统计信息的整体数据(行，英文字数，字符串)：wc
用法：`wc -[lwm]`

|选项与参数|说明|
|-|-|
|-l|仅显示行|
|-w|仅显示多少字(英文)|
|-m|仅显示多少字符|

例子：
1. 显示 /etc/passwd 中整体数据
![图像 3.png](https://i.loli.net/2021/01/01/k4vnlFBhXtJQHxc.png)

2. 一行指令串取得登入系统的总人次: `last | grep [a-zA-Z] | grep -v 'wtmp' | grep -v 'reboot' | grep -v 'unknown' |wc -l`

### 数据双向重定向：tee
tee 可以让 standard output 转存一份到文件内并将同样的数据继续送到屏幕去处理
用法: `tee [-a] file`

|选项与参数|说明|
|-|-|
|-a|以累加的方式写入文件|

例子：
1. 读取 last 的数据并保存到 last.txt 中并统计每个有效账号登录次数: `last | grep [a-zA-Z] | grep -v "reboot" | grep -v "wtmp" | cut -d " " -f 1 | sort | uniq -c | tee last.txt`

### 字符转换命令：tr，join，paste，expand
#### 字符删除/替换命令：tr
tr 可以用来删除一段信息中的文字，或者是进行文字的替换
用法：`tr -[ds] cha1`

|选项与参数|说明|
|-|-|
|-d|删除信息中的 cha1 字符串|
|-s|取代重复的字符|

例子：
1. 将 /etc/passwd 转存成 dos 断行到 /root/passwd 中，再将 ^M 符号删除
![图像 1.png](https://i.loli.net/2021/01/02/kE1NwCWscVRg3xy.png)

2. 将一个文件中的 ryan 字符替换为 RYAN 字符：`cat file | tr ryan RYAN`

3. 将一个文件中的小写字符替换为大写：`cat file | tr [a-z] [A-Z]`

#### 整合两个文件相同地方的数据：join
join 可以在两个文件中，有相同数据的那一行，将他们加在一起显示
用法：`join [-ti12] file1 file2`

|选项与参数|说明|
|-|-|
|-t|设置分隔符，默认分隔符是空格|
|-i|忽略大小写|
|-1|数字的1，指第一个文件用哪个字段进行分析|
|-2|数字的2，指第二个文件用哪个字段进行分析|

PS：
1. 使用 join 命令前建议先将数据进行排序

例子：
1. 用 join 一同显示 /etc/passwd 跟 /etc/shadow 中的信息：
![图像 2.png](https://i.loli.net/2021/01/02/akGnciqUVEQe8wD.png)

2. 用 join 一同显示 /etc/passwd 跟 /etc/group 中的信息：
![图像 3.png](https://i.loli.net/2021/01/02/sofvl8BWdnHmYUP.png)

#### 多个文件一起显示：paste
paste 可以简单粗暴的将多个文件一起显示
用法：`paste [-d] file1 file2 ...`

|选项与参数|说明|
|-|-|
|-d|后面接分隔符，默认为<kbd>tab</kbd>|
|-|file 写成 - ，指的是 stdin|

例子：
1. 将 /etc/passwd，/etc/shadow，/etc/group 同一行显示：`paste /etc/passwd /etc/shadow /etc/group | head -n 5`

2. 先将 /etc/group 读出，然后与/etc/shadow，/etc/group 同一行显示且仅取出前三行：`cat /etc/group|paste /etc/passwd /etc/shadow - |head -n 3`（其中 - 代表管道符 | 前的 `cat /etc/passwd` 的结果）

#### tab 与 空格的转换：expand
expand 可以转换文件中的 tab 为 空格
unexpand 可以转换文件中的 空格 为 tab
用法：`expand [-t] file`

|选项与参数|说明|
|-|-|
|-t|接数字，即自定义转换后字符的长度，一般来说，一个 tab 可以用 8 个空格代替|

例子：
![图像 4.png](https://i.loli.net/2021/01/02/psFI9AxeV2DOM3h.png)

#### 切割文件：split
split 可以将文件根据大小或行数进行切割
用法：`split [-bl] file PREFIX`

|选项与参数|说明|
|-|-|
|-b|接数字，即按大小来分割文件，可接单位(b，k，m)|
|-l|接数字，即按行数来分割文件|

例子：
1. 将一个 1.5M 的文件分割成3个 500K 的：`split -b 500k master_db.sql master_db.sql`

2. 将被分割的文件组合成一个文件：`cat master_db.sqla* >> master_db.sql.bak`

3. 读取 ~ 的信息并按照每行10条的信息进行切割：`ll -a ~ | split -l 10 - home`(其中 - 为管道符前命令的stdout，在 split 中作为stdin)

#### 参数替换：xargs
xargs 可以为不支持管线命令的命令来提供该standard input
用法：`xargs [-0pen] command`

|选项与参数|说明|
|-|-|
|-0|数字的0。xargs 一般以空格作为分隔。如果输入的stdin 含有特殊字符(`，\)之类的，将其转为一般字符|
|-e|End of File的意思，一般后边接字符串。即 xargs 分析到这个字符串就停止|
|-p|传入参数后，执行每个命令时，都会询问|
|-n|接次数，即每次 command 执行时获 stdin 的几个数值作为参数|
|xargs|当 xargs 后边没有参数时，默认以 echo 输出|

例子：
1. 取出 /etc/passwd 的第一栏并传到 id 命令中：`cut -d ":" -d 1 /etc/passwd | head -n 3 | xargs -n 1 id`(因为 id 命令不是管线命令且只支持每次传入一个参数)

2. 将所有的 /etc/passwd 内的账号都以 id 查阅，但查到 sync 就结束：`cut -d ":" -f 1 /etc/passwd | xargs -e"sync" -n 1 id`(注意 -e 参数后面没有空格)

3. 找出 /usr/sbin 底下具有特殊权限的文件名，并列出详细属性：`find /usr/sbin/ -perm /7000 | xargs ls -l` 或 `ll $(find /usr/sbin -perm /7000)`

#### 关于 - 的用途：
在管道符当中，常常会使用到前一个指令的 stdout 作为这次的 stdin，就可以使用 - 

例子：
将 /home 的文件打包压缩后解压到 ~/test 中：`tar -cvf - /home | tar -xvf - -C tmp/test`(在这个案例中，全程没有使用到文件名，都是用 - 替换了)