## 1. Linux 下的链接档: 软链接和硬链接
### 实体链接，硬式链接或实际链接: Hard Link
Hard Link: 通过索引节点链接。在同一 filesystem 下增加一笔文件名链接到某 inode 号码。即同一 inode 拥有不同文件名。目录只能在同一 filesystem 下进行文件之间的链接，不能用于目录之间的链接。如果删除了硬链接源文件，硬链接文件依旧存在，因此硬链接最大作用是安全。此外，不论对源文件还是硬链接文件进行编辑，所有数据均会被更改。硬链接不占用 block 与 inode，只是在目录所在的 block 增加一条关联记录

硬链接案例: 建立 /root/crontab 与 /etc/crontab 的硬链接
1. `ll -i /etc/crontab` 查看 /etc/crontab inode，以及链接数(目前为1)
2. 在 /root 下 `ln /etc/crontab .` 建立硬链接
3. `ll -i /root/crontab` 和 `ll -i /etc/crontab` 查看两者 inode 一致，链接数为2

图解:
![hard_link1.gif](https://i.loli.net/2020/09/26/LGYpSafJXq1ENRd.gif)

PS:
1. 案例中链接数变为2的原因是，因为两者建立的是硬链接，inode、权限和文件属性完全一致，即两者为相同的文件。因此进入这个文件的入口有两个，所以链接数变为2. 硬链接不能链接目录的原因是，硬链接目录时需要对目录下所有文件或目录同时进行硬链接，即父目录(/..)也会做链接，如果进行多重处理，可能出现死结状况；同时也可能出现一个目录下出现好几个父目录存在，因此不建议做目录的硬链接

### 符号链接、软链接，即快捷方式: Symbolic Link
Symbolic link: 建立一个独立的文件，这个文件会让数据的读取指向它 link 的那个文件的文件名，类似于 Windows 下的快捷方式。软链接就是一个普通文件，只是数据块内容有点特殊。软链接可对文件或目录创建。但是当源文件删除后，软链接文件就无法打开。软链接作用是方便管理和节省空间。因为软链接是普通文件，因此占用 inode 和 block

软链接案例: 在 /root 下建立 /etc/crontab 的软链接
1. `ln -s /etc/crontab crontab2` 建立软链接
2. `ll -i /etc/crontab` 和 `ll -i /root/crontab` ，发现 /root/crontab 的大小为12， 指向 /etc/crontab

图解:
![symbolic_link1.gif](https://i.loli.net/2020/09/26/xOUvgRo5t7azE2L.gif)

PS:
1. 案例中 /root/crontab 的大小为12，是因为它的软链接源文件共12个字符

---
## 2. 制作链接档命令: ln
用法: `ln -sf 来源文件 目标文件'

|选项与参数|说明|
|-|-|
|-s|如果仅是使用`ln`，则建立的是硬链接，加上-s 建立的就是软链接|
|-f|如果目标文件已存在，就主动将目标文件移除后再建立|



