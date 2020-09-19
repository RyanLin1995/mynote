## 文件系统特性
磁盘分区完毕后还需要进行格式化(format)，之后操作系统才能够使用这个文件系统。为什么需要进行格式化呢？这是因为每种操作系统所设定的文件属性/权限并不相同，为了存放这些文件所需的数据，因此就需要将分区槽进行格式化，以成为操作系统能够利用的文件系统格式(filesystem)。

每种操作系统能够使用的文件系统并不相同。举例来说，windows 98 以前的微软操作系统主要利用的文件系统是 FAT (或 FAT16)，windows 2000 以后的版本有所谓的 NTFS文件系统，至于 Linux 的正统文件系统则为 Ext2 (Linux second extended file system, ext2fs) 这一个。此外，在默认的情况下，windows 操作系统是不会认识 Linux 的 Ext2 的。传统的磁盘与文件系统之应用中，一个分区槽就是只能够被格式化成为一个文件系统，所以我们可以说一个 filesystem 就是一个 partition。但是由于新技术的利用，例如我们常听到的 LVM 与软件磁盘阵列(software raid)，这些技术可以将一个分区槽格式化为多个文件系统(例如 LVM)，也能够将多个分区槽合成一个文件系统(LVM, RAID)！所以说，目前我们在格式化时已经不再说成针对 partition 来格式化了，通常我们可以称呼一个可被挂载的数据为一个文件系统而不是一个分区槽

那么文件系统是如何运作的呢？这与操作系统的文件数据有关。较新的操作系统的文件数据除了文件实际内容外，通常含有非常多的属性，例如 Linux 操作系统的文件权限(rwx)与文件属性(拥有者、群组、时间参数等)。文件系统通常会将这两部份的数据分别存放在不同的区块，权限与属性放置到 inode 中，至于实际数据则放置到 data block 区块中。另外，还有一个超级区块 (superblock) 会记录整个文件系统的整体信息，包括 inode 与 block 的总量、使用量、剩余量等。

每个 inode 与 block 都有编号，至于这三个数据的意义可以简略说明如下：
* superblock：记录此 filesystem 的整体信息，包括 inode/block 的总量、使用量、剩余量，以及文件系统的格式与相关信息等；
* inode：记录文件的属性，一个文件占用一个 inode，同时记录此文件的数据所在的 block 号码；
* block：实际记录文件的内容，若文件太大时，会占用多个 block 。

由于每个 inode 与 block 都有编号，而每个文件都会占用一个 inode ，inode 内则有文件数据放置的 block 号码。因此，我们可以知道的是，如果能够找到文件的 inode 的话，那么自然就会知道这个文件所放置数据的 block 号码，当然也就能够读出该文件的实际数据了。这是个比较有效率的作法，因为如此一来我们的磁盘就能够在短时间内读取出全部的数据，读写的效能比较好。

### inode 与 data block 区块说明
文件系统先格式化出 inode 与 data block 的区块，假设某一个文件的属性与权限数据是放置到 inode 的 4 号，而这个 inode 记录了文件数据的实际放置点为 2, 7, 13, 15 这四个 block 号码，此时我们的操作系统就能够据此来排列磁盘的阅读顺序，可以一口气将四个 block 内容读出来这种数据存取的方法我们称为索引式文件系统(indexed allocation)

## Linux文件系统
标准的 Linux 文件系统 Ext2 就是使用 inode 为基础的文件系统。inode 记录文件的权限与相关属性，至于 data block 区块则记录文件的实际内容。而且文件系统一开始就将 inode 与 data block 规划好了，除非重新格式化 (或者利用 resize2fs 等指令变更文件系统大小)，否则 inode 与 data block 固定后就不再变动。但是仔细考虑一下，如果我的文件系统高达数百 GB 时，那么将所有的 inode 与 data block 通通放置在一起将是很不智的决定，因为 inode 与 data block 的数量太庞大，不容易管理。因此 Ext2 文件系统在格式化的时候基本上是区分为多个区块群组 (block group) 的，每个区块群组都有独立的 inode/block/superblock 系统

故 Ext2 文件系统格式化后类似于:
|Boot sector|Block Group1|Block Group2|Block Group3|Block Group...|
|-|-|-|-|-|
PS: 在整体的规划当中，文件系统最前面有一个启动扇区(boot sector)，这个启动扇区可以安装开机管理程序，这是个非常重要的设计，因为如此一来我们就能够将不同的开机管理程序安装到个别的文件系统最前端，而不用覆盖整颗磁盘唯一的 MBR，这样也才能够制作出多重引导的环境

