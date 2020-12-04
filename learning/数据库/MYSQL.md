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
1. 先确定是否有安装 MYSQL: `apt list --installed | grep mysql`
2. 安装 MariaDB (因为为了后续升级需要，且 Deepin 软件库没有 MYSQL ，所以直接用 MariaDB 替代): `apt install mariadb-server`

- [ ] ### Deepin 源码安装 

### Centos yum/dnf 安装
1. 先确保是否有安装 MYSQL: ` yum list installed | grep mysql`
2. 安装 MYSQL: `yum/dnf install mysql-server`

- [ ] ### Centos 源码安装 

## 初始化 MYSQL : 
1. 验证 MYSQL 是否安装完成: `mysqladmin -V`
2. 初始化 MYSQL : `mysql --initialize`
3. 获取随机生成的 root 密码: `cat /var/log/mysql/mysqld.log |grep password`
4. 修改文件夹拥有者为 MYSQL: `chown mysql:mysql -R /var/lib/mysql`
5. 修改 root 密码: `mysqladmin -uroot -p 旧密码 password 新密码` 或 创建 root 密码: `mysqladmin -u root password 密码`
6. 开机 MYSQL 服务: `systemctl start mysql.services`
7. 登录 MYSQL: `mysql -h 主机名 -u 用户名 -p `

## 关闭数据库: 
`mysqladmin -u 用户名 -p shutdown`

## MYSQL 用户设置:
1. 登录 MYSQL: `mysql -uroot -p`
2. 选择数据库: `use 数据库名`
3. 创建用户: `create 用户名@主机名 identified by 密码;` 或 `create user 用户名 identified by 密码;`
4. 修改密码: `ALTER USER 用户名@主机名 IDENTIFIED BY 密码;` 或 `UPDATE mysql.user SET authentication_string = md5(密码) WHERE User = 用户名 AND Host = 主机名;`
5. 单独授予权限: `grant select, insert, update, delete, create, drop on 数据库名.表名 to 用户名@主机 identified by 密码;`
6. 针对某用户单独授予某数据库权限: `grant all privileges on 数据库名.* to user`
7. 授予全部权限: `grant all privileges on *.* to 用户名@% identified by 密码;`
8. 授予全部权限并使用户有权限授权别人权限: `grant all privileges on *.* to 用户名@% identified by 密码 with grant option;`
9. 撤销权限: `revoke all privileges from 用户名;`
10. 删除用户: `drop user 用户名;`
11. 生效: `flush privileges;`
12. 查看用户(先use mysql): `select user,host from user;`

## MYSQL 数据库相关:
1. 查看数据库: `show databases;`
2. 创建数据库: `create database 数据库名;`
3. 创建数据库2: `create database if not exists 数据库名 default charset utf8 collate utf8_general_ci;`
4. 显示数据库创建过程: `show create database 数据库名;`
5. 创建指定编码的数据库: `create database 数据库名 charset=utf8;`
6. 删除数据库: `drop database 数据库名;`
7. 创建/删除需要转移的数据库: `create/drop database 数据库名;`
8. 查看当前数据库: `select database();`

## MYSQL 其他命令:
1. 显示时间: `select now();`
2. 显示当前版本: `select version();`
3. 查看引擎: `show engines;`

## MYSQL 数据表格相关
### 创建表:
1. 查看数据表: `show tables;`
2. 创建数据表: `create table 表名(field(字段) type(类型) constraint(约束),field(字段) type(类型) constraint(约束))` 
   * 例子1: `create table test(id int primary key not null auto_increment,name varchar(30));`
   * 例子2: 
