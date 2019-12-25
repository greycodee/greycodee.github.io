---
title: Docker迁移根目录导致mysql权限问题
top: false
cover: false
toc: true
mathjax: true
date: 2019-12-20 15:04:16
password:
summary:
keywords:
description:
tags:
- Mysql
- Pit
- Docker
- Linux
categories:
- Docker
---

## 问题描述

　　最近由于公司服务器硬盘老是爆满，导致经常要清硬盘空间．最后发现/var/lib/docker目录占了25G,以前分kvm分区的时候，他们分了两个区：根目录＂/＂,和＂/home＂目录，发现home目录使用几乎为零，于是准备迁移Docker的根目录：

迁移根目录我看的是这个文章：[docker的存储目录迁移](https://www.cnblogs.com/insist-forever/p/11739207.html),　不过迁移的时候我没有使用<font color=orange>rsync</font>这个命令，而是使用<font color=orange>cp -R</font>;

文件复制过去后，按照教程，重新启动docker服务，可是其中mysql容器跑不起来了，报mysqld: Can't create/write to file '/tmp/ibTCv7Rw' (Errcode: 13 - Permission denied)

![](http://cdn.mjava.top/20191220143818.png)



期间按照网上的方法：说docker容器启动是添加--privileged=true,设置/tmp目录的权限，关闭selinux，这些方法<font color=orange>都没用！！！！！！</font>

> 其中设置/tmp文件权限这个方法，我把里面的/tmp文件挂载出来后，设置了权限，报这个的问题是解决了，可是又出现了新的问题，又报Version: '5.7.27'  socket: '/var/run/mysqld/mysqld.sock' 
>
> ![](http://cdn.mjava.top/20191220144523.png)

看来还是得从根源上解决问题啊！

## 我的解决办法

​        我想，既然是权限问题，那肯定是复制文件的时候权限丢失了，于是查了下cp命令保持权限的命令（cp -p）:

![](http://cdn.mjava.top/20191220144841.png)

于是我又重新关闭的docker服务，然后删除了所有复制到home文件的目录，重新用<font color=orange>cp -p -R /var/lib/docker /home/docker/lib/</font>来重新复制了文件；

复制后，重启docker服务，启动docker容器，ok,一切正常；用docker info查看，看到已成功转移到/home下．![](http://cdn.mjava.top/20191220145849.png)

