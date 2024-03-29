## MySQL 主从同步的定义
主从同步使得数据可以从一个数据库服务器复制到其他服务器上，在复制数据时，一个服务器充当主服务器(master)，其余的服务器充当从服务器(slave)。因为复制是异步进行的，所以从服务器不需要一直连接着主服务器，从服务器甚至可以通过拨号断断续续地连接主服务器。通过配置文件，可以指定复制所有的数据库，某个数据库，甚至是某个数据库上的某个表。
使用主从同步的好处：
* 通过增加从服务器来提高数据库的性能，在主服务器上执行写入和更新，在从服务器上向外提供读功能，可以动态地调整从服务器的数量，从而调整整个数据库的性能。
* 提高数据安全，因为数据已复制到从服务器，从服务器可以终止复制进程，所以，可以在从服务器上备份而不破坏主服务器相应数据
* 在主服务器上生成实时数据，而在从服务器上分析这些数据，从而提高主服务器的性能

## 主从同步的机制
Mysql服务器之间的主从同步是基于二进制日志机制，主服务器使用二进制日志来记录数据库的变动情况，从服务器通过读取和执行该日志文件来保持和主服务器的数据一致。
在使用二进制日志时，主服务器的所有操作都会被记录下来，然后从服务器会接收到该日志的一个副本。从服务器可以指定执行该日志中的哪一类事件(例如只插入数据或者只更新数据)，默认会执行日志中的所有语句。
每一个从服务器会记录关于二进制日志的信息：文件名和已经处理过的语句，这样意味着不同的从服务器可以分别执行同一个二进制日志的不同部分，并且从服务器可以随时连接或者中断和服务器的连接。
主服务器和每一个从服务器都必须配置一个唯一的ID号（在my.cnf文件的[mysqld]模块下有一个server-id配置项），另外，每一个从服务器还需要通过CHANGE MASTER TO语句来配置它要连接的主服务器的ip地址，日志文件名称和该日志里面的位置(这些信息存储在主服务器的数据库里)

图示:
![5009863-865d52a5f616a52d.jpg](https://i.loli.net/2020/12/15/3cpJYe6igGk2fPn.jpg)

## 配置主从同步的基本步骤
有很多种配置主从同步的方法，可以总结为如下的步骤：
1. 在主服务器上，必须开启二进制日志机制和配置一个独立的ID
2. 在每一个从服务器上，配置一个唯一的ID，创建一个用来专门复制主服务器数据的账号
3. 在开始复制进程前，在主服务器上记录二进制文件的位置信息
4. 如果在开始复制之前，数据库中已经有数据，就必须先创建一个数据快照（可以使用mysqldump导出数据库，或者直接复制数据文件）
5. 配置从服务器要连接的主服务器的IP地址和登陆授权，二进制日志文件名和位置

## 配置方法
### 主数据库执行备份命令
备份: `mysqldump -uroot -p --all-databases --lock-all-tables > ~/master_db.sql`

PS：
1. --all-databases: 导出所有数据库
2. --lock-all-tables: 把所有数据表上锁，禁止修改

### 复制数据库备份文件 SQL 到从服务器并导入
复制: `scp ~/master_db.sql 用户名@主机地址:~/`
导入: `mysqldump -uroot -p` 然后 `source ~/master_db.sql`

### 修改配置文件
MariaDB 配置文件: /etc/mysql/mariadb.conf.d/50-server.cnf
Mysql8.0 配置文件: /etc/my.cnf.d/mysql-server.cnf

1. 在主数据库 [mysqld] 添加 server-id=1 跟 log_bin=mysql-bin 或 log_bin=/var/log/mysql/mysql-bin.log

2. 在从数据库 [mysqld] 添加 server-id=2 跟 log_bin=mysql-bin 或 log_bin=/var/log/mysql/mysql-bin.log

3. 重启服务: `systemctl restart mysql.service`

### 主数据库创建同步账号
创建账号: `grant replication slave on *.* to 'salve'@'%' identified by 'salve';`
刷新权限: `flush privileges;`

### 获取主数据库二进制日志信息
获取信息: `show master status;`

其中 File 作为日志名称，Position 作为日志文件位置

### 在从数据库中链接主数据库
命令: `change master to master_host="主服务器IP地址", master_user="用户名", master_password="密码", master_log_file="主服务器 status 中的File", master_log_pos=主服务器 status 中的Position;`

### 在从服务器开始同步并查看同步情况
启动同步: `start slave;`
查看同步情况命令: `show slave status \G`