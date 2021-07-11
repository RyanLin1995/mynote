# Linux 定时任务
Linux 下实现定时任务的命令为 at 与 crontab 这两个好东西啰！
 at ：at 是个可以处理仅执行一次就结束排程的指令，不过要执行 at 时， 必须要有 atd 这个服务 (第十七
章) 的支援才行。在某些新版的 distributions 中，atd 可能预设并没有启动，那么 at 这个指令就会失效呢！
不过我们的 CentOS 预设是启动的！
 crontab ：crontab 这个指令所设定的工作将会循环的一直进行下去！ 可循环的时间为分钟、小时、每周、
每月或每年等。crontab 除了可以使用指令执行外，亦可编辑 /etc/crontab 来支持。 至于让 crontab 可以生
效的服务则是 crond 这个服务喔！