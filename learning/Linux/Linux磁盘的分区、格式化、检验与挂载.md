### 1. 列出系统上所有的磁盘列表: lsblk
用法: `lsblk [-dfimpt] device`

|选项与参数|说明|
|-|-|
|-d|仅列出磁盘本身，不列出分区信息|
|-f|同时列出磁盘内的文件系统类型以及UUID|
|-i|使用 ACSII 线段输出，不使用复杂编码(某些环境下很有用)|
|-m|同时输出装置的权限(rwx)|
|-p|列出装置的完整名称|
|-t|列出磁盘详细数据，包括磁盘队列机制。预读写数据量大小等|

`lsblk` 信息解析
|信息名称|解析|
|-|-|
|NAME|装置名称，只显示最后的名字|
|MAJ:MIN|主要:次要装置代码，主要用于核心识别磁盘装置|
|RM|是否为可卸载装置，如光盘，USB等。可卸载为1，不可卸载为0|
|SIZE|磁盘容量|
|RO|是否为只读装置|
|TYPE|装置类型，是磁盘(disk)、分区(parttion)还是只读装置(rom)|
|MOUTPOINT|挂载点|

### 2. 查看全局唯一标识符: blkid
全局唯一标识符(universally unique identifier, UUID): Linux 给予装置独一无二的标识符，可用来挂载或使用
用法:`blkid`

`blkid` 信息解析: 装置名称:UUID:文件系统类型

### 3. 磁盘分区
检查磁盘信息完整过程: 
1. 利用`lsblk` 或 `blkid` 或 `df -h` 获取目前磁盘数量 
2. 利用 `parted [device name] print` 获取磁盘分区信息 
3. 用对应的磁盘管理工具[ `gdisk` 或 `fdisk` ]打开磁盘

#### GPT分区表使用的工具: gdisk
用法: `gdisk [device name]`

`gdisk` 解析:
![捕获1.PNG](https://i.loli.net/2020/10/02/VpAM6JsB4OjbEKn.png)
PS:
   1. 利用 `gdisk` 打开了磁盘后，可以先看到磁盘的分区情况。在 `Command` 中输入 `?` 或 `help` 即可打印 `gdisk` 菜单
   2. `gdisk` 退出方式有两种，分别为 `q` 和 `w`。其中 `q` 仅退出而不保存，`w` 退出且保存操作。

`gdisk p` 解析:
 ![捕获3.PNG](https://i.loli.net/2020/10/02/EkHlo3Jbd79jcaw.png)
|分区表信息名称|意义|
|-|-|
|Number|分区槽编号，1指的是/dev/sda1|
|Start(sector)|每一个分区的开始扇区位置|
|End(sector)|每一个分区的结束扇区位置，与start之间可以算出分区总容量|
|Size|分区容量|
|Code|分区的文件系统类型。Linux 为8300，swap为8200.不过只是一个提示，不代表真正的文件系统|
|Name|文件系统名称|

新增一个磁盘: `gdisk n`
![tempsnip.png](https://i.loli.net/2020/10/02/6LiZXkMvYdRDz31.png)
PS：
1. 新增分区号码时，按照默认值即可
2. 开始扇区也是默认即可，是目前所用扇区的号码+1
3. 结束扇区不能直接默认，默认会使用全部

