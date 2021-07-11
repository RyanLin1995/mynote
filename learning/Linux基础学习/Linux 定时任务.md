# Linux 定时任务
Linux 下实现定时任务的命令为 at 与 crontab
* at ：用于一次性定时任务的命令，执行 at 必须要有 atd 服务。在某些新版的 distributions 中，atd 可能预设并没有启动
* crontab ：所设定的工作将会循环的一直进行下去！ 可循环的时间为分钟、小时、每周、
每月或每年等。crontab 除了可以使用指令执行外，亦可编辑 /etc/crontab 来支持。 至于让 crontab 可以生
效的服务则是 crond 这个服务喔！