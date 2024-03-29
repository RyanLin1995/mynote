# Linux 压缩
就是压缩文件/目录的容量，方便传输。压缩的方法有很多，常见的是把 bit 压缩(如一个文本存储了数字1，其大小为 1 byte，即 8 bit，二进制写作 00000001。那么压缩时就把前面7个0压缩掉) 跟 统计重复压缩(如一个文本存储了数字1，其大小为 1 byte，即 8 bit，二进制写作 00000001。那么压缩时就把前面的 0000000 记录为 7个0)。目前互联网上很多网页都是采用了压缩后再传输的方法，提高了数据传输量。

Linux 中存在多种压缩命令，不同的命令使用的压缩技术不同，因此 Linux 通过扩展名的方式来记录压缩文件，使用户知道需要处理该压缩文件时用到的压缩命令。但是该扩展名仅仅用于提示作用， Linux 的扩展名还是没有特别作用

Linux 常见压缩扩展名:
|扩展名|对应压缩命令|
|-|-|
|*.Z|compress 程序压缩的文件|
|*.zip|zip 程序压缩的文件|
|*.gz|gzip 程序压缩的文件|
|*.bz2|bzip2 程序压缩的文件|
|*.xz|xz 程序压缩的文件|
|*.tar|tar 程序打包的数据，但是没有经过压缩|
|*.tar.gz|tar 程序打包的数据，经过了 gzip 的压缩|
|*.tar.bz2|tar 程序打包的数据，经过了 bzip2 的压缩|
|*.tar.xz|tar 程序打包的数据，经过了 xz 的压缩|

## gzip 压缩命令和 zcat/zmore/zless/zgrep
用法: 'gzip [-cdtv#] 文件名'

|选项与参数|说明|
|-|-|
|-c|将要压缩的数据输出到屏幕上，可以通过数据流重定向处理得到的显示|
|-d|解压缩 gzip 文件|
|-t|检验压缩文件|
|-v|显示压缩比|
|-#|压缩的等级，-1最快但是压缩比最差，-9最慢但是压缩比最好。默认为-6|

PS:
1. 使用 `gzip 文件名` 压缩完文件后，源文件会被删除
2. gzip 文件能被 Windows 下的压缩文件打开
3. 使用 `gzip -d 文件名` 解压缩完文件后，原压缩文件会被删除
4. 使用 `gzip -c 文件名 > 压缩文件名` 命令，压缩文件名需要自己创建，并且压缩完成后源文件不会被删除
5. zcat/zmore/zless/zgrep 可用于不解压情况下查看的 gzip 文本压缩文件
6. 如果还存在 .Z 文件，可以通过 `znew 文件名` 转为 gzip 文件

## bzip2 压缩命令与 bzcat/bzmore/bzless/bzgrep
用法: `bzip2 [-cdkvz#] 文件名`

|选项与参数|说明|
|-|-|
|-c|将要压缩的数据输出到屏幕上，可以通过数据流重定向处理得到的显示|
|-d|解压缩 bzip2 文件|
|-k|压缩后保留源文件|
|-v|显示压缩比|
|-z|压缩文件(默认值，可不添加该参数)|
|-#|压缩的等级，-1最快但是压缩比最差，-9最慢但是压缩比最好。默认为-6|

## xz 压缩命令与 xzcat/xzmore/xzless/xzgrep
用法: `xz [-cdklt#] 文件名`

|选项与参数|说明|
|-|-|
|-c|将要压缩的数据输出到屏幕上，可以通过数据流重定向处理得到的显示|
|-d|解压缩 xz 文件|
|-k|压缩后保留源文件|
|-l|列出压缩文件相关信息|
|-t|检验压缩文件|
|-#|压缩的等级，-1最快但是压缩比最差，-9最慢但是压缩比最好。默认为-6|

PS:
1. gzip/bzip2/xz 三个压缩命令，越往右压缩比越高，但是所花费时间越长(`time [gzip|bzip2|xz] -c services > services.[gz|bz2|xz]`)
2. gzip/bzip2/xz 三个压缩命令参数基本通用

