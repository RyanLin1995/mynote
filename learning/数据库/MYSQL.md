## MYSQL
MySQL 是一个关系型数据库管理系统。关联数据库将数据保存在不同的表中，而不是将所有数据放在一个大仓库内，这样就增加了速度并提高了灵活性。

## MYSQL 存储引擎
1. MyISAM: MySQL 5.0 之前的默认数据库引擎，最为常用。拥有较高的插入，查询速度，但不支持事务.
2. InnoDB: 事务型数据库的首选引擎，支持ACID事务，支持行级锁定, MySQL 5.5 起成为默认数据库引擎.
3. BDB: 源自 Berkeley DB，事务型数据库的另一种选择，支持Commit 和 Rollback 等其他事务特性
4. Memory: 所有数据置于内存的存储引擎，拥有极高的插入，更新和查询效率。但是会占用和数据量成正比的内存空间。并且其内容会在 MySQL 重新启动时丢失
5. Merge: 将一定数量的 MyISAM 表联合而成一个整体，在超大规模数据存储时很有用
6. Archive: 非常适合存储大量的独立的，作为历史记录的数据。因为它们不经常被读取。Archive 拥有高效的插入速度，但其对查询的支持相对较差
7. Federated: 将不同的 MySQL 服务器联合起来，逻辑上组成一个完整的数据库。非常适合分布式应用
8. Cluster/NDB: 高冗余的存储引擎，用多台数据机器联合提供服务以提高整体性能和安全性。适合数据量大，安全和性能要求高的应用
9. CSV: 逻辑上由逗号分割数据的存储引擎。它会在数据库子目录里为每个数据表创建一个 .csv 文件。这是一种普通文本文件，每个数据行占用一个文本行。CSV 存储引擎不支持索引。
10. BlackHole: 黑洞引擎，写入的任何数据都会消失，一般用于记录 binlog 做复制的中继
11. EXAMPLE: 存储引擎是一个不做任何事情的存根引擎。它的目的是作为 MySQL 源代码中的一个例子，用来演示如何开始编写一个新存储引擎。同样，它的主要兴趣是对开发者。EXAMPLE 存储引擎不支持编索引。另外，MySQL 的存储引擎接口定义良好。有兴趣的开发者可以通过阅读文档编写自己的存储引擎。

## MYSQL 数据类型
常用数据类型如下：
* 整数：int，bit
* 小数：decimal
* 字符串：varchar,char
* 日期时间: date, time, datetime
* 枚举类型(enum)

特别说明的类型如下：
* decimal表示浮点数，如decimal(5,2)表示共存5位数，小数占2位
* char表示固定长度的字符串，如char(3)，如果填充'ab'时会补一个空格为'ab '
* varchar表示可变长度的字符串，如varchar(3)，填充'ab'时就会存储'ab'
* 字符串text表示存储大文本，当字符大于4000时推荐使用
* 对于图片、音频、视频等文件，不存储在数据库中，而是上传到某个服务器上，然后在表中存储这个文件的保存路径

使用数据类型的原则是：够用就行，尽量使用取值范围小的，而不用大的，这样可以更多的节省存储空间

详细参考<https://blog.csdn.net/anxpp/article/details/51284106>

### 类型详解
#### 数值类型:
|类型|字节大小|有符号范围|无符号范围|
|-|-|-|-|
|TINYINT|1|-128 ~ 127|0 ~ 255|
|SMALLINT|2|-32768 ~ 32767|0 ~ 65535|
|MEDIUMINT|3|-8388608 ~ 8388607|0 ~ 16777215|
|INT/INTEGER|4|-2147483648 ~2147483647|0 ~ 4294967295|
|BIGINT|8|-9223372036854775808 ~ 9223372036854775807|0 ~ 18446744073709551615|

#### 字符串类型:
|类型|字节大小|示例|
|-|-|-|
|CHAR|0-255|类型:char(3) 输入'ab', 实际存储为'ab ', 输入'abcd' 实际存储为'abc'|
|VARCHAR|0-255|类型:varchar(3) 输'ab',实际存储为'ab', 输入'abcd',实际存储为'abc'|
|TEXT|0-65535|大文本|

#### 日期时间类型:
|类型|字节大小|示例|
|-|-|-|
|DATE|4|'2020-01-01'|
|TIME|3|'12:29:59'|
|DATETIME|8|'2020-01-01 12:29:59'|
|YEAR|1|'2017'|
|TIMESTAMP|4|'1970-01-01 00:00:01' UTC ~ '2038-01-01 00:00:01' UTC|

## MYSQL 约束
* 主键 primary key：物理上存储的顺序
* 非空 not null：此字段不允许填写空值
* 惟一 unique：此字段的值不允许重复
* 默认 default：当不填写此值时会使用默认值，如果填写时以填写为准
* 外键 foreign key：对关系字段进行约束，当为关系字段填写值时，会到关联的表中查询此值是否存在，如果存在则填写成功，如果不存在则填写失败并抛出异常