### Block Group(以Ext4为例)
文件储存在硬盘上，硬盘的最小存储单位叫做"扇区"（Sector）。每个扇区储存512字节（相当于0.5KB）。操作系统读取硬盘的时候，不会一个个扇区地读取，这样效率太低，而是一次性连续读取多个扇区，即一次性读取一个"块"（block）。这种由多个扇区组成的"块"，是文件存取的最小单位。"块"的大小，最常见的是4KB，即连续八个 sector 组成一个 block。

block group 的大小在 sb.s_block_per_group 块中指定，但也可以计算为 8*block_size_in_bytes。(由于每个位图仅限于单个 block ，这意味着 block group 的最大大小是 block size 的8倍，即如果一个 block 大小为4K，那么可以映射标识4 x 1024 x 8=32768个 block 的使用状态；由于一个 group 只有一个 Data Block Bitmap，所以一个 block group 最大为 32768 x 4KB=128MB)

#### 标准Block Group的布局大致如下所示:
Group 0 Padding|ext4 Super Block|Group Descriptors|Reserved GDT Blocks|Data Block Bitmap|inode Bitmap|inode Table|Data Blocks
|-|-|-|-|-|-|-|-|
1024 bytes|1 block|many blocks|many blocks|1 block|1 block|many blocks|many more blocks|

对于block group 0的特殊情况，前1024个字节未使用，以允许安装x86引导扇区和其他奇怪的程序。super block将从1024字节开始， block 通常为 0。但是，如果出于某种原因，block size = 1024，则 block 0 被标记为正在使用，而super block将进入 block 1

ext4 主要处理 block group 0 中的 super block 和Group Descriptors 。super block 和 Group Descriptors 的冗余副本被写入磁盘上的一些 block group，以防磁盘的开头被丢弃，尽管并非所有 block group 都必须承载冗余副本。如果 group 没有冗余副本，则 block group 从 data block bitmap 开始。

### SuperBlock
SuperBlock 是记录整个 filesystem 相关信息的地方，包括以下主要信息：
1. 每个 block group 的 inode 和 block 数量
2. 未使用/已使用的 inode 和 block 数量
3. inode 和 block 的大小(block 大小有1k, 2k, 4k; inode 大小有128bytes, 256bytes, 512bytes)
4. filesystem 的挂载时间、最近一次写入数据的时间、最近一次检验磁盘 (fsck) 的时间等文件系统的相关信息
5. 一个 valid bit 数值，若此文件系统已被挂载，则 valid bit 为 0，若未被挂载，则 valid bit 为 1

### Block Group Description
用于定义 block group 参数，如 block group 开始和结束的 block 号码，同时提供 super block 位置、 inode bitmap 和 inode table 的位置、block bitmap、空闲block 和 inode 的数量，以及其他一些有用的信息。每一个描述符的大小64byte，GDBs所占用block多少是与卷的大小有关的。

### Reserved GDT Blocks
当文件系统刚格式化时，mkfs将在block group descriptors(块组描述符)之后和 block bitmap(块位图)开始之前分配 reserve GDT block 空间，以便将来扩展文件系统。默认情况下，允许文件系统比原始文件系统大小增加1024倍。

### Block bitmap and Inode bitmap
block bitmap(块位图) 跟 inode bitmap(inode位图)，用于跟踪 block group内 data block 跟 inode 的使用情况。data block 跟 inode 如果被使用了，用 1 表示，没有被使用，用 0 表示。


### Inode table
#### Inode table基本概念
文件数据都储存在"块"中，那么很显然，我们还必须找到一个地方储存文件的元数据（metadata），比如文件的创建者、文件的创建日期、文件的大小以及该文件实际资料是放置在哪个 data block 内等等。这种储存文件元信息的区域就叫做 inode，中文译名为"索引节点"。

每一个文件都有对应的 inode，里面包含了以下基本信息:
* 该文件的存取模式(read/write/excute)；
* 该文件的拥有者与群组(owner/group)；
* 该文件的容量；
* 该文件建立或状态改变的时间(ctime)；
* 最近一次的读取时间(atime)；
* 最近修改的时间(mtime)；
* 定义文件特性的旗标(flag)，如SetUID...；
* 该文件真正内容的指向(pointer)；

inode 的数量与大小也是在格式化时就已经固定了，除此之外 inode 还有以下特色:
* 每个 inode 大小均固定为 128 bytes (新的 ext4 与 xfs 可设定到 256 bytes 甚至到 512 bytes)；
* 每个文件都仅会占用一个 inode 而已；
* 承上，因此文件系统能够建立的文件数量与 inode 的数量有关；
* 系统读取文件时需要先找到 inode，并分析 inode 所记录的权限与用户是否符合，若符合才能够开始实际读取 block 的内容

