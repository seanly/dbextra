# MySQL Replication

## 插件加载方式

- stage1: 注释 plugin 配置，启动（初始化阶段）
- stage2: 停止容器
- stage3: 开启 plugin 配置，启动（正常服务）

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

## 主从配置

### 初始搭建场景

```sql
# master Node

# create myrepl user
GRANT REPLICATION SLAVE,REPLICATION CLIENT ON *.* TO "myrepl"@"%" IDENTIFIED BY "lperym";
FLUSH PRIVILEGES;

# show master status
SHOW MASTER STATUS

# 获取 binlog 文件和位置（Pos）

# slave Node: 

CHANGE MASTER TO MASTER_HOST='<mysql-ip>', MASTER_USER='myrepl', MASTER_PASSWORD='lperym', MASTER_LOG_FILE='<binlog-path>', MASTER_LOG_POS=<number>;
START REPLICA;

```

使用 GTID模式 

```bash

CHANGE MASTER TO MASTER_HOST='<mysql-ip>', MASTER_USER='myrepl', MASTER_PASSWORD='lperym', MASTER_AUTO_POSITION =1 ;
START REPLICA;

```


### 新增主从场景

```bash

# 备份实例
mysqldump -u root -p$MYSQL_ROOT_PASSWORD --all-databases --single-transaction --master-data=2 --flush-logs > full.sql

# 获取 binlog 文件和位置（Pos），因为--master-data=2参数
head -n 20 full.sql 

# 在新实例上恢复
mysql -u root -p$MYSQL_ROOT_PASSWORD < full.sql

```

```sql
# 然后配置主从

show processlist;
show slave status;

# 清理 slave 信息
STOP REPLICA;
reset master;
reset slave all;

# 开启只读模式，或者 read_only=1
set global read_only=1;
show global variables like  '%read_only%';

STOP REPLICA io_thread;
# 一定要确保出现 Slave has read all relay log，才能继续往下运行。

CHANGE MASTER TO MASTER_HOST='<master-ip>', MASTER_PORT=3306, MASTER_USER='myrepl', MASTER_PASSWORD='lperym', MASTER_LOG_FILE='<binlog-path>', MASTER_LOG_POS=<number>;
START SLAVE;
```

## xtrabackup 

### 备份

```bash
# 全量备份，备份目录为full，其中使用了压缩（--compress，压缩是针对里面的文件，而非对输出目录进行打包压缩）
xtrabackup --backup --compress --target-dir=full --host=mysql --port=3306 --user=root --password=${MYSQL_ROOT_PASSWORD}

# 增量备份，是基于全量备份的增量数据，所以需要提供--incremental-basedir=/path/to/full/data/
xtrabackup --backup --compress --target-dir=$dest/incrementals/$today --incremental-basedir=$dest/full --host=mysql --port=3306 --user=root --password=${MYSQL_ROOT_PASSWORD}

# 如果备份被压缩，再回复是需要解压，全量备份和增量备份命令相同
xtrabackup --decompress --target-dir=/path/to/compress/data/
```



```sql
# 创建备份用户
CREATE USER 'bakusr'@'127.0.0.1' identified by 'bakusr123';
GRANT SELECT,LOCK TABLES,SHOW VIEW,TRIGGER,EVENT,RELOAD,LOCK TABLES,BACKUP_ADMIN,PROCESS,REPLICATION CLIENT ON *.* TO 'bakusr'@'127.0.0.1';
FLUSH PRIVILEGES; 
```

### 恢复

```bash

#1. 预处理
# 基于全量备份进行恢复 
xtrabackup --prepare --target-dir=/data/compressed/

# 基于全量+增量进行恢复

xtrabackup --prepare --apply-log-only --target-dir=/data/backups/base # 或者
xtrabackup --prepare --apply-log-only --target-dir=/data/backups/base \
  --incremental-dir=/data/backups/inc1

#2. 恢复备份
xtrabackup --copy-back --target-dir=/data/backups/

#3. 更新权限
chown -R mysql:mysql /var/lib/mysql
```

## 权限

```sql

# 权限配置

# 创建账号和权限
GRANT ALL PRIVILEGES ON *.* TO admin@'%' IDENTIFIED BY "admin321";
FLUSH PRIVILEGES;

# 权限回收
REVOKE DELETE ON *.* FROM 'admin'@'%';
FLUSH PRIVILEGES;
DROP USER 'admin'@'%';
```
