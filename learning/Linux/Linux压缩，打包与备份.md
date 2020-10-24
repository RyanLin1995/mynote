## 1. Linux 压缩
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

### gzip 压缩命令和 zcat/zmore/zless/zgrep
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

### bzip2 压缩命令与 bzcat/bzmore/bzless/bzgrep
用法: `bzip2 [-cdkvz#] 文件名`

|选项与参数|说明|
|-|-|
|-c|将要压缩的数据输出到屏幕上，可以通过数据流重定向处理得到的显示|
|-d|解压缩 bzip2 文件|
|-k|压缩后保留源文件|
|-v|显示压缩比|
|-z|压缩文件(默认值，可不添加该参数)|
|-#|压缩的等级，-1最快但是压缩比最差，-9最慢但是压缩比最好。默认为-6|

### xz 压缩命令与 xzcat/xzmore/xzless/xzgrep
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
## 2. Linux 打包
在 Linux 中对于目录的压缩，是指对这个目录中所有的文件分别进行压缩，而不是像 Windows 那样将多个数据压缩成一个文件。因此如果想要在 Linux 中把多个数据压缩成一个文件，需要用到 `tar` 这个打包功能

### tar 基本命令
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

#### 一些例子:
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

4.解压缩单一文件
* 先找到文件名: `tar -ztvf etc.tar.gz | grep 'shadow'`
* 再利用 `tar -[z|j|J]xvf 压缩文件名 需解压文件名` 解压所需要的的文件: `tar -zxvf etc.tar.gz etc/shadow`

5. 压缩某个目录但是需要排除