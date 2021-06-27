# Linux RAID
Linux 下，如果是使用软件版 RAID，需要用到 `mdadm` 命令创建 RAID 盘
## Linux RAID 设置命令：mdadm
### 创建：

命令：`mdadm --create /dev/md[0-9] --auto=yes --level=[015] --chunk=NK --raid-devices=N --spare-devices=N /dev/sdx /dev/hdx...`

|创建 RAID 盘选项与参数|说明|
|-|-|
|--create/-C|创建 RAID |
|--auto=yes/-a{yes\|no}|自动创建目标RAID设备的设备文件，亦即 /dev/md0, /dev/md1...|
|--chunk=Nk|装置的 chunk(块大小) 大小，也可以当成 stripe 大小，一般是 64K 或 512K|
|--raid-devices=N/-n|使用几个磁盘 (partition) 作为磁盘阵列的装置|
|--spare-devices=N/-x|使用几个磁盘作为备用 (spare) 装置|
|--level=[015]/-l|设定这组磁盘阵列的等级|

* 创建软件 RAID 盘步骤：
  1. 添加硬盘到系统中，可用 `lsblk` 查看新增硬盘名称
  2. 格式化硬盘为 fd 格式
  3. 创建 RAID 盘

### 查询：
命令：`mdadm --detail /dev/md[*]` 或 `cat /proc/mdstat`

|查看 RAID 盘选项与参数|说明|
|-|-|
|--detail/-D|显示接的那个磁盘阵列装置的详细信息|
|-v|显示过程|
|-Q|查看摘要信息|

### 管理：
命令：`mdadm --manage /dev/md[0-9] [--add 装置] [--remove 装置] [--fail 装置]`

|管理 RAID 盘选项与参数|说明|
|-|-|
|--add|管理模式下将后面的装置加入到这个 md 中|
|--remove/-r|管理模式下将后面的装置从这个 md 中移除|
|--fail/-f|管理模式下将后面的装置设定成为出错的状态|
|-S|停止RAID磁盘阵列|

* 移除损坏硬盘步骤：
  1. 先从RAID 盘中移除损坏磁盘
  2. 整个 Linux 系统关机，拔出损坏磁盘，并安装上新的磁盘，之后开机（如果支持热插拔，不需要关机）
  3. 将新的磁盘加入 RAID 盘当中

## 关闭 RAID 方法
1. 卸载已挂载的 RAID 盘并修改 `/etc/fstab`
2. 重写 RAID 盘的 metadata 以及 XFS 的 superblock：``