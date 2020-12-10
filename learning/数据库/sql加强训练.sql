-- SQL 强化	
	-- 创建"京东"数据库
	create database if not exists jingdong default charset utf8;

	-- 使用"京东"数据库
	use jingdong;

	-- 创建一个商品goods数据表
	create table goods(
		id int unsigned not null auto_increment primary key,
		name varchar(150) not null,
		cate_name varchar(40) not null,
		brand_name varchar(40) not null,
		price decimal(10,3) not null default 0,
		is_show bit not null default 1,
		is_saleoff bit not null default 0
	);

	-- 向goods表中插入数据
	insert into goods values(0,'r510vc 15.6英寸笔记本','笔记本','华硕','3399',default,default); 
	insert into goods values(0,'y400n 14.0英寸笔记本电脑','笔记本','联想','4999',default,default);
	insert into goods values(0,'g150th 15.6英寸游戏本','游戏本','雷神','8499',default,default); 
	insert into goods values(0,'x550cc 15.6英寸笔记本','笔记本','华硕','2799',default,default); 
	insert into goods values(0,'x240 超极本','超级本','联想','4880',default,default); 
	insert into goods values(0,'u330p 13.3英寸超极本','超级本','联想','4299',default,default); 
	insert into goods values(0,'svp13226scb 触控超极本','超级本','索尼','7999',default,default); 
	insert into goods values(0,'ipad mini 7.9英寸平板电脑','平板电脑','苹果','1998',default,default);
	insert into goods values(0,'ipad air 9.7英寸平板电脑','平板电脑','苹果','3388',default,default); 
	insert into goods values(0,'ipad mini 配备 retina 显示屏','平板电脑','苹果','2788',default,default); 
	insert into goods values(0,'ideacentre c340 20英寸一体电脑 ','台式机','联想','3499',default,default); 
	insert into goods values(0,'vostro 3800-r1206 台式电脑','台式机','戴尔','2899',default,default); 
	insert into goods values(0,'imac me086ch/a 21.5英寸一体电脑','台式机','苹果','9188',default,default); 
	insert into goods values(0,'at7-7414lp 台式电脑 linux ）','台式机','宏碁','3699',default,default); 
	insert into goods values(0,'z220sff f4f06pa工作站','服务器/工作站','惠普','4288',default,default); 
	insert into goods values(0,'poweredge ii服务器','服务器/工作站','戴尔','5388',default,default); 
	insert into goods values(0,'mac pro专业级台式电脑','服务器/工作站','苹果','28888',default,default); 
	insert into goods values(0,'hmz-t3w 头戴显示设备','笔记本配件','索尼','6999',default,default); 
	insert into goods values(0,'商务双肩背包','笔记本配件','索尼','99',default,default); 
	insert into goods values(0,'x3250 m4机架式服务器','服务器/工作站','ibm','6888',default,default); 
	insert into goods values(0,'商务双肩背包','笔记本配件','索尼','99',default,default);

	-- 查询类型cate_name为超极本的商品名称、价格
	select name as 商品价格, price as 价格 from goods where cate_name="超级本";

	-- 显示商品的种类
	select distinct cate_name as 商品种类 from goods;
	select cate_name from goods group by cate_name;

	-- 求所有电脑产品的平均价格，并保留两位小数
	select round(avg(price),2) as 平均价格 from goods;

	-- 显示每种商品的平均价格
	select cate_name as 商品, round(avg(price), 2) as 平均价格 from goods group by cate_name;

	-- 查询每种类型的商品中最贵、最便宜、平均价、数量
	select cate_name as 商品, max(price) as 最高价, min(price) as 最低价, round(avg(price), 2) as 均价, count(name) as 数量 from goods group by cate_name;

	-- 查询所有价格大于平均价格的商品，并且按价格降序排序
	select * from goods where price>(select avg(price) from goods) order by price desc;

	-- 查询每种类中最贵的电脑信息
	select * from goods inner join (select cate_name, max(price) as max_price from goods group by cate_name) as goods_new_info on goods.cate_name=goods_new_info.cate_name and goods.price=goods_new_info.max_price;


-- 创建“商品分类”表
	--创建商品分类
	create table if not exists goods_cates(
	id int unsigned primary key auto_increment,
	name varchar(40) not null
	);

	-- 查询goods表中商品分类
	select cate_name from goods group by cate_name;

	-- 将分组结果写入到goods_cates数据表
	insert into goods_cates(name) select cate_name from goods group by cate_name;

	-- 同步表数据
	-- 通过goods_cates数据表来更新goods表
	update goods as g inner join goods_cates as gc on g.cate_name=gc.name set g.cate_name=gc.id;

	-- 修改表结构
	-- 修改 goods.cate_name 的表结构为 goods_cates.id 的表结构
	alter table goods change cate_name cate_id int unsigned not null;

	-- 外键
	-- 增加外键对 goods 的 cate_id 进行约束
	alter table goods add foreign key (cate_id) references goods_cates(id);


-- 创建“商品品牌表”表
	--用 create...select 创建商品品牌并写入数据
	--注意: 需要对brand_name 用as起别名，否则name字段就没有值
	create table if not exists goods_brands(
	id int unsigned primary key auto_increment,
	name varchar(40) not null) select brand_name as name from goods group by brand_name;

	-- 同步表数据
	-- 通过goods_cates数据表来更新goods表
	update goods as g inner join goods_brands as gb on g.brand_name=gb.name set g.brand_name=gb.id;

	-- 修改表结构
	-- 修改 goods.cate_name 的表结构为 goods_cates.id 的表结构
	alter table goods change brand_name brand_id int unsigned not null;

	-- 外键
	-- 增加外键对 goods 的 cate_id 进行约束
	alter table goods add foreign key (brand_id) references goods_brands(id);