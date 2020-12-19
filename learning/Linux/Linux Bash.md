## 什么是 Shell
管理整个计算机硬件的其实是操作系统的核心(kernel)，但是核心是需要被保护的，因此我们一般透过 shell 来跟核心沟通，即透过 Shell 将我们输入的指令与 Kernel 沟通，好让 Kernel 可以控制硬件。

Shell 是可以与操作系统核心沟通的一个应用程序，即壳程序。壳程序其实是操作系统提供给用户的一个接口，可以让用户通过这个壳程序把指令传给操作系统核心或其他应用程序

狭义的 Shell 指的是指令列程序，如 Powershell，bash
广义的 Shell 指的是指令列程序，图形接口等可以调用系统核心与其他软件的应用程序

在 Linux 中，可以透过 `cat /etc/shells` 查看支持的 Shell

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

#### 父进程与子进程怎么共享变量
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