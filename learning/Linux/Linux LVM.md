# Linux LVM
LVM(Logical Volume Manager)：逻辑逻辑卷管理员。将几个实体的 partitions (或 disk) 透过软件组合成为一块看起来是独立的大磁盘 (VG) ，然后将这块大磁盘再经过分区成为可使用分区卷 (LV)，最终能够被挂载使用

## LVM 的PV, PE, VG, LV
### PV：Physical Volume, 物理卷
由实际的 partition 或 Disk 组成。需要先将其系统标识符 (system ID) 成为 8e (LVM 的标识符) 再使用 `pvcreate` 指令将其转成 LVM 最底层的物理卷 (PV)

### VG：Volume Group，卷组
VG 由众多 PV 组成，即上边所说的 LVM 大磁盘。

### LV：Logical Volume，逻辑卷
由 VG 分割而成，即最终的可被格式化与挂载的分区。容量大小与 PE 有关

### PE：Physical Extent，基本物理单元
整个 LVM 最小存储区块，类似于文件系用的 block 

### LVM 实际创建流程
![LVM创建流程](https://linux.vbird.org/linux_basic/centos7/0420quota/centos7_lvm.jpg)

* LVM 的写入模式有以下两种
  1. 线性模式 (linear)：假如将 /dev/vda1, /dev/vdb1 这两个 partition 加入到 VG 当中，并且整个 VG 只有一个 LV 时，所谓的线性模式就是：当 /dev/vda1 的容量用完之后，/dev/vdb1 的硬盘才会被使用到，这也是LVM的默认模式。
  2. 交错模式 (triped)：将一笔数据拆成两部分，分别写入 /dev/vda1 与 /dev/vdb1 ，类似于 RAID 0 。即一份数据用两颗硬盘来写入，理论上读写的效果会比较好。

* PS：LVM 最主要的用处是在实现一个可以弹性调整容量的文件系统上，而不是在建立一个具有容灾的文件系统

## 常用的 LVM 部署命令
|功能/命令|物理卷管理|卷组管理|逻辑卷管理|
|-|-|-|-|
|扫描|pvscan|vgscan|lvscan|
|建立|pvcreate|vgcreate|lvcreate|
|显示|pvdisplay|vgdisplay|lvdisplay|
|删除|pvremove|vgremove|lvremove|
|扩展|vgextend|lvextend|
|缩小|vgreduce|lvreduce|

## 创建和管理 LVM
### 创建：
1. PV 阶段：
   1. 使用 `pvcreate 设备名称` 创建 PV
   2. 创建完成后可以使用 `pvscan` 跟 `pvdispaly` 查看创建结果
2. VG 阶段：
   1. 使用 `vgcreate [-s N[mgt]] VG名称 PV名称` 创建 VG，其中 -s 为设置 PE size 的参数，可接容量(M,G,T)
   2. 创建完成后可以使用 `vgscan` 跟 `vgdispaly` 查看创建结果
3. LV 阶段：
   1. 使用 `lvcreate [-L N[mgt]]/[-l N] [-n LV 名称] VG 名称` 创建 LV，其中 -L 后接容量而 -l 后接 PE 个数。-n 为 LV 的名字
   2. 创建完成后可以使用 `lvscan` 跟 `lvdispaly` 查看创建结果

### 管理：
#### 放大容量：
放大容量准确来说是放大 LV 的容量，其有三个前置条件：
1. 所在 VG 需要有剩余的容量
2. 所在 LV 可以产生更多的可用容量
3. 文件系统可以放大（因为最终目的是）