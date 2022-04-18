---
title: Jenkins教程-创建Maven项目
top: true
cover: false
toc: true
mathjax: true
tags:
  - Jenkins
categories:
  - Jenkins
date: 2019-11-12 17:26:19
password:
summary:
---

## 目录

- [Jenkins教程-搭建(Docker版)](https://mjava.top/jenkins/build-jenkins-docker/)

- [Jenkins教程-创建Maven项目](https://mjava.top/jenkins/build-jenkins-mavne/)

- [Jenkins教程-Docker+GitLab持续部署持续集成](https://mjava.top/jenkins/build-jenkins-ci-cd/)



## 前期准备

本教程是和gitlab集成,所以要有gitlab仓库。注意：如果后期要弄自动部署的话,你Jenkins的地址gitlab必须能访问到。不然gitlab监听到事件就通知不了Jenkins了；

### 环境

- Centos 7
- Jenkins(Docker版)

### 所需插件

> 除了搭建Jenkins时安装的插件,还需安装的插件

- [Maven Integration](https://plugins.jenkins.io/maven-plugin)

### 安装Maven

点击侧边栏的Manage Jenkins,然后点击Global Tool Configuration,进入全局工具设置
![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191112105932.png)


然后找到Maven,点击Add Maven,可以选择你要的Maven版本，然后设置一个名字。点击保存

![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191112110029.png)
![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191112110130.png)



### 创建Git登录凭证
点击侧边栏的凭证，然后按图点击
![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191112111043-20211009110702592.png)
![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191112111058-20211009110708086.png)
![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191112111115-20211009110713642.png)
![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191112111130-20211009110721384.png)

这边Kind有很多选项，这边选择Username with password,用账户密码来设置；然后在Username和Password输入框中分别输入gitlab的账号和密码。点击OK保存；

![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191112111529-20211009110727391.png)
![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191112111806-20211009110733127.png)



保存后就会出现你保存好的凭证；



## 创建JOB
![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191112111950.png)

### 创建Maven项目

![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191112112035.png)

### 输入你的gitlab项目地址，然后选择刚才配置的凭证

![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191112112620.png)

### 输入Maven打包命令，然后点击保存
![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191112112719.png)

### 开始构建
![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191112112747.png)

### 查看构建项目日志
> 第一次构建会比慢，因为他要下载maven相关构建的包

![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191112112803.png)
![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191112112841.png)
![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191112112854.png)

### 查看构建好的jar包
![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191112122030.png)
![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191112122112.png)
![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191112122135.png)
![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191112122200.png)

> 到此，构建maven项目已结束，可以下载这个jar包进行部署。后面会有自动构建部署的教程