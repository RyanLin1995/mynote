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

### 扩展：at 的限制使用
at 命令是以文本方式将所有任务写入到 /var/spool/at/ 目录内。为了安全起见，需要配合 /etc/at.allow 与 /etc/at.deny 这两个文件来进行 at 的使用限制

`/etc/at.allow`: 允许使用 at 指令的用户
`/etc/at.deny`: 禁止使用 at 指令的用户

因此，实际上 at 指令的工作情况如下：
1. 先找寻 /etc/at.allow 这个文件，写在这个文件中的使用者才能使用 at ，没有在这个文件中的使用者则不能使用 at (即使没有写在 at.deny 当中)
2. 如果 /etc/at.allow 不存在，就寻找 /etc/at.deny 这个文件，写在这个 at.deny 的使用者则不能使用 at 
3. 如果两个文件都不存在，那么只有 root 可以使用 at 这个指令

> /etc/at.allow 是管理较为严格的方式，而 /etc/at.deny 则较为松散 (因为账号没有在该文件中，就能够执行 at 了)。在一般的 Linux 发行当中，由于假设系统上的所有用户都是可信任的，因此系统通常会保留一个空的 /etc/at.deny 文件，意思是允许所有人使用 at 指令的意思 。当你不希望某些使用者使用 at 的话，将那个使用者的账号写入 /etc/at.deny 即可，一个账号写一行。


## 循环性工作任务: crontab
**crontab 命令需要 crond 服务支持，Linux 下是默认开启这服务**

用法：`crontab [-u username] [-l|-e|-r]`
|选项与参数|解析说明|
|-|-|
|-u|只有 root 才能使用的参数，亦即帮其他账号建立/移除 crontab 任务|
|-e|编辑 crontab 的工作内容|
|-l|查阅 crontab 的工作内容|
|-r|移除所有的 crontab 的工作内容，若仅要移除一项，则用 -e 去编辑|

在输入了 `crontab -e` 后会进入到 vi 的编辑界面，这个编辑界面的 shell 是 /bin/sh ，如果想要切换 shell 需要在顶部声明想要切换的 shell。而进入 vi 编辑界面后，该界面的格式如下
|代表意义|分|时|日|月|周|命令|
|-|-|-|-|-|-|-|
|数字范围|0-59|0-23|1-31|1-12|0-7|命令(建议使用绝对路径指令)|

辅助字符用法：
|特殊字符|代表意义|
|-|-|
|*(星号)|代表任何时刻都接受的意思。如：`0 12 * * * command`，代表不论何月、何日的星期几的 12:00 都执行后续命令
|,(逗号)|代表分隔时段的意思。如: `0 3,6 * * * command`，代表 3:00 与 6:00 执行后续命令|
|-(减号)|代表一段时间范围内，如：`20 8-12 * * * command`，代表 8 点到 12 点之间的每小时的 20 分执行一次命令|
|/n(斜线)|n 代表数字，即是每隔 n 单位的意思，如：`*/5 * * * * command`，代表每五分钟执行一次命令，也可以写成 0-59/5|

* PS：
1. 周的 0 与 7 均表示星期天
2. 周与日月尽量不要同时出现，因为每年的周都是在变化的

### crontab 扩展1：crontab 限制使用
crontab 运作方式与 at 相识，同样的存在 /etc/cron.allow 与 /etc/cron.deny，且 /etc/cron.allow 比 /etc/cron.deny 优先

* /etc/cron.allow：记录允许使用 crontab 的用户
* /etc/cron.deny： 记录不可使用 crontab 的用户

>当用户使用 crontab 这个指令来建立工作排程之后，该项工作就会被纪录到 /var/spool/cron/ 里面,而且是以账号来作为判别

### crontab 扩展2：系统的 crontab
1. crontab 指令不仅仅是给用户使用，也是给系统使用的，但是系统使用时不是使用 `crontab` 命令直接执行，而是编辑 /etc/crontab 文件。
2. cron 服务的最低检测单位是分钟，所以 cron 会每分钟去读取一次 /etc/crontab
 与 /var/spool/cron 里面的数据内容，因此编辑了 /etc/crontab 文件后保存即可（由于 crontab 是读到内存当中的，所以在修改完 /etc/crontab 之后，可能并不会马上执行，这时候重新启动 crond 服务即可）

