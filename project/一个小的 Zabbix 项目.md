## 背景
公司有多台 vm 处于人手监控状态，不定时出现各种各样问题，只能影响到业务后，业务部门反馈过来才能知道，因此想上 zabbix 对硬件进行(后续会研究软件)监控

## 需求
1. 监控方式: 通过 SNMP 进行监控，目前 Windows 上已经完成 snmp 配置。
2. 主机类型: 以 Windows 为主，有少量 Linux 跟 服务器
3. 特定主机出现问题通知相关管理人员
4. Zabbix LDAP 认证

## 准备工作
### 1. Zabbix 安装与配置
[Zabbix下载链接](https://www.zabbix.com/cn/download?zabbix=5.0&os_distribution=centos&os_version=7&db=mysql&ws=apache)

PS: 
1. 安装必须参考以上 zabbix 的链接
2. 配置时如果出现数据库无法连接，检查数据库 host

### 2. snmp 配置
#### zabbix 服务器 snmp 配置
1. 安装: `yum install net-snmp* -y`
2. 查看 SNMP community name: `vim /etc/snmp/snmpd.conf`
3. 检测 SNMP 连通性: `snmpwalk -v 2c -c public 'IP'`

### 3. 添加相对应人员
本次一共需要创建两类用户(管理员跟访问者，其中访问者不可登录前端)
![user.png](https://i.loli.net/2020/11/21/tN8gBUzslAKaYoR.png)

### 4. 配置自动发现
配置--->自动发现
通过 ICMP 进行自动发现，但不自动添加 host
![auto discover.png](https://i.loli.net/2020/11/21/JEWnmpPuh1HIfN8.png)

### 5. 开始手动添加主机
因为局域网中 IP 段包含其他设备(VM, 磁盘管理器等)，因此不进行自动添加
