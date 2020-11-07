## 修改密码的方法
### 方法一: set password 命令
1. 登录 mysql: `mysql -uroot -p`
2. 修改密码: `set password for root@localhost = password('new_password')`