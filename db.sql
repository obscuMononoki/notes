--连接数据库
mysql -uroot -proot

--设置字符集
set names gbk;

--库操作-----------------------
--查
	--查看所有库
	show databases;
	--查看一个库的创建语句
	show create database mysql;
--增
    create database student;
    create database teacher charset gbk;
--修改
    alter database teacher charset utf8;
--删除
    drop database teacher;

--进入库-----------------------
   	use student;

--表操作------------------------
	--查
		--查所有表
		show tables;
		--查看表结构
		desc student_info;
		--查看表的创建结构
		show create table student_info;
	--增
	create table student_info(
		student_id int primary key auto_increment,
		student_name varchar(20) not null,
		student_gender enum('男','女','人妖'),
		student_hobby set('coding','dancing','singing'),
		student_wechat varchar(30) unique key,
		student_salary decimal(6,2),
		grad_time date
	);
	--改
		--改表名
		alter table student_info rename student_infos;
		--改数据类型
		alter table student_info modify student_id tinyint;
		--改字段 一定加上数据类型
		alter table student_info change student_name student_names char(20);
		--添加字段
		alter table student_info add student_age tinyint;
		alter table student_info add student_address varchar(30) after student_gender;
        alter table student_info add student_ids tinyint first;
        --删除字段
        alter table student_info drop student_ids;
        --修改表的字符集
        alter table student_info charset gbk;
	--删
	drop table student_info;

 --数据操作----------------------------
   --增  
   	  --插入一条数据
	  insert into student_info values 
	  (null,'xiaobai','男','coding,singing','xiaobai',7000.00,'2018-01-01');
   	  --一次插入多条数据
	  insert into student_info values 
	  (null,'xiaohei','男','coding','xiaohei',7000.00,'2018-01-01'),
	  (null,'xiaohong','女','coding','xiaohong',7000.00,'2018-01-01');
   --查
      --查询所有数据
      select * from student_info;
      --根据条件查询
      select * from student_info where student_id = 1;
   --改
      update student_info set student_name = 'xiaohuang' where student_id = 1;
   --删
      delete from student_info where student_id = 2;
      delete from student_info;
      -- truncate 删除表，又重新创建了一张新表
      truncate student_info;


--高级查询 [where] [group by] [having] [order by] [limit]  顺序不能改变
      
   where       根据条件查询
   group by    分组 （体会分组是为了统计）
   having      分组之后再查询

   order by    排序  升序 asc   降序 desc
   limit       查询显示条数

查询每组价格最大值大于3000的组