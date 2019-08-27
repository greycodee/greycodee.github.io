---
title: JDK时区问题
top: false
cover: false
toc: true
mathjax: true
tags:
  - Java
  - Linux
categories:
  - technology
  - dailyIssue
  - Linux
date: 2019-08-27 15:26:30
password:
summary:
---


今天碰到一个大坑，弄了快一个小时才解决掉；

一个管理台后端服务，用docker隔离了三个容器，oracle,nginx,tomcat;后发现管理台查出来的时间和现实时间相差8个小时，一查是linux时区问题；

---

* 于是改之,三台容器都输入一下代码

```shell
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

测试了一下，发现问题docker容器的时区是正确了，可是问题并未得到解决，数据库时间还是慢了8个小时。

---

* 于是又查资料，换另外一种设置时区的方法；

```shell
vi /etc/sysconfig/clock
```

在里面输入如下内容

```shell
ZONE="Asia/Shanghai"
UTC=false
ARC=false
```

保存，重启，测试。。。。。发现还是一样,快疯了

---

* 第三种方法，设置TZ环境变量

> 设置环境变量可以在设置系统级别的/etc/profile  ,也可以设置用户级别的home目录的.bashrc。由于用的是docker，防止变量重启失效，只能在.bashrc里设置。在.bashrc加入如下内容：

```shell
export TZ='CST-8'
```

保存：然后执行

```shell
source .bashrc
```

使设置立即生效。

重启容器，测试，发现时间正常了。。。。哈哈哈哈

---

## 总结

上面问题出在jdk的new Date()方法，所以只要设置jdk所在的那个docker容器的变量就可以，不用每个都设置。jdk的new Date()方法每次调用都会去取环境变量TZ的时区，TZ是TimeZone的缩写，容器内部操作系统并未指定时区（TimeZone）信息，系统默认使用世界标准时（UTC+0),所以导致new Date()出来的数据存库会比当前时间慢8个小时；
