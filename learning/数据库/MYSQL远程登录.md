## 远程登录
用法: `mysql -u用户名 -p -h主机IP`

### MariaDB
1. 修改 /etc/mysql/mariadb.conf.d/50-server.cnf 中的 bind-addr，将其注释掉
2. 创建用户: `grant 权限 on 数据库.表格名 to '用户名'@'%' identified by '密码';`

### MySQL
1. 创建用户: `create user '用户名'@'%' identified by '密码';`
2. 授权: `grant 权限 on 数据库.表格名 to '用户名'@'%';`

PS:
1. 如果远程不上，请检查防火墙

## 免密登录并修改密码(!)
### MariaDB
1. 修改 /etc/mysql/mariadb.conf.d/50-server.cnf 中的 [mysqld]，将skip-grant-tables 注释掉
2. 重启服务: `systemctl restart mysql.services`
3. 修改密码: `UPDATE mysql.user SET authentication_string = md5(密码) WHERE User = 用户名 AND Host = 主机名;`

### MySQL
1. 修改 /etc/my.cnf.d/mysql-server.cnf 中的 [mysqld]，将skip-grant-tables 注释掉
2. 重启服务: `systemctl restart mysql.services`
3. 修改密码: `UPDATE mysql.user SET authentication_string = md5(密码) WHERE User = 用户名 AND Host = 主机名;`