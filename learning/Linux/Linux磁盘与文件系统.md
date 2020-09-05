## 文件系统特性
我们都知道磁盘分区完毕后还需要进行格式化(format)，之后操作系统才能够使用这个文件系统。 为什么需要进行格式化呢？这是因为每种操作系统所设定的文件属性/权限并不相同，为了存放这些文件所需的数据，因此就需要将分区槽进行格式化，以成为操作系统能够利用的文件系统格式(filesystem)。

由此我们也能够知道，每种操作系统能够使用的文件系统并不相同。举例来说，windows 98 以前的微软操作系统主要利用的文件系统是 FAT (或 FAT16)，windows 2000 以后的版本有所谓的 NTFS文件系统，至于 Linux 的正统文件系统则为 Ext2 (Linux second extended file system, ext2fs)这一个。此外，在默认的情况下，windows 操作系统是不会认识 Linux 的 Ext2 的。传统的磁盘与文件系统之应用中，一个分区槽就是只能够被格式化成为一个文件系统，所以我们可以说一个 filesystem 就是一个 partition。但是由于新技术的利用，例如我们常听到的 LVM 与软件磁盘阵列(software raid)，这些技术可以将一个分区槽格式化为多个文件系统(例如 LVM)，也能够将多个分区槽合成一个文件系统(LVM, RAID)！所以说，目前我们在格式化时已经不再说成针对 partition来格式化了， 通常我们可以称呼一个可被挂载的数据为一个文件系统而不是一个分区槽

那么文件系统是如何运作的呢？这与操作系统的文件数据有关。较新的操作系统的文件数据除了文件实际内容外， 通常含有非常多的属性，例如 Linux 操作系统的文件权限(rwx)与文件属性(拥有者、群组、时间参数等)。 文件系统通常会将这两部份的数据分别存放在不同的区块，权限与属性放置到 inode 中，至于实际数据则放置到 data block 区块中。另外，还有一个超级区块 (superblock) 会记录整个文件系统的整体信息，包括 inode 与 block 的总量、使用量、剩余量等。

每个 inode 与 block 都有编号，至于这三个数据的意义可以简略说明如下：
* superblock：记录此 filesystem 的整体信息，包括 inode/block 的总量、使用量、剩余量， 以及文件系统的格式与相关信息等；
* inode：记录文件的属性，一个文件占用一个 inode，同时记录此文件的数据所在的 block 号码；
* block：实际记录文件的内容，若文件太大时，会占用多个 block 。

由于每个 inode 与 block 都有编号，而每个文件都会占用一个 inode ，inode 内则有文件数据放置的 block 号码。因此，我们可以知道的是，如果能够找到文件的 inode 的话，那么自然就会知道这个文件所放置数据的 block 号码，当然也就能够读出该文件的实际数据了。这是个比较有效率的作法，因为如此一来我们的磁盘就能够在短时间内读取出全部的数据，读写的效能比较好。

### inode 与 block 区块说明
文件系统先格式化出 inode 与 block的区块，假设某一个文件的属性与权限数据是放置到 inode 的 4 号，而这个 inode 记录了文件数据的实际放置点为 2, 7, 13, 15 这四个 block 号码，此时我们的操作系统就能够据此来排列磁盘的阅读顺序，可以一口气将四个 block 内容读出来这种数据存取的方法我们称为索引式文件系统(indexed allocation)

## Linux文件系统
标准的 Linux 文件系统 Ext2 就是使用 inode 为基础的文件系统。inode 的内容在记录文件的权限与相关属性，至于 block 区块则是在记录文件的实际内容。 而且文件系统一开始就将 inode 与 block 规划好了，除非重新格式化(或者利用 resize2fs 等指令变更文件系统大小)，否则 inode 与 block 固定后就不再变动。但是如果仔细考虑一下，如果我的文件系统高达数百 GB 时， 那么将所有的 inode 与 block 通通放置在一起将是很不智的决定，因为 inode 与 block 的数量太庞大，不容易管理。为此之故，因此 Ext2 文件系统在格式化的时候基本上是区分为多个区块群组 (block group) 的，每个区块群组都有独立的 inode/block/superblock 系统

故 Ext2 文件系统格式化后类似于:
|Boot sector|Block Group1|Block Group2|Block Group3|Block Group...|
|-|-|-|-|-|
PS: 在整体的规划当中，文件系统最前面有一个启动扇区(boot sector)，这个启动扇区可以安装开机管理程序，这是个非常重要的设计，因为如此一来我们就能够将不同的开机管理程序安装到个别的文件系统最前端，而不用覆盖整颗磁盘唯一的 MBR，这样也才能够制作出多重引导的环境

### Block Group(以Ext4为例)

ext4 以 block 为单位分配存储空间。block是一组介于 1KiB 和 64KiB 之间的扇区，扇区数必须是2的整数次幂。block 依次被分组成更大的单元，称为block group

为了减少由于碎片而造成的性能问题，块分配器非常努力地将每个文件的 block 保持在同一组中，从而减少查找时间。因此，ext4 引进了 Extent 文件存储方式，以取代 ext2/3 使用的 block mapping 方式。Extent 指的是一连串的连续实体 block，这种方式可以增加大型文件的效率并减少分裂文件

block group 的大小在 sb.s_block_per_group 块中指定，但也可以计算为 8*block_size_in_bytes(由于每个位图仅限于单个块，这意味着块组的最大大小是块大小的8倍)。默认 block 大小为 4KiB 时，每个组将包含32768个blocks，长度为128MiB。块组的数量是设备的大小除以块组的大小。

标准Block Group的布局大致如下所示:
Group 0 Padding|ext4 Super Block|Group Descriptors|Reserved GDT Blocks|Data Block Bitmap|inode Bitmap|inode Table|Data Blocks
|-|-|-|-|-|-|-|-|
1024 bytes|1 block|many blocks|many blocks|1 block|1 block|many blocks|many more blocks|

对于block group 0的特殊情况，前1024个字节未使用，以允许安装x86引导扇区和其他奇怪的程序。super block将从1024字节开始， block 通常为 0。但是，如果出于某种原因，block size = 1024，则 block 0 被标记为正在使用，而super block将进入 block 1

ext4 驱动程序主要处理 block group 0 中的 super block 和Group Descriptors 。super block 和 Group Descriptors 的冗余副本被写入磁盘上的一些 block group，以防磁盘的开头被丢弃，尽管并非所有 block group 都必须承载冗余副本。如果 group 没有冗余副本，则 block group 从 data block bitmap 开始。还请注意，当文件系统刚格式化时，mkfs将在block group
 descriptors(块组描述符)之后和 block bitmap(块位图)开始之前分配 reserve GDT block 空间，以便将来扩展文件系统。默认情况下，允许文件系统比原始文件系统大小增加1024倍。

### Data Block
即放置文件数据的地方。Ext2 文件系统支持的 Block 大小有 1k, 2k, 4k 和 8k，在格式化时 block 的大小就固定了，且每个 block 都有编号，以方便 inode 的记录。不过要注意的是，由于 block 大小的差异，会导致该文件系统能够支持的最大磁盘容量与最大单一文件容量并不相同。因为 block 大小而产生的 Ext2 文件系统限制如下：
|Block大小|1KB|2KB|4KB|
|-|-|-|-|