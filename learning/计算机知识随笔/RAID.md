# RAID
RAID（磁盘阵列）全称为 Redundant Arrays of Inexpensive Disks, RAID，即独立硬盘冗余阵列，通过硬件或软件的方法将多个磁盘合成一个大的磁盘，不仅具有磁盘存储功能，还有数据备份功能.

## RAID 主流分级
### RAID 0（等量模式, stripe）：读写效果最好
连续以位或字节为单位分割数据，并行读/写于多个磁盘上，因此具有很高的数据传输率，但它没有数据冗余。RAID 0 只是单纯地提高性能，并没有为数据的可靠性提供保证，而且其中的一个磁盘失效将影响到所有数据。因此，RAID 0 不能应用于数据安全性要求高的场合。![RAID0](https://upload.wikimedia.org/wikipedia/commons/9/9b/RAID_0.svg)

### RAID1（映像模式, mirror）：完整备份
通过磁盘数据镜像实现数据冗余，在成对的独立磁盘上产生互为备份的数据。当原始数据繁忙时，可直接从镜像拷贝中读取数据，因此 RAID 1 可以提高读取性能。RAID 1 是磁盘阵列中单位成本最高的，但提供了很高的数据安全性和可用性。当一个磁盘失效时，系统可以自动切换到镜像磁盘上读写，而不需要重组失效的数据。
![RAID1](https://upload.wikimedia.org/wikipedia/commons/b/b7/RAID_1.svg)

## RAID 10/01：兼顾完整备份和读写效果
根据组合分为 RAID 10 和 RAID 01 ，实际是将 RAID 0 和 RAID 1 标准结合的产物，在连续地以位或字节为单位分割数据并且并行读/写多个磁盘的同时，为每一块磁盘作磁盘镜像进行冗余。它的优点是同时拥有RAID 0的超凡速度和RAID 1的数据高可靠性，但是CPU占用率同样也更高，而且磁盘的利用率比较低。
### RAID 1+0
是先镜像再分区数据，再将所有硬盘分为两组，视为是 RAID 0 的最低组合，然后将这两组各自视为RAID 1运作。
![RAID10](https://upload.wikimedia.org/wikipedia/commons/b/bb/RAID_10.svg)

### RAID 0+1
是跟 RAID 1+0 的程序相反，是先分区再将数据镜像到两组硬盘。它将所有的硬盘分为两组，变成RAID 1的最低组合，而将两组硬盘各自视为RAID 0运作。
![RAID01](https://upload.wikimedia.org/wikipedia/commons/a/ad/RAID_01.svg)

性能上，RAID 0+1 比 RAID 1+0 有着更快的读写速度。可靠性上，当 RAID 1+0 有一个硬盘受损，其余三个硬盘会继续运作。RAID 0+1 只要有一个硬盘受损，同组RAID 0的另一只硬盘亦会停止运作，只剩下两个硬盘运作，可靠性较低。因此，RAID 10远较RAID 01常用，零售主板绝大部份支持RAID 0/1/5/10，但不支持RAID 01。