![捕获5.PNG](https://i.loli.net/2020/11/11/qGeoDFIUPbNtg8Z.png)
3. 查看数据表表头信息: `desc 表名;`
4. 查看数据表创建过程: `show create table 表名;`
5. 查看表格信息: `select * from 表名;`

### 修改表:
1. 添加字段: `alter table 表名 add 类名 类型和约束;`
   * 例: `alter table students add birthday datetime;`
2.1 修改字段(重命名版): `alter table 表名 change 旧列名 新列名 类型和约束;`
   * 例: `alter table students change birthday birth datetime not null;`
2.2 修改字段(不重命名版): `alter table 表名 modify 列名 类型和约束;`
   * 例: `alter table students modify birth date not null;`
3. 删除字段: `alter table 表名 drop 列名;`
   * 例: `alter table students drop birthday;`
4. 修改表名称: `alter table 旧表名 rename 新表名;`

### 删除表:
1. 删除数据表: `drop table 表名;`

## MYSQL 数据相关:
即数据的增删改查(curd): 创建(create),更新(update),读取(Retrieve),删除(delete)

### 查询:
1. 查询表格所有内容: `select * from 表名;`
2. 根据条件查询表格所有内容: `select * from 表名 where 列=数据;`
3. 只查询表格特定内容: `select 列1,列2 from 表名;`
4. 查询表格特定类容并设定别名(哪个 column 在前先显示哪个 column): `select 列1 as name1, 列2 as name2 from 表名;`

### 增加:
1. 插入数据: `insert into 表名 values(数据);`
   * 例子: 
![捕获6.PNG](https://i.loli.net/2020/11/11/Jbc3Zzw92aDk1gB.png)
2. 部分插入数据: `insert into 表名(列1, 列2) values(列1数据,列2数据);`
   * 例子:
![捕获7.PNG](https://i.loli.net/2020/11/13/E7D5JNdg8VySO26.png)
3. 多次插入: `insert into 表名(列1, 列2) values(列1数据,列2数据),(列1数据,列2数据);`
   * 例子:
![捕获8.PNG](https://i.loli.net/2020/11/13/jR62Dlym9NPn5Z3.png)

### 修改(update):
1. 修改全部数据: `update 表名 set 列1=列1数据, 列2=列2数据;`
   * 例子:
![捕获.PNG](https://i.loli.net/2020/11/14/qfMBJPb6xDtwIsv.png)
2. 根据条件修改数据: `update 表名 set 列1=列1数据 where 列=数据;`
   * 例子:
![捕获2.PNG](https://i.loli.net/2020/11/14/WGPmagX5hkvIlTq.png)

### 删除(delete):
1. 物理删除整个表的数据: `delete from 表名;`
2. 物理删除表中特定数据: `delete from 表名 where column=data;`
3. 逻辑删除表中数据(即给表格添加一个 bit column, 默认为0, 删除为1, 显示数据是只显示 bit column 为0的): 
3.1 设置逻辑删除字段: `alter table 表名 add 删除列名称 bit default 0;`
3.1 进行逻辑删除: `update 表名 set 删除列名称=1`;

## MySQL 导出与导入:
导出:
1. 数据库和表结构的导出: `mysqldump -uroot -p 数据库名 > 文件绝对路径.sql`
2. 只导出数据表的表结构: `mysqldump -uroot -p -d 数据库名 > 文件绝对路径.sql`

导入:
1. 直接导入数据库: `mysql -uroot -p < 文件绝对路径.sql`
2. 使用 source 导入:
2.1 创建数据库: `create database if not exists 数据库名 charset=utf8;`
2.2 导入数据库: `source 文件绝对路径.sql;`

## 外键:
* 外键: 即将别的表的主键作为该表的值。作用为防止无效信息的插入
* 外键约束: 对数据的有效性进行验证
* 关键字: foreign key,只有innodb数据库引擎支持外键约束
* 外键的命令:
1. 外键添加: `alter table 表1 add foregin key (表1column) references 表2(column)`
   * 如把 goods_brands 表中的 id 作为 goods 表中的 brand_id 的外键: `alter table goods add foreign key (brand_id) references goods_brands(id)`
2. 查看表中是否有外键存在: `show create table 表名;`
3. 取消外键: `alter table 表名 drop foreign key 外键名称`