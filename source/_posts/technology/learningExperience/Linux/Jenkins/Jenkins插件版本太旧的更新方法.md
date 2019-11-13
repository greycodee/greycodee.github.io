---
title: Jenkins插件版本太旧的更新方法
top: false
cover: false
toc: true
mathjax: true
tags:
  - Jenkins
categories:
  - technology
  - learningExperience
  - Linux
  - Jenkins
date: 2019-11-12 17:27:27
password:
summary:
---

# Jenkins插件版本太旧的更新方法

## 前言

	Jenkins的插件好多都是互相依赖的，如果有的插件版本太低，而另一个插件就会导致用不了，就会出现下面的情况：
![jenkins插件管理界面](https://mjava.top/img/20191108102617.png)

Durable Task Plugin version 1.29 is older than required. To fix, install version 1.33 or later.



## 查看本地已安装版本

可以看到，本地安装的版本和刚才提示的一样，是1.29版本的，刚才提示说太旧了，要更新到1.33版本。

![jenkins插件管理界面](https://mjava.top/img/20191108100855.png)



## 搜索插件

当你理所应当的去这个界面准备搜索这个插件并更新时。。。。你傻了，，怎么搜不到？？？WTF

![jenkins插件管理界面](https://mjava.top/img/20191108102907.png)



不要慌，天无绝人之路，这里找不到，可以去另外的地方找。浏览器打开这个网站

[Jenkins插件下载](https://plugins.jenkins.io/)

- 进入后在输入框里输入你刚才要下载的插件:

![jenkins插件下载](https://mjava.top/img/20191108101610.png)


- 选择对应的插件
![jenkins插件下载](https://mjava.top/img/20191108101748.png)


- 然后点击右上角
![jenkins插件下载](https://mjava.top/img/20191108101807.png)


- 下载刚才提示的1.33版本
![jenkins插件下载](https://mjava.top/img/20191108101832.png)


- 下载完成后是一个hpi文件
![jenkins插件下载](https://mjava.top/img/20191108102109.png)


## 导入插件
- 到插件管理界面，找到Upload Plugin
![jenkins插件下载](https://mjava.top/img/20191108102152.png)

- 然后选择刚才下载的插件，点击导入
![jenkins插件下载](https://mjava.top/img/20191108102223.png)

- 可以看到插件正在导入
![jenkins插件下载](https://mjava.top/img/20191108102240.png)

- 导入完成后，重启Jenkins就OK了
![jenkins插件下载](https://mjava.top/img/20191108102254.png)