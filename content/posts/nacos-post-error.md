---
title: Nacos报[NACOS HTTP-POST]
top: false
cover: false
toc: true
mathjax: true
date: 2019-11-14 23:50:58
password:
summary:
tags:
  - Nacos
categories:
  - Java
---

## 问题

　由于项目使用阿里的Nacos来管理项目的配置文件，今天所有使用Nacos的项目的日志都报[NACOS HTTP-POST] The maximum number of tolerable server reconnection errors has been reached这个错误。

## 解决方法

　查阅资料后说是连接超过了最大重试次数。Nacos有个maxRetry这个配置参数，默认是3;可是和SpringCloud整合后在application文件中找不到这个参数，只好另寻方法；

　由于项目都是Docker容器化的，先前出现过连接不到Nacos的问题,于是就查看了各个Docker容器的IP。

### 修正Nacos的地址

　查阅后发现，是因为同事吧服务器重启了一遍，导致Docker服务也重启了，然后Docker容器里的IP全部都变了。因为同一台服务器上我们各个容器间的访问是通过Docker容器内部IP的，也就是172.16.x.x这个IP段。所以导致访问不到报错。

```properties
spring.cloud.nacos.config.server-addr=172.16.X.X     //更改到最新nacos的地址
```