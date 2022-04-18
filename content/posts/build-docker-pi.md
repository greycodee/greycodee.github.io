---
title: 树莓派安装docker
top: false
cover: false
toc: true
mathjax: true
tags:
  - Linux
  - Docker
  - RaspberryPi
categories:
  - Linux
date: 2019-08-30 18:33:03
password:
summary:
---

## 前言

  和平常x86_64架构的电脑安装docker不同，树莓派是ARM架构的，所以安装步骤比较繁琐一点。



##  使用APT源安装docker

  更新apt软件源及安装必备组件。为了确认所下载软件包的合法性，还需要添加软件源的 GPG 密钥。

```shell
$sudo apt-get update
$sudo apt-get install \
	 apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     lsb-release \
     software-properties-common
$curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/raspbian/gpg | sudo apt-key add -
```



## 添加docker ce 软件源

* 首先执行以下一行命令，然后记一下输出的结果

  ```shell
  $ echo $(lsb_release -cs)
  stretch
  ```

* 在/etc/apt/sources.list.d目录下新建文件docker.list

  ```shell
  $ sudo vi /etc/apt/sources.list.d/docker.list
  ```

* 在文件里添加下面这行

  ```shell
  deb [arch=armhf] https://download.docker.com/linux/raspbian $(lsb_release -cs) stable
  ```

* 把$(lsb_release -cs)改为刚才第一行输出的结果，比如我的输出的是stretch，改完后如下

  ```shell
  deb [arch=armhf] https://download.docker.com/linux/raspbian stretch stable
  ```

* 保存，退出

  

## 安装docker ce

  依次执行以下两行命令，即可完成安装

```shell
$ sudo apt-get update
$ sudo apt-get install docker-ce
```



## 启动

```shell
$ service docker start           启动
$ service docker stop            停止
$ service docker status          状态
$ service docker restart         重启
```