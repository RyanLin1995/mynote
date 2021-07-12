# Linux 定时任务
Linux 下实现定时任务的命令为 at 与 crontab
* at ：用于一次性定时任务，执行 at 必须要有 atd 服务。在某些新版的 distributions 中，atd 可能预设并没有启动
* crontab ：用于循环定时任务，可循环的时间为分钟、小时、每周、每月或每年等。crontab 除了可以使用命令执行外，也可以通过编辑 /etc/crontab 来实现。依赖于 crond 服务

## 一次性定时任务: at
