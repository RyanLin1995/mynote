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
#### GPT分区表使用的工具: gdisk
用法: `gdisk [device name]`

1. 详细解析:
![捕获1.PNG](https://i.loli.net/2020/10/02/VpAM6JsB4OjbEKn.png)
PS:
   1. 在 
