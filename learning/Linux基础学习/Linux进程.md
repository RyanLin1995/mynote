# Linux 进程
**进程**： 一个程序被加载到内存当中运行，那么在内存内的那个数据就被称为进程(process)

## 什么是进程(process)
在 Linux 系统当中，触发任何一个事件时，系统都会将它定义成为一个进程，并且给予这个进程一个 ID ，称为 PID，同时依据启动这个进程的用户与相关属性关系，给予这个 PID 一组有效的权限设定。之后这个 PID 能够在系统上面进行的动作，就与这个 PID 的权限有关

如何触发事件：执行一个程序或命令

### 进程与程序
>系统是仅认识 binary file 的，那么当我们要让系统工作的时候，就需要启动一个 binary file ，那个 binary file 就是程序 (program)。
每个程序都有三组 r/w/x 的权限，所以：不同的使用者身份执行这个 program 时，系统给予的权限也都不相同！举例来说，当 root 利用 touch 来建立一个空的文件，他取得的是 UID/GID = 0/0 的权限，而当 dmtsai (UID/GID=501/501) 执行这个 touch 时，他的权限就跟 root 不一样


[程序被加载成为程序以及相关资料的示意图](https://linux.vbird.org/linux_basic/centos7/0440processcontrol/process_1.gif)
程序被加载成为程序以及相关资料的示意图