3. /etc/crontab 文件内容：
![etc_crontab.png](https://i.loli.net/2021/07/17/dLwv197rgsqJZOu.png)

4. crontab 服务还跟 /etc/cron.d/* 文件夹有关，/etc/cron.d 文件夹里面的文件是类似于 /etc/crontab 格式的文件
![cron.d.png](https://i.loli.net/2021/07/17/TNXFCB6my2KplM9.png)

   * 可以看到 /etc/cron.d/0hourly 文件夹里面的文件最后一行的 `run-parts /etc/cron.hourly` ，代表的是执行 /etc/cron.hourly 文件夹里面所有的脚本，也就是说 /etc/cron.hourly 下的文件都是 script 文件。
![hourly.png](https://i.loli.net/2021/07/17/yL4uk8mVxapXt5P.png)

* PS: /etc/cron.hourly 代表每小时 crontab 需要执行的 script，而 /etc/cron.daily/，/etc/cron.weekly/，/etc/cron.monthly/ 分别代表每日，每周，每月要执行的 script，但是这三个目录是由 anacron 所执行的，而 anacron 的执行方式则是放在 /etc/cron.hourly/0anacron 里面。`0anacron` 其实是加了判断的 `anacron` 命令脚本

### crontab 总结
* 个人化的任务使用 `crontab -e`：如果是依据个人需求来建立的循环任务，建议直接使用
 `crontab -e` 来建立任务
* 系统维护管理使用 `vim /etc/crontab`：如果是系统的重要的循环任务，建议直接写入 /etc/crontab 
* 自己开发软件使用 `vim /etc/cron.d/`：如果是自己开发的软件，最好使用全新的配置文件，并且放置于 /etc/cron.d/ 目录内
* 固定每小时、每日、每周、每天执行的特别工作：如果与系统维护有关，建议放到 /etc/crontab 中来集中管理。如果想要偷懒，或者是一定要在某个周期内进行的任务，也可以放置到/etc/cron.hourl， /etc/cron.daily/，/etc/cron.weekly/，/etc/cron.monthly/ 这几个目录中

## 执行过时任务：anacron
当设定了循环定时任务后，如果设备关机了，再重新打开设备时，anacron 命令会帮助我们重新执行过时的命令。anacron 预设会以一天、七天、一个月为期去检测系统未进行的 crontab 任务，即 anacron 会检测 /etc/cron.daily/，/etc/cron.weekly/，/etc/cron.monthly/ 三个文件。检测这三个文件的时间戳 (timestamps) 与现在时间的差别来判断是否需要执行过时任务

用法：`anacron [-sfn] [job]` 或 `anacron -u [job]`
|选项与参数|说明|
|-|-|
|-s|开始一连续的执行各项任务，会依据时间记录文件的数据判断是否需要进行|
|-f|强制进行，而不去判断时间记录文件的时间戳|
|-n|立刻进行未进行的任务，而不延迟 (delay) 等待时间
|-u|仅更新时间记录文件的时间戳，不进行任何工作|
|job|由 /etc/anacrontab 定义的各项工作名称|

### anacron 配置文件
1. anacron 的配置文件存在于 /etc/anacrontab 中
![anacron.png](https://i.loli.net/2021/07/19/8b564IegEFZ2Qcj.png)
字段详解：
   * 天数：anacron 执行当下与时间戳 (/var/spool/anacron/ 内的时间纪录文件) 相差的天数，若超过此天数，就准备开始执行，若没有超过则不予执行
   * 延迟时间：若确定超过天数导致要执行任务的延迟执行的时间
   * 工作名称：这个没啥意义，就是个名字
   * 实际要进行的命令：类似于 /etc/cron.d/0hourly 的命令

2. anacron 时间戳保存在 /var/spool/anacron/ 下
![spool_anacron.png](https://i.loli.net/2021/07/21/NkwEgdFS3WLCqX1.png)

### anacron 执行流程
1. 根据 anacron 配置文件 /etc/anacrontab 的设定， cron.daily 这项任务的执行天数为 1 天
2. 从 /var/spool/anacron/cron.daily 取出最后一次执行 anacron 的时间戳
3. 将取出的时间戳与目前的时间对比，若差异天数为 1 天以上 (含 1 天)，就准备进行任务
4. 若准备执行任务，根据 /etc/anacrontab 的设定，将延迟 5 分钟 + 随机小时 (看
 START_HOURS_RANGE 的设定) + 随机分钟(看 RANDOM_DELAY 的设定)
5. 延迟时间过后，开始执行后续指令，亦即 `run-parts /etc/cron.daily`
6. 执行完毕后， anacron 程序结束

## crond 与 anacron 关系
1. crond 会主动去读取 /etc/crontab, /var/spool/cron/*, /etc/cron.d/* 等配置文件，并依据分、时、日、月、星期的时间设定去执行各项任务
2. 根据 /etc/cron.d/0hourly 的设定，系统主动去执行 /etc/cron.hourly/ 目录下的所有脚本
3. 因为 /etc/cron.hourly/0anacron 这个脚本文件的缘故，系统主动的每小时执行 anacron ，读入 /etc/anacrontab 配置文件
4. 根据 /etc/anacrontab 的设定，系统每天、每周、每月去执行 /etc/cron.daily/, /etc/cron.weekly/, /etc/cron.monthly/ 内的脚本，以达到执行周期的任务的目的
                  