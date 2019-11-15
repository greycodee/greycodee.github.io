---
title: Jenkins教程-搭建(Docker版)
top: true
cover: false
toc: true
mathjax: true
tags:
  - Jenkins
  - Docker
  - Linux
categories:
  - Jenkins
date: 2019-11-07 17:19:34
password:
summary:
---

## 目录

- [Jenkins教程-搭建(Docker版)](https://mjava.top/jenkins/build-jenkins-docker/)

- [Jenkins教程-创建Maven项目](https://mjava.top/jenkins/build-jenkins-mavne/)

- [Jenkins教程-Docker+GitLab持续部署持续集成](https://mjava.top/jenkins/build-jenkins-ci-cd/)

  

## 环境

- 主机：172.16.54.131

- 系统：Cnetos 7

## 安装Docker-CE

### 检查Docker

首先检查本机是否安装Docker，如果安装了直接跳过安装Docker步骤

```shell
docker -v
```

> 如果出现Docker version 19.03.4, build 9013bf583a类似的信息，则说明已安装Docker

### 安装

- 本教程以centos7安装方式说明，其他系统安装方式会有不同

执行以下命令，安装Docker

```shell
yum install -y yum-utils device-mapper-persistent-data lvm2

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
    
yum install docker-ce

service docker start

systemctl enable docker
```

- 第一条命令：为添加源做准备 使其支持存储
- 第二条命令：添加docker-ce软件源
- 第三条命令：安装docker-ce
- 第四条命令：启动docker服务
- 第五条命令：设置开启自启

## 安装Jenkins的Docker容器

### 创建文件夹

在创建容器前先在宿主机创建一个Jenkins的工作文件夹，用于持久化

```shell
mkdir /opt/jenkins     			//创建文件夹
chmod 7777 /opt/jenkins			//授予权限
```

> 该文件夹一定要给权限，不然docker容器访问不了，容器会创建失败。

### 拉取官方镜像

```shell
docker pull jenkins/jenkins:lts
```

### 启动容器

```shell
docker run -d -p 8080:8080 -p 50000:50000 -u root -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker -v /opt/jenkins:/var/jenkins_home -v /etc/localtime:/etc/localtime -e JAVA_OPTS=-Duser.timezone=Asia/Shanghai --restart=always --name jenkins jenkins/jenkins:lts
```

> 启动容器一定要用root用户进入docker容器，不然访问不了宿主机的docker服务。还有要挂载/var/run/docker.sock和$(which docker)这两个文件夹到容器，这样docker版的jenkins才可以用使用docker相关服务。 

### 查看容器日志

```shell
docker logs jenkins 
```

![log界面](https://mjava.top/img/jenkins_docker_logs_4345.png)
> 记下43455b344f904cf69a4af9e231f7d48d这个密码，等下要用到

## 初始化Jenkins

### 解锁

在浏览器访问172.16.54.131:8080这个地址，进入Jenkins的web界面。（如果访问不了，请开启防火墙的8080端口）

![jenkins界面](https://mjava.top/img/jenkins_web_sign_in_201911071359.png)

在输入框中填入刚才保存的密码

### 自定义

推荐直接选 安装推荐的插件

![Jenkins自定义界面](https://mjava.top/img/jenkins_setupwizard_1911071408.png)

### 安装插件

到这个界面等他安装完成，时间会长一点

![Jenkins安装插件](https://mjava.top/img/jenkins_191107141216.png)

> 如这个界面插件下载失败，直接点继续，进行下一步，具体解决办法可以看这个篇文章
>
> [Jenkins初始化界面插件安装失败解决方法](https://mjava.top/2019/11/07/technology/learningExperience/Linux/Jenkins/Jenkins%E5%88%9D%E5%A7%8B%E5%8C%96%E7%95%8C%E9%9D%A2%E6%8F%92%E4%BB%B6%E5%AE%89%E8%A3%85%E5%A4%B1%E8%B4%A5%E8%A7%A3%E5%86%B3%E6%96%B9%E6%B3%95/)



### 创建用户

设置你的登录账号和密码，然后点保存完成
![Jenkins创建用户](https://mjava.top/img/jenkins_20191107160016.png)

### 实例配置
默认直接点保存完成
![Jenkins实例配置](https://mjava.top/img/jenkins_20191107160056.png)

### 开始使用
点击开始使用Jenkins
![Jenkins开始使用](https://mjava.top/img/jenkins_20191107160129.png)

### Jenkins主界面
进入Jenkins主界面，到此教程结束
![Jenkins主界面](https://mjava.top/img/jenkins_20191107160204.png)

