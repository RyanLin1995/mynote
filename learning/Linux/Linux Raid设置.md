# Linux RAID 设置命令：mdadm
用法：
查询：`mdadm --detail /dev/md[*]`
创建：`mdadm --create /dev/md[0-9] --auto=yes --level=[015] --chunk=NK --raid-devices=N --spare-devices=N /dev/sdx /dev/hdx...`
管理：`mdadm --manage /dev/md[0-9] [--add 装置] [--remove 装置] [--fail 装置]`

|选项与参数|说明|
|-|-|
|--create/-C|创建 RAID |
|--auto=yes/-a{yes\|no}|自动创建目标RAID设备的设备文件，亦即 /dev/md0, /dev/md1...|
|--chunk=Nk|装置的 chunk(块大小) 大小，也可以当成 stripe 大小，一般是 64K 或 512K|
|--raid-devices=N/-n|使用几个磁盘 (partition) 作为磁盘阵列的装置|
|--spare-devices=N/-x|使用几个磁盘作为备用 (spare) 装置|
|--level=[015]/-l|设定这组磁盘阵列的等级。支持很多，不过建议只要用 0, 1, 5 即可|
|--detail/-D|显示接的那个磁盘阵列装置的详细信息|
|-v|显示过程|
|-f|模拟设备损坏|
|-r|移除设备|
|-Q|查看摘要信息|
|-S|停止RAID磁盘阵列|
|--add|管理模式下将后面的装置加入到这个 md 中|
|--remove|管理模式下将后面的装置从这个 md 中移除|
|--fail|管理模式下将后面的装置设定成为出错的状态|