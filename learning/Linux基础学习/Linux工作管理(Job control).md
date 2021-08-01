# Linux 工作管理(Job control)
Linux 的工作管理，是指当登入系统取得 bash shell 之后，在单一终端机接口下同时进行多个工作的行为管理，依赖于 bash 环境。类似于 Windows 下的最小化，但是在背景中的任务是暂停的。具有以下特点：

1. 其实每个工作都是目前 bash 的子进程，彼此之间是有相关性的。即无法以 job control 的方式由 tty1 的 bash 去管理 tty2 的 bash
2. 在工作管理中，可以显示提示信息或可交互的环境(如 bash)称为前景(foreground)，其他工作均放在背景 (background) 去暂停或运作(放置在背景中的工作不可以是可交互的，同时也不能用<>)
3. 