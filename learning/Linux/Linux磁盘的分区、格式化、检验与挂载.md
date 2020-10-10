## 1. 磁盘信息显示
### 列出系统上所有的磁盘列表: lsblk
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

### 查看全局唯一标识符: blkid
全局唯一标识符(universally unique identifier, UUID): Linux 给予装置独一无二的标识符，可用来挂载或使用
用法:`blkid`

`blkid` 信息解析: 装置名称:UUID:文件系统类型

---
## 2. 磁盘分区
检查磁盘信息完整过程: 
1. 利用`lsblk` 或 `blkid` 或 `df -h` 获取目前磁盘数量 
2. 利用 `parted [device name] print` 获取磁盘分区信息 
3. 用对应的磁盘管理工具[ `gdisk` 或 `fdisk` ]打开磁盘

### GPT分区表使用的工具: gdisk
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

新增一个分区: `gdisk n`
![tempsnip.png](https://i.loli.net/2020/10/02/6LiZXkMvYdRDz31.png)
PS：
1. 新增分区号码时，按照默认值即可
2. 开始扇区也是默认即可，是目前所用扇区的号码+1
3. 结束扇区不能直接默认，默认会使用完全部扇区。建议一般直接写上 `+容量`，`gdisk` 会自动计算
4. 类型一般为 `Linux filesystem`，如果需要使用其他的文件系统类型，可以输入 `L` 查看代码
5. 用`p`确认过后，就能用`w`写入磁盘分区表
6. 但是利用`cat /proc/partitions` 、'lsblk'、`blkid` 等命令没有看到新建磁盘，是因为系统在运行当中，为了防止系统出现问题，需要重启后分区才能生效
7. 如果不想重启的话，可以使用 `partprobe [-s]` 更新 Linux 核心分区表，使分区生效

删除一个分区: `gdisk d`
![tempsnip2.png](https://i.loli.net/2020/10/03/NoJyz9PbCKOx2ju.png)
PS:
1. 不能直接删除正在使用的分区。直接删除正在使用的分区，可能导致系统稳定性问题。如果想删除正在使用的分区，必须先卸载掉，再删除，最后更新分区表

### MBR 分区工具:fdisk
![tempsnip3.png](https://i.loli.net/2020/10/03/souOrSU1bhQRfkn.png)

PS:
`fdisk` 用法跟 `gdisk` 用法基本一致。只不过新建 MBR分区时有 Primary, Extended, Logical等限制。而且 `fdisk` 有时会用磁柱(cylinder)作为分区最小单位，与 `gdisk` 以扇区作为最小单位不一样

---
## 3. 磁盘格式化(建立文件系统)
磁盘分区完成后，需要进行格式化(建立文件系统)使系统可以识别到磁盘。
建立文件系统的命令: `mkfs` (make filesystem)

### 格式化 xfs 文件系统: mkfs.xfs
用法: `mkfs.xfs [-b bsize] [-d parms] [-i parms] [-l parms] [-L label] [-f] [-r parms] 装置名称`

|选项与参数|说明|
|-|-|
|-b|block size，一般是 512b - 64 kb，但是 Linux 限制最大为 4k|
|-d|data section 相关设定|
|-d agcount=数值|设定几个储存群组(AG)的意思，通常与CPU有关，例如通过 `grep 'processor' /proc/cpuinfo`得到CPU数量后，把 agcount 设置为跟CPU数量一致的数值|
|-d agsize|每个AG设定多少容量的意思，通常 agcount 跟 agsize 只设定一个|
|-d file|指把装置格式化为文件(例如虚拟磁盘)|
|-d size=数值|data section容量，指可以不将全部装置容量用完|
|-d su=数值|当存在 RAID 时，stripe 数值的意思，与 sw 搭配使用|
|-d sw=数值|当存在 RAID 时，用于存储数据的磁盘数量(需扣除备份盘跟备用盘)|
|-d sunit=数值|与 su 相当，只是单位使用的是几个 sector(512bytes大小) 的意思|
|-d swidth=数值|即 su*sw 的数值，但是以几个 sector(512bytes大小) 来设定|
|-f|如果装置内已经有文件系统，将会强制格式化|
|-i|inode 相关设定|
|-i size=数值|inode 的容量，最小为 256bytes，最大为2K|
|-l|log section 相关设定|
|-l internal=[0|1]|log 是否为内建。1为内建(预设为1)|
|-l logdev=device|log 如果不为内建(即-i internal=0)时所用，后面接装置名称|
|-l size=数值|指定登录区的容量，通常至少需要有512个 block，大约2M以上|
|-L|文件系统标头名称(Label name)|
|-r|realtime section 相关设定|
|-r extsize|即 extent 数值，一般不需更改。但是如果存在 RAID 时，最好与 swidth 数值一致。最小4K，最大1G|

### 格式化 ext 文件系统: mkfs.ext4
用法: `mkfs.ext4 [-b size][-L label] 装置名称`

|选项与参数|说明|
|-|-|
|-b|block 大小，有1K, 2K, 4K的容量|
|-L|接装置的标头名称|

PS:
因为 ext4 默认值已经使用，一般不需要改动。具体可以查看 `/etc/mke2fs.conf`

### 格式化其他文件系统: mkfs
用法: `mkfs.(filesystem) 装置名称` 或 `mkfs -t (filesystem) 装置名称`

其中(filesystem)指需要格式化的文件系统，可以用
 `mkfs.`<kbd>tab</kbd><kbd>tab</kbd> 查看更多支持的文件系统。

而 `mkfs -t (filesystem) 装置名称` 可以显示相关参数

---
## 4. 文件系统校验
系统运行过程中，难免出现宕机情况。加上 Linux 系统是采用异步处理来处理数据的(即内存中的数据不是即时写入到硬盘中)。因此有可能出现文件系统错乱的情况。因此就有可能需要用到文件系统修复命令。

通常修复命令在 Linux 遇到无法开机或出现极大系统问题时才用到。一般情况下使用这个命令，因为可能会对系统进行修改，因此可能会对系统造成危害。但是如果是一个新建的文件系统，那么也可以使用修复命令检查

最后注意的是，进行检查与修复前，文件系统不能有任何挂载

### XFS 文件系统修复命令: xfs_repair
用法: 'xfs_repair [-fnd] 装置名称'

|选项与参数|说明|
|-|-|
|-f|当要修复的是文件而不是装置时，需要用到|
|-n|只检查文件系统而不进行修改|
|-d|在单人维护模式下，针对根目录(/)进行检查与修复，但是不要随便使用|

PS:
对文件系统检查与修复时，该文件系统不能有任何挂载。因此需要先卸载掉掉再处理。而根目录是无法卸载的，可以使用 `xfs_repair -d [device name]` 进行修复。

PSS:
希望我永远都用不上这个命令

### EXT4 文件修复命令: fsck.ext4
用法: 'fsck.ext4 [-pf] [-b superblock] 装置名称'

|选项与参数|说明|
|-|-|
|-p|当要修复的是文件而不是装置时，需要用到|
|-n|只检查文件系统而不进行修改|
|-d|在单人维护模式下，针对根目录(/)进行检查与修复，但是不要随便使用|

---
## 5. 文件系统挂载与卸载
Linux 系统下的磁盘进行完分区与格式化(建立文件系统)后，需要进行挂载才能被访问。挂载点是目录，挂载后就可以通过这目录进入到该文件系统。但是在挂载前需要注意以下几点:
* 单一文件系统不应该被重复挂载到不同的挂载点(目录)中
* 单一目录不应该重复挂载到多个文件系统
* 要作为挂载点的目录，理论上是空目录才可以

PS:
关于第三点，如果挂载的目录不为空，那么原本在目录里面的文件会暂时隐藏起来，只显示被挂载的文件系统里面的东西。只要把文件系统卸载掉，那么原本在目录下的文件就会重新显示出来

### 文件系统挂载: muont
用法: 
`mount [-aln]`
`mount [-t 文件系统] LABEL=`` 挂载点`
`mount [-t 文件系统] UUID=`` 挂载点`
`mount [-t 文件系统] 装置文件名 挂载点`
`mount [-o] [prams] UUID|LABEL|装置文件名 挂载点`

|选项与参数|说明|
|-|-|
|-a|根据配置文件 /etc/fstab 的数据将所有未挂载的磁盘都挂载上来|
|-l|如果只是输入 `mount` 那么只会显示目前挂载的信息，加上 -l 后会显示 Label 名称|
|-n|默认情况下，系统会把实际挂载的情况实时写入到 /etc/fstab中，以供其他程序运作。但是某些情况下(单人维护模式)如果不想写入，可以加上-n选项|
|-t|加上文件系统种类来指定需要挂载的类型，常见的 Linux 支持的类型有:xfs、ext3、ext4、reiserfs、vfat、iso9660、nfs、cifs、smbfs(后三种为网络文件类型)|
|-o|接挂载时额外加上的参数，如账号、密码、读写权限等|
|-o async，sync|被挂载的文件系统采用同步(sync)还是异步(async)的内存机制|
|-o atime，noatime|是否修改读取时间(atime)。某些情况下为了效能，可以使用noatime|
|-o ro，rw|被挂载的文件系统为只读(ro)还是读写(rw)|
|-o auto，noauto|是否允许此文件系统被 `mount -a` 自动挂载(auto)|
|-o dev，nodev|是否允许文件系统上建立装置文件，dev为允许|
|-o suid，nosuid|是否允许文件系统上含有 suid/sgid 的文件格式|
|-o exec，noexec|是否允许文件系统上拥有 binary 文件|
|-o user，nouser|是否允许任何用户在此文件系统上执行 `mount`。一般来说，`mount`仅仅 root 可以进行，如果使用了 user 参数，那么一般的 user 也可以对这个文件系统进行 `mount`|
|-o default|-o 的默认值为:rw，suid，dev，exec，auto，nouser，async|
|-o remount|重新挂载，在系统出错或更新了参数时很有用|

PS:
1. 目前 Centos7 会自动根据 /etc/filesystems(系统指定的测试挂载文件系统类型的优先级) 和 /proc/filesystems(Linux系统已经加载的文件系统类型)，分析 superblock 搭配存在于 /lib/mudules/$(uname -r)/kernel/fs 的驱动来测试是否成功，如果成功就自动把文件系统挂载起来。因此不需要再使用 `mount -t` 
2. 挂载了光驱后，需要卸载才能退出光盘
3. 如果挂载的光盘或U盘中有中文，可以用 `mount -o codepage=950,iocharset=utf8` 来处理
4. 当系统出现问题或改动了挂载参数，可以使用 `mount -o remount [prams]` 来进行重新挂载，如 / 目录从只读状态重新挂载为可读写状态: `mount -o remount,rw,auto /`
5. 可以用 `mount` 把一个目录挂载到另一个目录下，用 `mount --bind`，如把 /var 挂载到 /data/var : `mount --bind /var /data/var`

### 文件系统的卸载: umount
用法: `umount [-fln] 装置名称或挂载点`

|选项与参数|说明|
|-|-|
|-f|强制卸载，可用于网络文件系统(NFS)无法读取时卸载|
|-l|立刻卸载文件系统，比 -f 强|
|-n|不更新 /etc/mtab 下进行卸载|

PS:
1. 如果要卸载的装置有其他挂载，一定要用挂载点作为卸载
2. 如果卸载时出现 target is busy 的错误，需要先切换到其他路径再卸载，因为可能正在使用该文件系统

---
## 6. 磁盘/文件系统参数修订
### 手动建立设备文件:mknod
Linux 下所有的装置均为文件。因此 Linux 会通过文件的 major 与 minor 数值来代表装置。常用的装置代码ruxia:
|磁盘文件名|Major|Minor|
|-|-|-|
|/dev/sda|8|0-15|
|/dev/sdb|8|16-31|
|/dev/loop0|7|0|
|/dev/loop1|7|1|
|/dev/vda|252|0-15|

基本上 Linux 会自动实时产生装置文件，但是某些情况下如果需要手动建立装置文件，可以用 `mknod`
用法:`mknod 装置文件名 [bcp] [Major] [Minor]`
|选项与参数|说明|
|-|-|
|-b|建立一个周边储存设备文件，如磁盘|
|-c|建立一个周边输入设备文件，如鼠标键盘等|
|-p|建立一个FIFO文件|
|Major|主要装置代码|
|Minor|次要装置代码|

PS:
1. Major 跟 Minor 一定要根据规范设置，不能随便填写

### 修改文件系统的 UUID 与 Label Name
#### 修改 xfs 文件系统的 UUID 与 Label name: xfs_admin
用法: `xfs_admin [-lu] [-L label] [-U uuid] 装置文件名`
|选项与参数|说明|
|-|-|
|-l|列出这个装置的 label name|
|-u|列出这个装置的 UUID|
|-L|设定这个装置的 label name|
|-U|设定这个装置的 UUID|

#### 修改 ext4 文件系统的 UUID 与 Label name: tune2fs
用法: `tune2fs [-l] [-L Label] [-U uuid] 装置文件名`
|选项与参数|说明|
|-|-|
|-l|类似于 `dumpe2fs -h`，将 superblock 的数据列出来|
|-L|设定这个装置的 label name|
|-U|设定这个装置的 UUID|

PS:
1. 为什么推荐使用 UUID 进行挂载而不是 装置文件名(/dev/sda4) 挂载，是因为如果该装置是一个可移动的装置，那么在不同的 Linux 系统下显示的装置文件名可能不一致。但是 UUID 是唯一的。

---
## 7.开机自动挂载
如果想要 Linux 开机自动挂载特定文件系统，可以修改 /etc/fstab 文件。但是需要注意以下几点:
* 根目录 / 是必须要挂载的，而且还是先于其他挂载点被挂载
* 其他挂载点必须为已建立的目录，可任意指定，但需要遵循系统目录架构原则(FHS)
* 所有挂载点同一时间只能挂载一次
* 所有分区同一时间只能挂载一次
* 如果需要卸载挂载，先确保工作目录不在要被卸载的目录内

### 开机自动挂载文件: /etc/fstab
/etc/fstab 是开机时自动挂载磁盘的配置文件。但是实际上 filesystem 的挂载记录是写入到 /etc/mtab 与 /roc/mounts 这两个文件中。因此，每次 filesystem 的挂载有变化时，这两个文件也会相应的变化。

如果 /etc/fstab 因此填写错误无法开机，可以进入单人维护模式，然后重新挂载根目录 / 去修改 /etc/fstab ，具体命令: `mount -n -oremount,rw /`

字段解析:
![tempsnip4.png](https://i.loli.net/2020/10/10/EoHxynkKZtvUDul.png)

* 第一栏: 磁盘装置文件名/UUID/Label Name: 可以填写装置文件名(如:/dev/sda2)、UUID(如:UUID=)或Label name(如: Label=)
* 第二栏: 挂载点: 必须是 Linux 已存在的目录
* 第三栏: 磁盘分区的文件系统类型: 如果是使用 `mount` 命令挂载，那么 Linux 会自动帮我们识别文件系统类型。但是在 /etc/fstab 中，需要手动填写文件系统类型
* 第四栏: 文件系统参数，即 'mount -o [prams]' 具体请参考 `mount` 命令详解
* 第五栏: 能否被 `dump` 备份: 指该挂载的文件系统能否被 `dump`  命令备份。但现在有很多备份方式，只需填写 0 即可
* 第六栏: 是否以 fsck 检验扇区: 早期开机会通过 `fsck` 检验本机文件系统是否完整(clean)，如果是 ext 家族的文件系统，那么需要填上数字，数字越小代表优先级越高。如果是 xfs 家族文件系统，填0即可。

### 挂载