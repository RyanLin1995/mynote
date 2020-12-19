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
1. 命令编修能力(history): 可以通过上下键查询历史指令，最多保存一千条，保存位置为~/.bash_history
2. 命令与文件补全功能([tab]): 可以通过 [tab] 自动补全
3. 命令别名设定功能(alias): 可以通过 `alias` 查询所有的别名，也可以通过 `alias '别名'='命令'`设置新的别名
4. 工作控制、前景背景控制(job control, foreground, background)：前、背景的控制
5. 程序化脚本(shell scripts)：可以编写 Shell scrips
6. 通配符(Wildcard)：即 *
7. 快速编辑: 让光标移动到整个指令串的最前面 ([ctrl]+a) 或最后面 ([ctrl]+e)；从光标处向前删除指令串 ([ctrl]+u) 及向后删除指令串 ([ctrl]+k)
8. 转义字符: \

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

### 限制文件系统和程序: ulimit
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

PS: 
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
|-a|将目前新增的 history 命令添加到 histfiles 中，若没有加 histfiles ，预设写入
 ~/.bash_history|
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
* 也可以用 history -w 强制立刻写入到 ~/.bash_history 写入时如果超过 HISTFILESIZE 限制，那么旧的记录会被删除，仅保留最新的

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
4. 透过 $PATH 这个变量的顺序搜寻到的第一个指令来执行。