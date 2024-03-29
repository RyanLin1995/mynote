## MySQL视图
对于复杂的查询，往往是有多个数据表进行关联查询而得到，如果数据库因为需求等原因发生了改变，为了保证查询数据的准确性，就需要对设计的查询语句进行修改，维护起来非常麻烦。使用视图可以解决这一问题。

视图是对若干张基本表的引用，视图所得到的是一张虚拟的表，是利用查询语句(select)执行的结果，不存储具体的数据(基本表数据发生了改变，视图也会跟着改变)

特点:
方便操作，特别是查询操作，减少复杂的SQL语句，增强可读性；

注意:
视图只能查询，不能增删改

## 视图相关命令
1. 定义视图: `create view 视图名称 as select 语句;`
2. 查看视图: `show tables;`
3. 使用视图: `select * from 视图名称;`
4. 删除视图: `drop view 视图名称;`
5. 视图demo: `create view v_goods_info as select g.*,c.name,b.name from goods as g left join goods_cates as c on c.id=g.cate_id left join goods_brands as b on b.id=g.brand_id;`
![图像 1.png](https://i.loli.net/2020/12/10/Ha7EIA5OCWtDbSm.png)
6. 视图的作用:
    * 提高了重用性
    * 对数据库重构，却不影响程序的运行
    * 提高了安全性能，可以对不同的用户
    * 让数据更加清晰