#### Inode 的多间接
inode 中关于 block 号的记录一共包含有12个直接连接、1个间接连接、1个双间连接和1个三间连接。Inode结构图如下：
![inode.jpg](https://i.loli.net/2020/09/06/ugikvxfNnAq1VHo.jpg)
上图最左边为 inode 本身 (本例为128 bytes)，里面有 12 个直接指向 block 号码的对照，这 12 笔记录就能够直接取得 block 号码。至于所谓的间接就是再拿一个 block 来当作记录 block 号码的记录区，如果文件太大时，就会使用间接的 block 来记录编号。同理，如果文件持续增加，那么就会利用所谓的双间接，第一个 block 仅再指出下一个记录编号的 block 在哪里，实际记录的在第二个 block 当中。依此类推，三间接就是利用第三层 block 来记录编号

可以想象成口袋里装了一个车钥匙，车钥匙打开的车里装了一车车钥匙，便需要乘1024，一个 inode 指向 block 需要消耗自身 4Bytes，一个 block 里内存为 4KB ,即为 inode 的1024倍，所以一个间接的话容量大小为1024*4。

一个 inode 数据大小为256bytes，inode block 默认为512个 block，所以一个 group 中的文件多少为512*4096/256=8192个

#### Inode工作方式
文件:
1. 系统找到这个文件名对应的 inode 号码
2. 通过 inode 获取相关信息(一般为权限与data block所在位置)
3. 根据 inode 记录的 data block 所在，读取数据

目录：
目录也是一种文件，只是是一种特殊的文件，可以简单地理解为是一张表，这张表里面存放了隶属于该目录的文件的文件名，以及所匹配的 inode 编号。即当我们在 Linux 下的文件系统建立一个目录时，文件系统会分配一个 inode 与至少一块 block 给该
目录。目录文件的读权限（r）和写权限（w），都是针对目录文件本身。由于目录文件内只有文件名和inode号码，所以如果只有读权限，只能获取文件名，无法获取其他信息，因为其他信息都储存在inode节点中，而读取inode节点内的信息需要目录文件的执行权限（x）。

例子：读取 /etc/password 文件
通过 `ll -di / /etc/ /etc/passwd` 得
`/` 的inode为128
`/etc` 的inode为1357
`/etc/passwd` 的inode为7890

读取流程:
1. `/` 的 inode: 透过挂载点的信息找到 inode 号码为 128 的根目录 inode，且 inode 规范的权限让我们可以读取该 block 的内容(有 r 与 x)
2. `/` 的 block: 通过上述步骤拿到 `/` 的block号码，找到 `/etc/` 目录的 inode 号码(1357)
3. `/etc/` 的 inode: 读取 `/etc/` 的inode，有 r 跟 x 权限，因此可读取 block 内容
4. `/etc/` 的 block: 读取 `/etc/` 的block，找到 `/etc/passwd` 的 inode(7890)
5. `/passwd` 的 inode: 读取 `/etc/passwd` 的 inode 得知有 r 跟 x 权限，可读取 `/etc/passwd` 的 block 内容
6. `/passwd` 的 block: 将 `/etc/passwd` 的block内容读取出来

#### Inode number 和 Inode table
当一个分区被格式化为文件系统的时候，会自动产生 inode number。
inode number 可以决定在这个分区中存储多少文件或目录，因为每个文件和目录都会有与之相对应的 inode number。

每个 inode number 都有对应的 inode table。
inode table 记录这个 inode number 对应文件所对应的 metadata（元数据）。

### Data Block
#### Ext2:
即放置文件数据的地方。Ext2 文件系统支持的 Block 大小有 1k, 2k, 4k 和 8k，在格式化时 block 的大小就固定了，且每个 block 都有编号，以方便 inode 的记录。不过要注意的是，由于 block 大小的差异，会导致该文件系统能够支持的最大磁盘容量与最大单一文件容量并不相同。因为 block 大小对 Ext2 文件系统限制如下：
|Block大小|1KB|2KB|4KB|8KB|
|-|-|-|-|-|
|file system blocks|2,147,483,647^[a]^|2,147,483,647|2,147,483,647|2,147,483,647|
|blocks per block group|8192|16384|32768|65536|
|inodes per block group|8192|16384|32768|65536|
|bytes per block group|8,388,608(8MiB)|33,554,432(32MiB)|134,217,728(128MiB)|536,870,912(512MiB)|
|file system size(real)|4,398,046,509,056(4TiB)|8,796,093,018,112(8TiB)|17,592,186,036,224(16TiB)|35,184,372,080,640(32TiB)|
|file system size(Linux)|2,199,023,254,528(2TiB)^[b]^|8,796,093,018,112(8TiB)|17,592,186,036,224(16TiB)|35,184,372,080,640(32TiB)|
|blocks per file|16,843,020|134,217,728|1,074,791,436|8,594,130,956
|file size(real)|17,247,252,480(16GiB)|274,877,906,944(256GiB)|2,199,023,255,552(2TiB)|2,199,023,255,552(2TiB)|
|file size(Linux 2.6.28)|17,247,252,480(16GiB)|274,877,906,944(256GiB)|2,199,023,255,552(2TiB)|2,199,023,255,552(2TiB)|
* a: In Ext4 file system, the 32-bit filesystems blocks and inodes limits are 2^32^, the 64-bit blocks limits is 2^64^, inodes is 2^32^
* b: This limit comes from the maximum size of a block device in Linux 2.4; it is unclear whether a Linux 2.6 kernel using a 1KiB block size could properly format and mount a Ext2 partition larger than 2TiB.

 Ext2 文件系统的 block 基本限制如下：
* 原则上，block 的大小与数量在格式化完就不能够再改变了(除非重新格式化)；
* 每个 block 内最多只能够放置一个文件的数据；
* 承上，如果文件大于 block 的大小，则一个文件会占用多个 block 数量；
* 承上，若文件小于 block ，则该 block 的剩余容量就不能够再被使用了(磁盘空间会浪费)

一个栗子:
假设你的 Ext2 文件系统使用 4K block，而该文件系统中有 10000 个小文件，每个文件大小均为 50bytes，请问此时你的磁盘浪费多少容量？
答：
由于 Ext2 文件系统中一个 block 仅能容纳一个文件，因此每个 block 会浪费 4096-50=4046(byte)，系统中总共有一万个小文件，所有文件容量为:50(bytes)x10000=488.3Kbytes，但此时浪费的容量为：4046(bytes)x10000=38.6MBytes。想一想，不到 1MB 的总文件容量却浪费将近 40MB 的容量，且文件越多将造成越多的磁盘容量浪费。

#### Ext4 
因 ext4 引进了 Extent 文件存储方式，以取代 ext2/3 使用的 block mapping 方式。Extent 指的是一连串的连续实体 block，这种方式可以增加大型文件的效率并减少分裂文件

block 大小而产生的 Ext4 文件系统限制如下：

For 32-bit filesystems, limits are as follows:
|Item|1KiB|2KiB|4KiB|64KiB|
|-|-|-|-|-|
|Blocks|2^32|2^32|2^32|2^32|
|Inodes|2^32|2^32|2^32|2^32|
|File System Size|4TiB|8TiB|16TiB|256PiB|
|Blocks Per Block Group|8,192|16,384|32,768|524,288|
|Inodes Per Block Group|8,192|16,384|32,768|524,288|
|Block Group Size|8MiB|32MiB|128MiB|32GiB|
|Blocks Per File, Extents|2^32|2^32|2^32|2^32|
|Blocks Per File, Block Maps|16,843,020|134,480,396|1,074,791,436|4,398,314,962,956(really 2^32 due to field size limitations)|
File Size, Extents|4TiB|8TiB|16TiB|256TiB|
File Size, Block Maps|16GiB|256GiB|4TiB|256TiB|

For 64-bit filesystems, limits are as follows:

|Item|1KiB|2KiB|4KiB|64KiB|
|-|-|-|-|-|
|Blocks|2^64|2^64|2^64|2^64|
|Inodes|2^32|2^32|2^32|2^32|
|File System Size|16ZiB|32ZiB|64ZiB|1YiB|
|Blocks Per Block Group|8,192|16,384|32,768|524,288|
|Inodes Per Block Group|8,192|16,384|32,768|524,288|
|Block Group Size|8MiB|32MiB|128MiB|32GiB|
|Blocks Per File, Extents|2^32|2^32|2^32|2^32|
|Blocks Per File, Block Maps|16,843,020|134,480,396|1,074,791,436|4,398,314,962,956(really 2^32 due to field size limitations)|
File Size, Extents|4TiB|8TiB|16TiB|256TiB|
File Size, Block Maps|16GiB|256GiB|4TiB|256TiB|

---
## 查询 filesystem 相关信息的命令
### Ext filesystem: dumpe2fs
用法: `dumpe2fs [-bh] 装置文件名`
|选项与参数|说明|
|-|-|
|-b|列出保留为坏轨的部分|
|-h|仅列出superblock，不列出其他区段的内容|

### 查询文件系统类型: blkid
用法: `blkid`

---
## 文件储存与日志式文件系统: EXT3/EXT4
当新建一个文件或目录时，文件系统的行为如下:
1. 先确定用户对于欲新增文件的目录是否具有 w 与 x 的权限，若有的话才能新增；
2. 根据 inode bitmap 找到没有使用的 inode 号码，并将新文件的权限/属性写入；
3. 根据 block bitmap 找到没有使用中的 block 号码，并将实际的数据写入 block 中，且更新 inode 的 block 指向数据；
4. 将刚刚写入的 inode 与 block 数据同步更新 inode bitmap 与 block bitmap，并更新 superblock 的内容。

其中，inode table 与 data block 称为数据存放区域，