---
# Linux 打包
在 Linux 中对于目录的压缩，是指对这个目录中所有的文件分别进行压缩，而不是像 Windows 那样将多个数据压缩成一个文件。因此如果想要在 Linux 中把多个数据压缩成一个文件，需要用到 `tar` 这个打包功能

## tar 基本命令
压缩: `tar [-z|-j|-J][cv] [-f 待建立的文件名] filename`
查询: `tar [-z|-j|-J][tv] [-f 现有的 tar 文件名]`
解压缩: `tar [-z|-j|-J][xv] [-f 现有的 tar 文件名] [-C 目录]`

|选项与参数|说明|
|-|-|
|-c|建立打包文件，可搭配 -v 来显示打包过程中的文件名|
|-t|查看打包文件的内容含有哪些文件名|
|-x|解压缩/解打包，可与 -C 搭配，在特定目录解压缩/解打包|
|注意!|-c、-t、-x 参数不能同时出现在同一 tar 命令中|
|-z|通过 gzip 压缩/解压缩，此时文件名为 *.tar.gz|
|-j|通过 bzip2 压缩/解压缩，此时文件名为 *.tar.bz|
|-J|通过 xz 压缩/解压缩，此时文件名为 *.tar.xz|
|注意!|-z、-j、-J 参数不能同时出现在同一 tar 命令中|
|-v|在压缩/解压缩过程中，显示正在处理的文件名|
|-f filename|-f 接要被处理的文件名|
|-C 目录|解压缩时如果想选定特定目录，可用此参数|
|-p|保留备份数据的权限与属性，常用于备份重要的配置文件|
|-P|保留绝对路径，即备份数据中可以含有根目录|
|--exclude=FILE|将 FILE 排除外，即压缩过程中不包括 FILE|
|--newer-mtime="time"|备份 mtime 比 time 时间的文件|

PS:
1. 如果文件仅仅是打包而没有压缩的话，那么文件称为 tarfile；如果文件打包时也压缩的话，那么文件称为tarball
2. 把文件备份到磁带机(/dev/st0)时，因为磁带是一次性读取/写入的装置，不能使用 `cp` 而要使用 `tar`，例如: `tar -cvf /dev/st0 /home /etc /root`

### 一些例子:
1. 压缩
* 备份 /etc，并保留权限与属性，保存到 /root
* * 利用 gzip 备份: `tar -zpcvf /root/etc.tar.gz /etc`
* * 利用 bzip 备份: `tar -jpcvf /root/etc.tar.bz2 /etc`
* * 利用 xz 备份: `tar -Jpcvf /root/etc.tar.xz /etc`

* 备份 /etc，保留权限、属性和绝对路径，保存到 /root
* * 利用 gzip 备份: `tar -zPpcvf /root/etc.tar.gz /etc`
* * 利用 bzip2 备份: `tar -jPpcvf /root/etc.tar.bz2 /etc`
* * 利用 xz 备份: `tar -JPpcvf /root/etc.tar.xz /etc`

2. 查看
* 查看备份的 /etc 文件，完整显示权限和属性: `tar -jtvf /root/etc.tar.bz2`
* 查看备份的 /etc 文件，仅查看文件名: `tar -ztf /root/etc.tar.gz`

3. 解压缩
* 解压缩备份的 /root/etc 到本地
* * 利用 gzip 解压缩: `tar -zxvf etc.tar.gz`
* * 利用 bzip2 解压缩: `tar -jxvf etc.tar.bz2`
* * 利用 xz 解压缩: `tar -Jxvf etc.tar.xz`

* 解压缩备份的 /root/etc 到指定的目录 /tmp
* * 利用 gzip 解压缩: 'tar -zxvf etc.tar.gz -C /tmp'
* * 利用 bzip2 解压缩: 'tar -jxvf etc.tar.bz2 -C /tmp'
* * 利用 xz 解压缩: `tar -Jxvf etc.tar.xz -C /tmp`

