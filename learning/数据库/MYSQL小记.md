## 修改密码的方法
### 方法一: set password 命令
1. 登录 mysql: `mysql -uroot -p`
2. 修改密码: `set password for root@localhost = password('new_password');`

### 方法二: mysqladmin 命令
`mysqladmin -uroot -p 'old_password' password 'new_password'`

### 方法三: 直接 update user表
1. 登录 MYSQL: `mysql -uroot -p`
2. ``