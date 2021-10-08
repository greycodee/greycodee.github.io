---
title: fastDFS安装使用教程
top: false
cover: false
toc: true
mathjax: true
date: 2020-05-07 13:34:10
password:
summary:
keywords:
description:
tags:
- Linux
- fastDFS
categories:
- Linux
---

## FastDFS简介

FastDFS 是一个开源的高性能分布式文件系统（DFS）。 它的主要功能包括：文件存储，文件同步和文件访问，以及高容量和负载平衡。主要解决了海量数据存储问题，特别适合以中小文件（建议范围：4KB < file_size <500MB）为载体的在线服务。

FastDFS 系统有三个角色：跟踪服务器(Tracker Server)、存储服务器(Storage Server)和客户端(Client)。

- **Tracker Server**：跟踪服务器，主要做调度工作，起到均衡的作用；负责管理所有的 storage server和 group，每个 storage 在启动后会连接 Tracker，告知自己所属 group 等信息，并保持周期性心跳。

- **Storage Server**：存储服务器，主要提供容量和备份服务；以 group 为单位，每个 group 内可以有多台 storage server，数据互为备份。

- **Client**：客户端，上传下载数据的服务器，也就是我们自己的项目所部署在的服务器。

- 结构图![图片](http://xhh.dengzii.com/blog/20200507152801.webp)



- 上传文件流程![图片](http://xhh.dengzii.com/blog/20200507152857.webp)

## 安装环境

| 系统及软件版本        | Git开源地址                                   |
| --------------------- | --------------------------------------------- |
| Centos 7              | #                                             |
| libfastcommon V1.0.43 | https://github.com/happyfish100/fastdfs       |
| fastdfs V6.06         | https://github.com/happyfish100/libfastcommon |

> 我虚拟机装的Centos7的ip地址是172.16.54.137

## 安装前工作

### 关闭防火墙
> 为了方便，先关闭防火墙。线上环境安装可安装后开放对应端口。

```shell
service firewalld stop
```



### 下载所需安装包

- libfastcommon

```shell
wget https://github.com/happyfish100/libfastcommon/archive/V1.0.43.tar.gz -O libfastcommon.tar.gz
```

- fastDFS

```shell
wget https://github.com/happyfish100/fastdfs/archive/V6.06.tar.gz -O fastdfs.tar.gz
```



### 安装fastDFS环境

- 解压安装`libfastcommon`

```shell
tar -zxvf libfastcommon.tar.gz && cd libfastcommon-1.0.43/ && ./make.sh && ./make.sh install
```



## 安装fastDFS

### 解压安装

```shell
tar -zxvf fastdfs.tar.gz && cd fastdfs-6.06/ && ./make.sh && ./make.sh install
```
> 安装好fastDFS后，在`/etc/fdfs/`目录下会生成4个示例的配置文件
>
> - client.conf.sample	fastDFS客户端配置文件
> - storage.conf.sample
> - storage_ids.conf.sample    当storage超过1个时，可以用这个配置文件来配置管理
> - tracker.conf.sample


### 配置并启动Tracker

进入`/etc/fdfs/`复制一份`Tracker`配置文件，

```shell
cd /etc/fdfs/ && cp tracker.conf.sample tracker.conf
```



修改`tracker.conf`配置文件里的`base_path`目录

```shell
base_path=/data/fastdfs/tracker
```

创建对应的文件夹

```shell
mkdir -p /data/fastdfs/tracker
```



服务命令

```shell
#启动Tracker
service fdfs_trackerd start

#关闭Tracker
service fdfs_trackerd stop

#开机自启
systemctl enable fdfs_trackerd
```



### 配置并启动Storage

进入`/etc/fdfs/`复制一份`Storage`配置文件，

```shell
cd /etc/fdfs && cp storage.conf.sample storage.conf
```



修改`storage.conf`配置文件

```shell
base_path=/data/fastdfs/storage

#存放文件地址
store_path0=/data/fastdfs/file

#更改为你的tracker地址
tracker_server=172.16.54.137:22122
```



创建对应的文件夹

```shell
mkdir -p /data/fastdfs/storage && mkdir -p /data/fastdfs/file
```



服务命令

```shell
#启动Storage
service fdfs_storaged start

#关闭Storage
service fdfs_storaged stop

#开机自启
systemctl enable fdfs_storaged
```



### 上传文件测试

> 上传文件可以用他自带的客户端进行测试，使用客户端前，要复制一份`client.conf`并修改一下里面的内容

```shell
#复制一份客户端配置文件
cd /etc/fdfs && cp client.conf.sample client.conf
```



修改`client.config`配置文件

```shell
base_path=/data/fastdfs/client

#更改为你的tracker地址
tracker_server=172.16.54.137:22122
```



创建对应文件夹

```shell
mkdir -p /data/fastdfs/client
```



使用方法

```shell
/usr/bin/fdfs_upload_file /etc/fdfs/client.conf [filename]

#上传成功后返回
group1/M00/00/00/rBA2iV6yvU2AEXUfAAACGTXt3Kw94.yaml
```

![图片](http://xhh.dengzii.com/blog/20200506215501.png)

## 安装Nginx

> 为了方便，这里直接使用nginx的docker镜像来进行安装。docker安装请自行查找资料

首先创建一个文件夹，存放nginx的配置文件

```shell
#创建文件夹
mkdir -p /data/nginx
#进入文件夹并下载nginx配置文件
cd /data/nginx && wget http://xhh.dengzii.com/file/nginx.conf
```

> 配置文件已经修改过了，直接下载即可使用



然后运行docker命令（第一次运行会自动下载nginx镜像）

```shell
docker run -d -p 81:80 -v /data/nginx/nginx.conf:/etc/nginx/nginx.conf -v /data/:/data/ --name fastDFS-nginx nginx
```



然后就可以通过`http://ip:port/[filePth]`访问上传到fastDFS的文件了

```shell
#例如刚才上传的文件 可以通过如下地址访问
http://172.16.54.137:81/group1/M00/00/00/rBA2iV6yvU2AEXUfAAACGTXt3Kw94.yaml
```



## 拓展

这里只是示例了单机的fastDFS安装，一般fastDFS都是分布式安装的。具体可以通过下载这个结构图去进行安装。此时如果配置了多个group，则需要安装`fastdfs-nginx-module`这个nginx的模块。

![图片](http://xhh.dengzii.com/blog/20200507132841.png)