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