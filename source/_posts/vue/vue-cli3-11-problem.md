---
title: Vue Cli3-11创建项目慢的问题
top: false
cover: false
toc: true
mathjax: true
categories:
  - Vue
tags:
  - Vue
  - Pit
date: 2019-09-05 16:33:23
password:
summary:
---
## 前言

  这几天刚学习vue，于是下载了最新的vue cli3.11来搭建项目，可是搭建的时候一直卡在下载插件见面，就是下面这张图。

![vuecreate](/images/vuecreate.png)

网上查了说不能用国内的镜像，WTF，不是说国内的更快吗？好吧，我换！！！

## 下载nrm

  看清楚哦，是nrm部署npm！！！nrm 是一个 `npm` 源管理器，允许你快速地在 `npm` 源间切换。执行以下命令安装。

```shell
sudo npm install -g nrm
```

### 测试nrm是否安装成功

```shell
nrm -V
```

如果输出版本号，则说明安装成功。

## 切换npm源

  ```shell
nrm ls
  ```

此命令会列出npm的所有源

![nrmls](/images/nrmls.png)

可以看到我现在使用的是淘宝的源，现在把他切换到npm的源。

```shell
nrm use npm
```

![nrmuse](/images/nrmuse.png)

## 再次创建vue项目

```shell
vue create rrr2
```
![vuecreate2](/images/vuecreate2.png)
![vuecreate3](/images/vuecreate3.png)

项目成功创建！！！
