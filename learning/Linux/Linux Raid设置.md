# Linux RAID 设置命令：mdadm
用法：
查询：`mdadm --detail /dev/md[*]`
创建：`mdadm --create /dev/md[0-9] --auto=yes --level=[015] --chunk=NK \
> --raid-devices=N --spare-devices=N /dev/sdx /dev/hdx...`
