# Linux 工作管理(Job control)
Linux 的工作管理，是指当登入系统取得 bash shell 之后，在单一终端机接口下同时进行多个工作的行为管理，依赖于 bash 环境。类似于 Windows 下的最小化，但是在背景中的任务是暂停的。具有以下特点：

1. 每个工作都是目前 bash 的子进程，彼此之间是有相关性的。即无法以 job control 的方式由 tty1 的 bash 去管理 tty2 的 bash，root 也无法对其他账号进行工作管理
2. 在工作管理中，可以显示提示信息或可交互的环境(如 bash)称为前景(foreground)，其他工作均放在背景 (background) 去暂停或运作(放置在背景中的工作不可以是可交互的，同时也不能用<kbd>Ctrl</kbd>+<kbd>c</kbd>结束)
3. bash 的 job control 有以下限制：
   * 工作所触发的进程必须来自于 shell 的子进程(只管理自己的 bash)；
   * 前景：可以控制与下达指令的这个环境称为前景的工作 (foreground)；
   * 背景：可以自行运作的工作，无法使用 <kbd>Ctrl</kbd>+<kbd>c</kbd> 终止，可使用 bg/fg 呼叫该工作；
   * 背景中运行的进程不能等待 terminal/shell 的输入(input)

## 工作管理命令
|命令|解析说明|
|-|-|
|&|将任务放到后台中执行|
|<kbd>ctrl</kbd>+<kbd>z</kbd>|将当前任务放到后台并暂停|
