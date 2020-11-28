-- 创建一个数据库的案例
	-- 创建一个数据库
	create database if not exists python_test charset=utf8;

	-- 使用数据库
	use python_test;

	-- 查看目前使用数据库
	select database();

	-- 创建数据表
	-- students 表
	create table students(
	id int unsigned not null auto_increment primary key,
	name varchar(20) default '',
	age tinyint unsigned default 0,
	height decimal(5,2),
	gender enum("男","女","中性","保密") default "保密",
	cls_id int unsigned default 0,
	is_delete bit default 0
	);

	-- classes 表
	create table classes(
	id int unsigned auto_increment not null primary key,
	name varchar(30) not null
	);

	-- 向 students 表中插入数据
	insert into students values
	(0,'小明',18,180.00,2,1,0),
	(0,'小月月',18,180.00,2,2,1),
	(0,'彭于晏',29,185.00,1,1,0),
	(0,'刘德华',59,175.00,1,2,1),
	(0,'黄蓉',38,160.00,2,1,0),
	(0,'凤姐',28,150.00,4,2,1),
	(0,'王祖贤',18,172.00,2,1,1),
	(0,'周杰伦',36,NULL,1,1,0),
	(0,'程坤',27,181.00,1,2,0),
	(0,'刘亦菲',25,166.00,2,2,0),
	(0,'金星',33,162.00,3,3,1),
	(0,'静香',12,180.00,2,4,0),
	(0,'郭靖',12,170.00,1,4,0),
	(0,'周杰',34,176.00,2,5,0);

	-- 向 classes 表中插入数据
	insert into classes values(0, "python_01期"),(0,"python_02期");


-- 查询
	-- 查询所有字段
	-- select * from 表名;
	select * from students;
	select * from classes;

	-- 查询指定字段
	-- select 列1，列2，…… from 表名;
	select id, name from students;

	-- 使用 as 给字段起别名
	-- select 字段 as 别名…… from 表名;
	select name as 姓名, age as 年龄 from students;

	-- 使用 as 给表起别名(用了表别名,那么使用 别名.字段 进行查询时必须用表别名)
	-- select 别名.字段…… from 表名 as 别名;
	select s.name as 姓名, s.age as 性别 from students as s;

	-- 消除重复行(去重)
	-- distinct 字段
	select distinct gender as 年龄 from students;


-- 条件查询
	-- 比较运算符
		-- select ... from 表名 where ...
		-- >
		-- 查询大于18岁的信息
		select * from students where age>18;

		-- <
		-- 查询小于18岁的信息
		select * from students where age<18;

		-- >=
		-- <=
		-- 查询小于或等于18岁的信息
		select * from students where age<=18;

		-- =
		-- 查询年龄为18岁的所有学生的信息
		select * from students where age=18;

		-- !=
		-- 查询年龄不为18岁的所有学生信息
		select * from students where age!=18;

	-- 逻辑运算符
		-- and
		-- 18到28之间所有学生的信息
		select * from students where age>18 and age<28;
		-- 18岁以上的女性
		select * from students where age>18 and gender=2;

		-- or
		-- 18岁以上或者身高超过180(包含)以上的所有学生信息
		select * from students where age>18 or height>=180;

		-- not
		-- 不在 18岁以上的女性 这个范围内的信息
		select * from students where not (age>18 and gender=2);
		-- 年龄不是少于18或等于18并且是女性的信息
		select * from students where not (age<=18) and gender=2;

	-- 模糊查询
		-- like 
		-- % 替换1个或多个
		-- _ 替换一个
		-- 查询姓名中 以 “小” 开始的名字
		select name from students where name like "小%";
		-- 查询字数为2的名字
		select name from students where name like "__";
		-- 查询字数为3的名字
		select name from students where name like "___";
		-- 查询字数至少为2的名字
		select name from students where name like "__%";

		-- rlike 正则
		-- 查询以 周 开始的姓名
		select name from students where name rlike "^周.*";
		-- 查询以 周 开头，以 伦 结尾的姓名
		select name from students where name rlike "^周.*伦$";

	-- 范围查询
		 -- in (1, 3, 6)表示在一个非连续的范围内
		 -- 查询 年龄为18、34的姓名
		 select name, age from students where age in (18, 34);

		 -- not in 非连续的范围之内
		 -- 年龄不是 18、34岁之间 的姓名
		 select name, age from students where not age in (18, 34);
		 select name, age from students where age not in (18, 34);

		 -- between ... and ... 表示在一个连续的范围内
		 -- 查询 年龄在18到34之间的信息
		 select name, age from students where age between 18 and 34;

		 -- not between ... and ... 表示不在一个连续的范围内
		 -- 查询 年龄不在18到34岁之间 的姓名
		 select name, age from students where age not between 18 and 34;
		 --失败select name, age from students where age not (between 18 and 34);

	-- 空判断
		-- 判断为空 is null
		-- 查询 身高为空 的姓名
		select name from students where height is null;

		-- 判断非空 is not null
		-- 查询 身高不为空 的姓名
		select name,height from students where height is not null;

	-- 排序
		-- 通过 order by 字段 [选项] 进行排序
		-- asc 从小到大排序，即升序，默认
		-- desc 从大到小排序，即降序

		-- 查询 年龄在18到34之间的男性，按照年龄从小到大排序
		select * from students where (age between 18 and 34) and gender=1;
		select * from students where (age between 18 and 34) and gender=1 order by age;
		select * from students where (age between 18 and 34) and gender=1 order by age asc;

		-- 查询 年龄在18到34之间的女性的身高，从高到矮排序
		select * from students where (age between 18 and 34) and gender=2 order by height desc;

		-- 当进行排序后出现相同字段，可以使用 order by 多个字段 [选项] 进行依次排序
		-- 查询 年龄在18到34之间的女性的身高，按从高到矮排序，如果身高相同，按id大小排序
		select * from students where (age between 18 and 34) and gender=2 order by height desc,id desc;
		-- 查询 年龄在18到34之间的女性的身高，按从高到矮排序，如果身高相同，按年龄大小排序，如果年龄相同，按id大小排序
		select * from students where (age between 18 and 34) and gender=2 order by height desc,age desc,id desc;
		-- 按照年龄从小到大，身高从高到矮排序
		select * from students order by age asc,height desc;


