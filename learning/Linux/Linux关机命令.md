在某些版本，用户可以直接通过 tty1 ~ tty7 进行关机或重启，但是如果是远程管理，只能通过 root 进行关机或重启

## Shutdown
用法：`showdown [-krhc] [时间] [警告信息]`
|选项与参数|说明|
|-|-|
|-k|不要真的关机，只是发送警告讯息出去|
|-r|在将系统的服务停掉之后就重新启动(常用)|
|-h|将系统的服务停掉后，立即关机(常用)|
|-c|取消已经在进行的 shutdown 指令内容|
|时间|指定系统关机的时间，通常不加时间，会默认1分钟后关机|

范例：
`shutdown -h 10 'I will shutdown after 10 mins'`
设备将于10分钟后关闭

`shutdown -r now`
设备将马上重启

`shutdown -k now 'This system will reboot'`
仅发出
