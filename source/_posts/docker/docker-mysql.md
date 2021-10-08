---
title: Docker下安装mysql并设置用户权限
top: false
cover: false
toc: true
mathjax: true
categories:
  - Docker
tags:
  - Docker
  - Mysql
  - Linux
date: 2019-09-03 15:58:46
password:
summary:
---

## 环境

* Ubuntu18.04

* Docker19.03.1

* Mysql5.7

  

## Docker

### 拉取镜像

  Docker拉取镜像默认是从DockerHub上面拉取，上面有各厂商提供的优质官方镜像，可以直接拉取使用。或者也可以用DockerFile自定义构建你自己的镜像。

```shell
sudo docker pull mysql:5.7			//拉取镜像到本地
```

注：上面mysql:5.7指的是拉取5.7版本的mysql，如果不加直接写mysql的话默认是拉取mysql的最新版本。

![拉取镜像](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/oFZqBjP.png)

如果显示上面这样，说明已经拉取好了。

### 查看镜像

```shell
sudo docker images		//查看本地镜像
```

![查看本地镜像](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/mkAm9SV-20211008161729338.png)



### 创建容器

#### 创建

```shell
sudo docker run -d -p 3306:3306 --name mysql5.7 -e MYSQL_ROOT_PASSWORD=root mysql:5.7
```

* -d       指定容器运行于后台
* -p       端口映射   主机端口:容器端口
* --name    自定义容器名字，方便记忆，不设置的话会随机生产
* -e        容器环境变量

![创建容器](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/sd6nZMU.png)

创建好的话会显示一串随机生产的id

#### 查看创建好的容器

```shell
sudo docker ps -a
```

* -a        显示所有创建好的容器，如果不加只显示正在运行的容器

![查看容器](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/Gr8w9zg.png)

## Mysql

### 进入容器

```shell
sudo docker exec -it mysql5.7 bash
```

* -i        打开STDIN，用于控制台交互
* -t        分配tty设备，该可以支持终端登录

![进入容器](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/UWZaGF2.png)

### 登录mysql

```shell
mysql -uroot -p
```

注：然后输入刚才创建容器时的密码，就是MYSQL_ROOT_PASSWORD这个参数

### 创建测试数据库

```sql
create database test;
```

### 创建mysql用户

```sql
create user 'zmh'@'%' identified by 'zmh';
```

注："%"表示可以任意ip访问

### 切换mysql用户

```sql
alter user 'zmh' identified by 'zmh';
```

### 授权

授权test库的所有表的所有权限给zmh用户

```sql
grant all privileges on test.* to 'zmh'@'%';
```

### 刷新权限

```sql
flush privileges;
```

退出mysql命令行

```sql
exit
```

### 客户端连接测试

![进入容器](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/kvMGl3Z.png)

成功！



## 附加

如果要重启mysql的话，不用进容器里面，直接重启容器就可以

* sudo docker start mysql5.7       启动mysql5.7容器
* sudo docker stop mysql5.7        停止mysql5.7容器
* sudo docker restart mysql5.7   重启mysql5.7容器