4. 解压缩单一文件
* 先找到文件名: `tar -ztvf etc.tar.gz | grep 'shadow'`
* 再利用 `tar -[z|j|J]xvf 压缩文件名 需解压文件名` 解压所需要的的文件: `tar -zxvf etc.tar.gz etc/shadow`

5. 压缩某个目录但是需要排除某些文件
* 利用 --exclude 参数，如使用 xz 备份 /root 与 /etc 但是不备份 /root 下的 /etc 与 自身: `tar -Jcvf /root/system.tar.xz --exclude=/root/etc --exclude=/root/system.tar.xz /etc /root`

6. 备份比某个时刻新的文件
* 利用 --newer 或 --newer-mtime 备份，其中 --newer 是包含 mtime 跟 atime , --newer-mtime 只包含 mtime
* * 先利用 `find /etc -newer /etc/passwd` 找出 mtime 比 /etc/passwd 新的文件
* * 再利用 `tar -zcvf /root/etc.mtine.new.than.passwd --newer-mtime"2020/8/29" /etc` 对 /etc 中 mtime 比2020/8/29新的文件进行备份
* * 最后进行比对，看通过 find` 找出来的文件是否存在于压缩包中

7. 特殊应用: 利用管线和标准输入输出
通过数据流重定向，实现利用 tar 一边压缩一边解压缩。其中，打包文件的名称跟解压缩的文件的名称变为了 - ，可以理解为在内存中有一块缓冲区代替了一个实体文件。在打包命令中的 - 代表标准输出(standard output)，在解压缩命令中的 - 代表标准输入(standard input)
* 将 /etc 整个目录一边打包一边在 /tmp 下解开: `tar -cvf - /etc | tar -xvf - /tmp`

---
# 备份
## XFS 文件系统备份: xfsdump
xfsdump 是用于 xfs 文件系统备份的命令，其备份类型可分为完整备份 (full backup) 和增量备份 (incremental backup)。完整备份即把整个文件系统完整的备份一次，而增量备份指下一次备份时，只会备份与上一次备份有差异的文件。xfsdump 把完整备份定义为 level0，往后每次备份，level数字+1。所有的 level 文件可在 /var/lib/xfsdump/inventory 中找到。参考如下图:

![centos7_dump-1.gif](https://i.loli.net/2020/10/25/6MZFbjapJGEq8Uz.gif)

如图所示，系统在运行过程中，数据会随时间变化而变化。当使用 xfsdump 进行进行备份时，第一次是完整备份(level0)，第二次是增量备份(level1)，并且只比较目前文件系统与 level0 的差异，备份差异文件，level2 与 level1 对比，以此类推。

xfsdump 注意事项:
* xfsdump 不能备份没有挂载的文件系统
* xfsdump 必须需要 root 权限进行(设计文件系统)
* xfsdump 只能备份 xfs 文件系统
* xfsdump 备份的数据只能通过 xfsrestore 解析
* xfsdump 是通过 UUID 来分辨备份档的，因此不能备份两个具有相同 UUID 的文件系统

用法: `xfsdump [-L S_label] [-M M_label] [-l#] [-I] [-f 备份文件名] 需要备份的文件系统`

|选项与参数|说明|
|-|-|
|-L|xfsdump 会记录每次备份的 session 标头，-L 后可以接针对此文件系统的简易说明|
|-M|xfsdump 可以记录储存媒体的标头，-M 后可以接针对储存媒体的简易说明|
|-l|小写的L，指定备份等级，有0-9共10个等级(预设为0，即完整备份)|
|-f|类似于 tar -f，接文件名或装置名|
|-I|从 /var/lib/xfsdump/inventory 列出目前备份的信息状态|

PS：
1. xfsdump 只能备份整个文件系统，不能单独备份某一个文件
2. 使用 `xfsdump` 命令备份文件系统时，如果不加上 -M 跟 -L 参数，会进入到交互模式，让你填写这两个label

一个把备份 /boot 备份到 /srv 的案例:
1. 先通过 `df-h /boot` 确保 /boot 为独立的 xfs 文件系统
2. 对 /boot 进行备份: `xfsdump -l 0 -M boot_all -L boot_all -f /srv/boot.bump /boot`
3. 备份完成后，通过 `xfsdump -I` 会观察到有一个 level0 的资料存在，因此可以进行增量备份
4. 在 /boot 中创建一个10M的 img 文件：`dd if=/dev/zero of=/boot/testing.img bs=1M count=10`
5. 对 /boot 进行增量备份: `xfsdump -l 1 -M boot_1 -L boot_1 -f /srv/boot.dump1 /boot`
6. 通过 `ll -h /srv/boot*` 发现新增了一个10M的文件，然后通过 `xfsdump -I` 发现 level1 信息的存在，增量备份成功

## xfs 文件系统备份还原: xfsrestore
查看已有备份: `xfsrestore -I`
单一文件复原: `xfsrestore [-f 备份文件] [-L S-label] [-s] 待复原目录`
累积备份文件复原: `xfsrestore [-f 备份文件] -r 待复原目录`
交互模式: `xfsrestore -i`

|选项与参数|说明|
|-|-|
|-I|跟 xfsdump -I 效果一致，输出的是已备份的资料|
|-f|接文件名，指已经备份了的文件，也可能是磁盘等(/dev/sr0)|
|-L|即 Session 的 Label name，可以用 -I 查询|
|-s|接某个特定的文件或目录，即仅复原某一个文件或目录|
|-r|如果以文件来存储备份数据，可以不需要这个参数。但是如果是一个磁盘内有多个文件，则需要这个参数|
|-i|进入交互模式，一般用不到|

## 一些案例:
1. 复原已有的 /boot 备份: 
* `xfsrestore -f /srv/boot.dump -L boot_all /boot` 或 `xfsrestore -f /srv/boot.dump /boot`

2. 复原已有的 /boot 备份到指定文件夹 /tmp/boot， 并比对两个文件夹之间的差异:
* `mkdir /tmp/boot && xfsrestore -f /srv/boot.dimp /tmp/boot`
* `diff -r /tmp/boot /boot` 比对两个文件夹发现有差异，即还原只会覆盖同名文件，其他新的文件不做修改

3. 还原 /boot 增量备份到 /tmp/boot，再比对两个文件夹:
* 增量备份还原与还原单一文件系统方法一致，只需从 level0 --> level1 --> level2 ... 一直还原即可
* `xfsrestore -f /srv/boot.dump1 /tmp/boot`
* `diff -r /tmp/boot /boot`

4. 仅复原备份文件中某一文档:
* 复原 /srv/boot.dump 中的 grub2 到 /tmp/boot2: `mkdir /tmp/boot2 && xfsrestore -f /srv/boot.dump -s grub2 /tmp/boot2`

5. xfsrestore 交互模式:
* xfsrestore 交互模式一般用于复原未知文件内容的备份档
* 进入交互模式，把文件恢复到 /tmp/boot3: `mkdir /tmp/boot3 && xfsrestore -f /srv/boot.dump -i /tmp/boot3`
* 交互模式详解: ![tempsnip6.png](https://i.loli.net/2020/10/31/1nvSLmp6QqGyEZO.png)

---
# 光盘制作工具
## 建立镜像文件: mkisofs
用法: `mkisofs [-o 镜像文件名] [-Jrv] [-V vol] [-m file] 需要备份的文件 -graft-point isodir=systemdir`

|选项与参数|说明|
|-|-|
|-o|接镜像文件名|
|-J|生成兼容 Windows 的镜像文件，可增加文件名长度到64个 Unicode 字符|
|-r|通过 Rock Ridge 生成支持 Unix / Linux 的文件数据，可以记录较多信息(如 UID / GID 等)|
|-v|显示 ISO 文件建立过程|
|-V vol|建立 Volume ，类似于 Windows 中的 CD title|
|-m file|接需要排除的文件，即不需要备份的文件，可用通配符|
|-graft-point isodir=systemdir|因为一般情况下，所有要被加到镜像文件中的文件都会被放置到镜像文件中的根目录。加上该参数，将 ISO 文件中的文件夹与 Linux 中的文件夹保持一致|

PS:
1. 制作 ISO 文件时最好加上 -r，不然的话会使用旧的 iso9660 格式(只支持 DOS 文件名，即文件名8个字符+3个扩展名字符)
2. 使用 -graft-point 参数时，等号左边是镜像文件内的目录，等号右边是实际目录
3. 想 ISO 文件根据目录进行刻录而不是直接把所有文件放根目录，除了用 -graft-point 外。还可以先把需要刻录的目录放在一个新的目录，然后直接刻录该新的目录

## 一些案例:
1. 不使用 -graft-point 刻录 /root /home /etc:
* `mkisofs -o /tmp/system.img -r -v /root /home /etc` 会发现出现了文件名冲突的错误，而且 /root /home /etc 文件均在 ISO 根目录，没有根据文件夹分类

2. 使用 -graft-point 刻录 /root /home /etc:
* `mkisofs -o /tmp/system.img -r -v -graft-point /root=/root /home=/home /etc=/etc`

---
# 其他常见的压缩与备份工具
## 直接读取磁盘装置内容的工具: DD
用法: `dd of="input_file" of="outputfile" bs="block_size" count="number"`

|选项与参数|说明|
|-|-|
|if|即input file，也可以是装置|
|of|即output file，也可以是装置|
|bs|规划一个 block 的大小，如果未指定，预设为 512 bytes|
|count|多少个 bs 的意思|

PS:
1. 使用 dd 对文件进行备份时，可以不输入bs，例如 `dd if=/etc/passwd of=/tmp/passwd.bak` 即备份 /etc/passwd 到 /tmp/passwd.bak 中
2. dd 进行备份时，是是一个一个扇区去读/写的，因此会把整个 if 信息抓下来输出到 of (包括superblock, boot sector, meta data 等等)
3. 如上所述，可以利用 dd 进行整个磁盘的复制，复制完成后，需要利用 `xfs_repair -L of` 修复一下。如果需要用到别的 UUID，需要重新生成，最后使用 `xfs_growfs of` 放大空间

## 可以备份任何东西的备份工具: cpio
备份用法: `cpio -ovcB > [file|device]`
还原用法: `cpio -ivcdu < [file|device]`
查看用法: `cpio -ivct < [file|device]`

|备份用到的选项与参数|说明|
|-|-|
|-o|将数据 copy 输出到文件或装置|
|-B|让预设的 Blocks 增加到 5120Bytes，预设为 512Bytes。在备份大文件时可以速度加快|

|还原用到的选项与参数|说明|
|-|-|
|-i|将数据从文件或装置 copy 到系统|
|-d|自动建立目录。使用 cpio 备份的数据不一定在同一层目录，因此加上 -d 在还原时让 cpio 建立新目录|
|-u|自动让新文件覆盖旧文件|
|-t|配合 -i 使用，查看以 cpio 建立的文件或装置内容|

|共享的选项与参数|说明|
|-|-|
|-v|让储存过程中文件名显示在屏幕上|
|-c|一种较新的 portable format 方式储存|

PS:
1. cpio 命令不会自动寻找备份文件，因此需要配合 find 等命令进行备份
2. 如上所述，请在需要备份的文件/目录下使用 find 命令而不是通过绝对/相对路径搜索文件/目录。因为 cpio 不会识别路径，如果使用了绝对路径，那么还原时会直接覆盖掉绝对路径的文件

## 一个案例: 通过 cpio 备份/还原 /boot 文件到 /tmp/boot.cpio
1. 先切换工作目录到 / : `cd /`
2. 找出 boot 文件夹并通过 cpio 备份到 /tmp/boot.cpio : `find boot | cpio -ocvB > /tmp/boot.cpio`
3. 还原 boot 文件到 /root : `cd root && cpio -id < /tmp/boot.cpio`
