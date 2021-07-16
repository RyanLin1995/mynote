# Linux 定时任务
Linux 下实现定时任务的命令为 at 与 crontab
* at ：用于一次性定时任务，执行 at 必须要有 atd 服务。在某些新版的 distributions 中，atd 可能预设并没有启动
* crontab ：用于循环定时任务，可循环的时间为分钟、小时、每周、每月或每年等。crontab 除了可以使用命令执行外，也可以通过编辑 /etc/crontab 来实现。依赖于 crond 服务

## 一次性定时任务: at
**at 命令需要 atd 服务的支持，清先确认 atd 服务已运行**

创建一次性任务：`at [-mldv] TIME` 跟 `at -c 任务编号 `
查看一次性任务: `atq`
取消一次性任务: `atrm 任务编号`

|选项与参数|解析说明|
|-|-|
|-m|当 at 的工作完成后，即使没有输出讯息，亦以 email 通知使用者该任务已完成|
|-l|at -l 相当于 atq，列出目前系统上面该用户所有的 at 排程|
|-d|at -d 相当于 atrm ，可以取消一个在 at 排程中的任务|
|-v|可以使用较明显的时间格式列出 at 排程中的任务栏表|
|-c|接任务编号，可以列出该任务的实际指令内容|

|Time时间格式|说明|
|-|-|
|HH:MM ex> 04:00|在今日的 HH:MM 时刻进行，若该时刻已超过，则明天的 HH:MM 进行此任务|
|HH:MM YYYY-MM-DD ex> 04:00 2015-07-30|强制规定在某年某月的某天进行该任务|
|HH:MM[am\|pm] [Month] [Date] ex> 04pm July 30|一样，强制在某年某月某日的某时刻进行任务|
|HH:MM[am\|pm] + number [minutes\|hours\|days\|weeks] ex> now + 5 minutes ex> 04pm + 3 days|就是说，在某个时间点再加几个时间后才进行任务|

* 例子：
![at.png](https://i.loli.net/2021/07/14/tjZJvO1e8USiyQ7.png)

### 扩展：at 的运行方式
at 命令是以文本方式将所有任务写入到 `/var/spool/at/` 目录内。为了安全起见，需要配合 `/etc/at.allow` 与 `/etc/at.deny` 这两个文件来进行 at 的使用限制

`/etc/at.allow`: 允许使用 at 指令的用户
`/etc/at.deny`: 禁止使用 at 指令的用户



## 循环性工作任务: crontab