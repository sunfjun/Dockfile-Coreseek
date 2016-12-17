# Dockfile-Coreseek

Coreseek 是一款中文全文检索/搜索软件，以 GPLv2 许可协议开源发布，基于 Sphinx 研发并独立发布，专攻中文搜索和信息处理领域，适用于行业/垂直搜索、论坛/站内搜索、数据库搜索、文档/文献检索、信息检索、数据挖掘等应用场景，用户可以免费下载使用

Docker 提供了一个可以运行你的应用程序的封套(envelope)，或者说容器。它原本是 dotCloud 启动的一个业余项目，并在前些时候开源了。它吸引了大量的关注和讨论，导致 dotCloud 把它重命名到 Docker Inc。它最初是用 Go 语言编写的，它就相当于是加在 LXC（LinuX Containers，linux 容器）上的管道，允许开发者在更高层次的概念上工作。

-
#需要创建个配置文件： `/path/sphinx/sphinx.conf`

```
################# sphinx config #######################
source search
{
	type = mysql
	sql_host = dbhost
	sql_user = dbname
	sql_pass = dbpass
	sql_db = db
	sql_port = 3306
	sql_query_pre = SET NAMES utf8
	sql_query_pre = SET SESSION query_cache_type=OFF
	sql_query = SELECT *,CASE WHEN `kind` = 'News' THEN 2 WHEN `kind` = 'Activity' THEN 1 WHEN `kind` = 'Service' THEN 0 END AS kind2 FROM searches
	sql_attr_uint = item_id
	sql_attr_uint = kind2
	sql_attr_timestamp = updated_at
	sql_attr_timestamp = created_at
	sql_ranged_throttle = 0
}

index search
{
	source = search
	path = /var/sphinx/data/search
	docinfo = extern
	mlock = 0
 	preopen = 1
	min_word_len = 1
	charset_type = zh_cn.utf-8
	charset_dictpath = /usr/local/etc/
	min_prefix_len = 0
	min_infix_len = 1
	ngram_len = 0
}

indexer
{
	mem_limit = 1024M
	write_buffer = 4M
}

searchd
{
	listen = 0.0.0.0:9312
	log = /var/sphinx/log/sphinx.log
	query_log = /var/sphinx/log/query.log
	read_timeout = 2
	max_children = 0
	pid_file = /var/run/sphinx.pid
	max_matches = 100000
	seamless_rotate = 1
	preopen_indexes = 0
	unlink_old = 1
	read_buffer = 8M
	compat_sphinxql_magics = 0
}
# EOF


```

#启动 `docker`

```

docker run --name sphinx -v /root/sphinx/sphinx:/usr/local/etc/sphinx -p 9312:9312 -i registry.cn-hangzhou.aliyuncs.com/ror/coreseek:latest

```