-- 聚合函数
	-- 总数
	-- count()
	-- 查询男性有多少人，女性有多少人
	select count(*) as 男性人数 from students where gender=1;
	select count(*) as 女性人数 from students where gender=2;

	-- 最大值
	-- max()
	-- 查询最大年龄
	select max(age) from students;
	-- 查询女性的最高身高
	select max(height) from students where gender=2;

	-- 最小值
	-- min()
	-- 查询男性的最小年龄
	select min(age) from students where gender=1;

	-- 求和
	-- sum()
	-- 计算所有人的年龄总和
	select sum(age) from students;

	-- 平均值
	-- avg()
	-- 计算平均年龄
	select avg(age) from students;
	-- 计算平均年龄 sum(age)/count(*)
	select sum(age)/count(*) from students;

	-- 四舍五入
	-- round(123.321, 1) 保留一位小数
	-- 计算所有人的平均年龄，保留两位小数
	select round(avg(age),2) from students;
	-- 计算所有男性的平均身高，保留两位小数
	select round(avg(height),2) from students where gender=1;


-- 分组(需要与聚合一起使用)
	-- group by
	-- 按照性别分组，查询所有的性别
	select gender from students group by gender;
	-- 失败: select * from students group by gender 因为分组后不能，标记每组的表示为gender，select * 时不能识别到从哪个 group 取
	-- 计算每种性别中的人数
	select gender,count(*) from students group by gender;
	-- 计算男性人数
	select gender,count(*) from students where gender=1 group by gender;

	-- group_concat()
	-- 显示组内信息
	-- 查询分组后每组姓名
	select gender, group_concat(name) from students group by gender;
	-- 查询分组后男性的姓名，年龄。身高，用 _ 分割
	select gender, group_concat(name,"_",age,"_",height) from students where gender=1 group by gender;

	-- having
	-- 对分组做条件判断
	-- 查询平均年龄超过30岁的性别以及名字
	select gender,group_concat(name),avg(age) from students group by gender having avg(age) > 30;
	-- 查询每组性别中的人数多于3个的信息
	select gender,count(*) from students group by gender having count(*)>3;


-- 分页
	-- limit start page,count
	-- limit (N-1)*M, M
	-- N 为第几页，M为每页个数
	-- limit 需要放在所有语句最后

	-- 限制查询出来的数据的个数为2
	select * from students limit 2;
	-- 查询前5个数据
	select * from students limit 0, 5;
	-- 查询ID为6-10的数据
	select * from students limit 5, 5;
	-- 每页显示2个，第1页;
	select * from students limit 0, 2;
	-- 每页显示2个，第2页;
	select * from students limit 2, 2;
	-- 每页显示2个，第3页;
	select * from students limit 4, 2;
	-- 每页显示2个，第4页;
	select * from students limit 6, 2;
	-- 按年龄从小到大排序，每页显示2个，显示第6页的信息
	select * from students order by age limit 10, 2;
	-- 查询性别为女的信息，按身高从大到小排序，只显示2个信息;
	select * from students where gender=2 order by height desc limit 0, 2;


-- 连接查询
	-- inner join ... on(内连接/交集)
	-- select ... from 表A inner join 表B
	select * from students inner join classes;
	-- 查询有对应班级的学生的信息，并列出对应班级
	select * from students inner join classes on students.cls_id=classes.id;
	-- 按需求显示姓名、班级
	select students.name, classes.name from students inner join classes on students.cls_id=classes.id;
	-- 给数据表起名
	select s.name, c.name from students as s inner join classes as c on s.cls_id=c.id;
	-- 查询 有对应班级的学生的所有信息，但是只显示班级名称
	select s.*, c.name from students as s inner join classes as c on s.cls_id=c.id;
	-- 在以上查询中，班级姓名显示在第一列
	select c.name, s.* from students as s inner join classes as c on s.cls_id=c.id;
	-- 查询 有对应班级的学生的所有信息，按照班级进行排序，同班级按id排序
	select c.name, s.* from students as s inner join classes as c on s.cls_id=c.id order by c.name, s.id;

	-- left join(左链接，以左边的表为准)
	-- 查询每个学生对应的班级信息
	select s.*, c.name from students as s left join classes as c on s.cls_id=c.id;
	-- 查询没有对应班级信息的学生
	select s.*, c.name from students as s left join classes as c on s.cls_id=c.id having c.name is null;

	-- right join(右链接，以右边的表为准)
	-- 查询每个学生对应的班级信息
	select c.name, s.* from classes as c right join students as s on c.id=s.cls_id;


-- 自关联查询(多用于查询一表中的上下级)
	-- 在同一个表中查询山东省有哪些市
	select * from areas as province inner join areas as city on province.id=city.pid having province.atitle="山东省";


-- 子查询
	-- 查询身高最高的男生信息
	select * from students where height=(select max(height) from students) and gender=1;