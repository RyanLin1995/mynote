## 什么是数据库
数据库是一个特殊的文件，可以永久保存数据。由多个表组成。主要使用两种类型的数据库：关系型数据库、非关系型数据库。表中的列称为字段，字段中能够唯一标记某个字段的，就是主键；表中的行称为记录。数据库中的表互为相关的话，称为关系型数据库。MYSQL属于关系型数据库

## 什么是RDBMS 
RDBMS(Relational Database Management System):关系型数据库管理系统，通过SQL语句(Structured Query Language)通信，一般为 c/s 格式主要产品: 
1. oracle: 以前的大型项目中使用，银行，电信等 
2. MYSQL：web 时代使用最广泛的关系型数据库 
3. ms sql server: 在微软的项目中使用
4. sqlite: 轻量级数据库，用于移动平台

## 什么是SQL语句
SQL(Structured Query Language): 结构化查询语言，是一种用来操作RDBMS的数据库语言，当前关系型数据库都支持SQL语言
SQL语句主要分为:
* DQL：数据查询语言，用于对数据进行查询，如select
* DML：数据操作语言，对数据进行增加、修改、删除，如insert、udpate、delete
* TPL：事务处理语言，对事务进行处理，包括begin transaction、commit、rollback
* DCL：数据控制语言，进行授权与权限回收，如grant、revoke
* DDL：数据定义语言，进行数据库、表的管理等，如create、drop
* CCL：指针控制语言，通过控制指针完成表的操作，如declare cursor
PS:SQL语句不区分大小写