## 修改密码的方法
### 方法一: set password 命令
1. 登录 mysql: `mysql -uroot -p`
2. 修改密码: `set password for root@localhost = password('new_password');`

### 方法二: mysqladmin 命令
`mysqladmin -uroot -p 'old_password' password 'new_password'`

### 方法三: 直接 update user表
1. 登录 MYSQL: `mysql -uroot -p`
2. 选择 MYSQL 数据库: `use mysql`
3. update user 表: `update user set password=password('new_password') where user='root' and host='localhost';`
4. 刷新数据库: `flush privileges;`

## 重置 MYSQL/ MariaDB 密码的方法:
1. 验证 MYSQL/MariaDB 版本: `mysql -V`
2. 停止服务: `systemctl stop mariadb.service/mysqld.service`
3. 以免登录模式开启 MYSQL/MariaDB: `mysqld_safe --skip-grant-tables &`
4. 新建一个窗口，登录 MYSQL: `mysql -uroot`
5. * MYSQL 5.7.6 跟 MariaDB 10.1.20 版本后重置密码方法: `ALTER USER 'root'@'localhost' IDENTIFIED BY 'NEW_PASSWORD';` 或 `UPDATE mysql.user SET authentication_string = PASSWORD('MY_NEW_PASSWORD') WHERE User = 'root' AND Host = 'localhost';`
   * MYSQL 5.7.6 跟 MariaDB 10.1.20 版本前重置密码方法: `SET PASSWORD FOR 'root'@'localhost' = PASSWORD('MY_NEW_PASSWORD');`
6. 刷新数据库: `FLUSH PRIVILEGES;`