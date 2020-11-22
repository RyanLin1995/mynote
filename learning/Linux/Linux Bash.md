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

### 查看指令为 Bash 内奸
