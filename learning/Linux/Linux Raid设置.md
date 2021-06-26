# Linux RAID 设置命令：mdadm
用法：
查询：`mdadm --detail /dev/md[*]`
创建：`mdadm --create /dev/md[0-9] --auto=yes --level=[015] --chunk=NK --raid-devices=N --spare-devices=N /dev/sdx /dev/hdx...`

|选项与参数|说明|
|-|-|
|--create|创建 RAID |
|--auto=yes|自动创建目标RAID设备的设备文件，亦即 /dev/md0, /dev/md1...|
|--chunk=Nk|装置的 chunk 大小，也可以当成 stripe 大小，一般是 64K 或 512K|
|--raid-devices=N|使用几个磁盘 (partition) 作为磁盘阵列的装置|
|--spare-devices=N|使用几个磁盘作为备用 (spare) 装置|
|--level=[015]|设定这组磁盘阵列的等级。支持很多，不过建议只要用 0, 1, 5 即可|
|--detail|后面所接的那个磁盘阵列装置的详细信息|
