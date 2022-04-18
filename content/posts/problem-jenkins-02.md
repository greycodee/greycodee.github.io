---
title: Jenkins初始化界面插件安装失败解决方法
top: false
cover: false
toc: true
mathjax: true
tags:
  - Jenkins
categories:
  - Jenkins
date: 2019-11-07 17:19:52
password:
summary:
---

## 前言

在初始化安装界面可能由于网络问题会出现插件下载失败，就像下面这个界面

![Jenkins插件安装失败](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/jenkins_error_2_20191107155729.png)

别着急，直接点击继续，先完成初始化步骤。



## 设置源

- 插件下载失败，一般都是网络的原因，只要更换到国内的软件源就可以了，点击Manage Jenkins
![Jenkins](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191107162947.png)


- 点击Correct
![Jenkins](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191107163016.png)


- 点击Advanced
![Jenkins](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191107163040.png)


- 下拉找到Update Site
![Jenkins](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191107163100.png)


- 然后把输入框的内容换成

```shell
https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/2.89/update-center.json
```

![Jenkins](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191107165325.png)

## 重新下载插件

- 然后重新下载刚才那些下载失败的插件,这里随机选一个
![Jenkins](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191107165630.png)


- 在刚才设置源的那个界面点击 Available，搜索插件，选择，点击install
![Jenkins](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191107165916.png)


- 插件正在安装
![Jenkins](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/09/20191107165947.png)


> 安装完全部插件后然后重启Jenkins，插件界面的报错信息才会消失;如果遇到插件下载不下来或搜不到，可以看这篇文章：[Jenkins插件版本太旧的更新方法](https://mjava.top/jenkins/problem-jenkins-01/)