## MYSQL 安装
### Deepin apt 安装
1. 先确定是否有安装 MYSQL: `apt list --installed | grep 'mysql'`
2. 安装 MariaDB (因为为了后续升级需要，且 Deepin 软件库没有 MYSQL ，所以直接用 MariaDB 替代): `apt install mariadb-server`

- [ ] ### Deepin 源码安装 

### Centos yum/dnf 安装
1. 先确保是否有安装 MYSQL: ` yum list installed | grep 'mysql'`
2. 安装 MYSQL: `yum/dnf install mysql-server`

- [ ] ### Centos 源码安装 

## 初始化 MYSQL : 
1. 验证 MYSQL 是否安装完成: `mysqladmin -V`
2. 初始化 MYSQL : `mysql --initialize`
3. 获取随机生成的 root 密码: `cat /var/log/mysql/mysqld.log |grep 'password'`
4. 修改文件夹拥有者为 MYSQL: `chown mysql:mysql -R /var/lib/mysql`
5. 修改 root 密码: `mysqladmin -uroot -p 'old_password' password 'new_password'` 或 创建 root 密码: `mysqladmin -u root password "password"`
6. 开机 MYSQL 服务: `systemctl start mysql.services`
7. 登录 MYSQL: `mysql -h 'hostname' -u root -p `

## 关闭数据库: 
`mysqladmin -u root -p shutdown`

## MYSQL 用户设置:
1. 登录 MYSQL: `mysql -uroot -p`
2. 选择数据库: `use 'database'`
3. 创建用户: `create 'username'@'host' identified by 'password';` 或 `create user 'username' identified by 'password';`
4. 修改密码: `ALTER USER 'root'@'localhost' IDENTIFIED BY 'NEW_PASSWORD';` 或 `UPDATE mysql.user SET authentication_string = md5('MY_NEW_PASSWORD') WHERE User = 'root' AND Host = 'localhost';`
5. 单独授予权限: `grant select, insert, update, delete, create, drop on 'databasename'.'tablename' to 'user'@'host' identified by 'password';`
6. 针对某用户单独授予某数据库权限: `grant all privileges on database.* to 'user'`
7. 授予全部权限: `grant all privileges on *.* to 'user'@'%' identified by 'password';`
8. 授予全部权限并使用户有权限授权别人权限: `grant all privileges on *.* to 'user'@'%' identified by 'password' with grant option;`
9. 撤销权限: `revoke all privileges from 'user';`
10. 删除用户: `drop user 'user';`
11. 生效: `flush privileges;`
12. 查看用户: `select user, host from user;`

## MYSQL 数据库相关:
1. 查看数据库: `show databases;`
2. 创建数据库: `create database 'databasename';`
3. 创建数据库2: `create database if not exists 'databasename' default charset utf8 collate utf8_general_ci;`
4. 显示数据库创建过程: `show create database 'databasename';`
5. 创建指定编码的数据库: `create database 'databasename' charset=utf8;`
6. 删除数据库: `drop database 'databasename';`
7. 创建/删除需要转移的数据库: `create/drop database `\`databasename\`;
8. 查看当前数据库: `select database();`

## MYSQL 其他命令:
1. 显示时间: `select now();`
2. 显示当前版本: `select version();`

## MYSQL 数据表格相关
### 创建表:
1. 查看数据表: `show tables;`
2. 创建数据表: `create table 'tablename'('field(字段) type(类型) constraint(约束)','field(字段) type(类型) constraint(约束)')` 
   * 例子1: `create table test(id int primary key not null auto_increment,name varchar(30));`
   * 例子2: 
![捕获5.PNG](https://i.loli.net/2020/11/11/qGeoDFIUPbNtg8Z.png)
3. 查看数据表表头信息: `desc 'tablename';`
4. 查看数据表创建过程: `show create table 'tablename';`
5. 插入数据: `insert into 'tablename' values('value');`
   * 例子: 
![捕获6.PNG](https://i.loli.net/2020/11/11/Jbc3Zzw92aDk1gB.png)
6. 查看表格信息: `select * from 'tablename';`

### 修改表:
1. 添加字段: `alter table 'tablename' add 'columnname' 'type';`
   * 例: `alter table students add birthday datetime;`
2.1 修改字段(重命名版): `alter table 'tablename' change 'old columnname' 'new columnname' 'type and constraint';`
   * 例: `alter table students change birthday birth datetime not null;`
2.2 修改字段(不重命名版): `alter table 'tablename' modify 'columnname' 'type and constraint';`
   * 例: `alter table students modify birth date not null;`
3. 删除字段: `alter table 'tablename' drop 'colunmname';`
   * 例: `alter table students drop birthday;`