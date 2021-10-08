---
title: Jenkins教程-Docker+GitLab持续部署持续集成
top: true
cover: false
toc: true
mathjax: true
tags:
  - Jenkins
categories:
  - Jenkins
date: 2019-11-12 17:27:02
password:
summary:
---

## 目录

- [Jenkins教程-搭建(Docker版)](https://mjava.top/jenkins/build-jenkins-docker/)

- [Jenkins教程-创建Maven项目](https://mjava.top/jenkins/build-jenkins-mavne/)

- [Jenkins教程-Docker+GitLab持续部署持续集成](https://mjava.top/jenkins/build-jenkins-ci-cd/)



## 环境

|        | 地址       | 系统     | 安装的软件                   |
| ------ | ---------- | -------- | ---------------------------- |
| 主机１ | 10.25.0.72 | Centos 7 | Docker　,　Jenkins(Docker版) |
| 主机２ | 10.25.0.50 | Cnetos 7 | Docker                       |



## Jenkins所需添加插件

- [Git Parameter](https://plugins.jenkins.io/git-parameter)
- [GitLab](https://plugins.jenkins.io/gitlab-plugin)

- [SSH](https://plugins.jenkins.io/ssh)

## 创建ssh登录凭据

![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191112111043.png)
![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191112111058.png)
![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191112111115.png)
![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191112111130.png)

> 这边选择Username with password,用账户密码来设置；然后在Username和Password输入框中分别输入10.25.0.50服务器的账号和密码。点击OK保存；

![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191112111529.png)
![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191112111806.png)
![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191112160316.png)

## 添加SSH配置
![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191112160521.png)
> 找到SSH remote hosts 

![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191112160541.png)
> 设置你远程机器的ip和端口，然后选择刚配置好的凭证，点击save保存

![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191112160920.png)

## 配置Job

> 进入上篇文章创建好的Job,在此基础上进行改造



### 配置Git Parameter,来获取gitlab的Tag数据

![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191112161424.png)

### 配置触发器

> 点击最下面的Generate,生成秘钥。然后记下URL:http://172.16.54.131:8080/project/JenkinsTest 和生成的秘钥：60327d68d10f1f7621696edd42719d1c

![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191112161808.png)

### 添加构建完成后的动作

![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191112161842.png)

### 添加Execute shell 和Execute shell script on remote host using ssh

- Execute shell ： 执行Jenkins所在服务器的脚本
- Execute shell script on remote host using ssh：登录远程服务器执行脚本



![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191112161940.png)



### 编写你要执行的脚本

> 由于是自定义的，内容我就不粘贴出来了.编写好后点击保存

![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191112164613.png)

## 开始构建

### 手动构建


![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191112164653.png)



#### 选择你要构建的tag标签，点击Build开始构建并自动部署

![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191112164746.png)

### 自动构建

> 自动构建是当你push或打tag上传代码的时候，Jenkins就会自动构建部署



#### 自动构建流程

![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/201911121717.png)


####　配置GitLab代码仓库
> 点击你你项目右边Settings的Integrations,然后在URL和Secret Tonken中填写刚保存的URL和秘钥，选择Tag push events,然后点击保存

![Jenkins界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191112165036.png)

　



#### Git打Tag标签

```shell
git tag -a 1.0 -m '1.0'  		//打一个1.0的tag
git push origin 1.0 			//上传1.0标签到远程仓库
```

上传完tag后此时Jenkins已经开始自动构建并部署项目了；



## 注意

弄自动部署时，Jenkins和GitLab要都能互相访问的到，不然就会出错；