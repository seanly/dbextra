# MySQL Replication


## 配置文件

配置分为 session （可以省略） 和 global 级别

```
show VARIABLES like '%max_allowed_packet%';
```

## binlog 相关操作

### sql 相关指令
```
# 是否启用binlog日志
show variables like 'log_bin';

# 查看binlog的目录
show global variables like "%log_bin%";

# 查看当前服务器使用的biglog文件个数及大小
show binary logs;

# 查看最新一个binlog日志文件名称和Position
show master status;

# 事件查询命令
## IN 'log_name' ：指定要查询的binlog文件名(不指定就是第一个binlog文件)
## FROM pos ：指定从哪个pos起始点开始查起(不指定就是从整个文件首个pos点开始算)
## LIMIT [offset,] ：偏移量(不指定就是0)
## row_count ：查询总条数(不指定就是所有行)
show binlog events [IN 'log_name'] [FROM pos] [LIMIT [offset,] row_count];

# 查看具体一个binlog文件的内容 （in 后面为binlog的文件名）
show binlog events in 'master.000003';

#分页显示、过滤日志
pager less
pager grep "drop"

# 设置binlog文件保存事件，过期删除，单位天
set global expire_log_days=3; 

# 删除当前的binlog文件
reset master; 

# 删除slave的中继日志
reset slave;

# 删除指定日期前的日志索引中binlog日志文件
purge master logs before '2019-03-09 14:00:00';

# 删除指定日志文件
purge master logs to 'master.000003';

```

### mysqlbinlog 命令

```
# 查看bin-log二进制文件（shell方式）
mysqlbinlog -v --base64-output=decode-rows /data/3306/binlog/mysql-bin.000005

# 查看bin-log二进制文件（带查询条件）
mysqlbinlog -v --base64-output=decode-rows /data/3306/binlog/mysql-bin.000005 \
    --start-position="5000"    \
    --stop-position="20000"    \
    --start-datetime="2021-05-01 08:01:00"  \
    --stop-datetime="2012-03-10 08:20:00"

# 临时不记录binlog日志
set sql_log_bin=0;

#实时拉取远程主机binlog文件中的数据
mysqlbinlog  -R --host=10.0.0.52 --user=mha --password=mha --raw  --stop-never mysql-bin.000003 

```
