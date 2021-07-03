# Linux LVM
LVM(Logical Volume Manager)：逻辑逻辑卷管理员。将几个实体的 partitions (或 disk) 透过软件组合成为一块看起来是独立的大磁盘 (VG) ，然后将这块大磁盘再经过分区成为可使用分区卷 (LV)，最终能够被挂载使用

## LVM 的PV, PE, VG, LV
### PV：Physical Volume, 物理卷
由实际的 partition 或 Disk 组成。需要先将其系统标识符 (system ID) 成为 8e (LVM 的标识符) 再进行
