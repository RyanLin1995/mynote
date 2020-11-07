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

### 方法四: 