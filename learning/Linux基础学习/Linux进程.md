# Linux 进程
**进程**： 一个程序被加载到内存当中运行，那么在内存内的那个数据就被称为进程(process)

## 什么是进程(process)
在 Linux 系统当中，触发任何一个事件时，系统都会将它定义成为一个进程，并且给予这个进程一个 ID ，称为 PID，同时依据启动这个进程的用户与相关属性关系，给予这个 PID 一组有效的权限设定。之后这个 PID 能够在系统上面进行的动作，就与这个 PID 的权限有关

如何触发事件：执行一个程序或命令

### 进程与程序
>系统是仅认识 binary file 的，那么当我们要让系统工作的时候，就需要启动一个 binary file ，那个 binary file 就是程序 (program)。

程序被加载成为程序以及相关资料的示意图:
![程序被加载成为程序以及相关资料的示意图.gif](https://linux.vbird.org/linux_basic/centos7/0440processcontrol/process_1.gif)

>如上图所示，程序一般是放置在硬盘中，然后通过用户的执行来触发。触发后会加载到内存中成为一个个体，那就是程序。为了操作系统可管理此程序，因此程序会给予执行者权限/属性等参数，并包括程序所需要的代码与数据或文件数据等，最后再给予一个 PID 。系统就是通过这个 PID 来判断该 process 是否具有权限进行工作的

> 每个程序都有三组 r/w/x 的权限，所以：不同的使用者身份执行这个 program 时，系统给予的权限也都不相同！举例来说，当 root 利用 touch 来建立一个空的文件，他取得的是 UID/GID = 0/0 的权限，而当 dmtsai (UID/GID=501/501) 执行这个 touch 时，他的权限就跟 root 不一样。

> 例如我们要操作系统的时候，通常是利用连接程序或者直接在主机前面登入，然后取得 /bin/bash 这个 shell 。但每个人取得的 shell 权限都是不一样的

程序与程序之间的差异：
![程序与程序之间的差异](https://linux.vbird.org/linux_basic/centos7/0440processcontrol/program_process.gif)

>即当我们登入并执行 bash 时，系统已经给我们一个 PID 了，这个 PID 就是依据登入者的 UID/GID （/etc/passwd） 生成的。以上面的图来做说明，/bin/bash 是一个程序 （program），当 dmtsai 登入后，他取得一个 PID 号码为 2234 的程序，这个程序的 User/Group 都是 dmtsai ，而当这个程序进行其他作业时，例如执行上面提到的 touch 指令时，那么由这个程序衍生出来的其他程序在一般状态下，也会沿用这个程序的相关权限的！

以上是来自《鸟哥的Linux私房菜》关于 Linux PID 的介绍。也就是说，每个程序在被事件触发而进到内存中变为