---
title: 吐血整理Git常用命令
top: false
cover: false
toc: true
mathjax: true
date: 2020-06-22 16:27:25
password:
summary:
keywords:
description:
tags:
- Git
categories:
- Tool
---

## Git常用命令

## Git简介

Git 是用于 Linux[内核](https://baike.baidu.com/item/内核)开发的[版本控制](https://baike.baidu.com/item/版本控制)工具。与常用的版本控制工具 CVS, Subversion 等不同，它采用了分布式版本库的方式，不必服务器端软件支持（wingeddevil注：这得分是用什么样的服务端，使用http协议或者git协议等不太一样。并且在push和pull的时候和服务器端还是有交互的。），使[源代码](https://baike.baidu.com/item/源代码)的发布和交流极其方便。 Git 的速度很快，这对于诸如 Linux kernel 这样的大项目来说自然很重要。 Git 最为出色的是它的合并跟踪（merge tracing）能力。

git对于很多人来说,真的是又爱又恨,用的好可以提示开发效率;用不好,解决各种冲突就要累的你半死



## git结构

> 网上有 我就不画了

![git结构图](http://xhh.dengzii.com/blog/20200605001853.png)



- workspace    相当于就是我们的本地电脑上的文件

- Index    缓存区
- Repository    本地仓库
- Remote    远程仓库(github/gitlab/gitee)



## git命令

git官方提供的命令多达几百个,可是我们日常却用不到这么多

所以我就整理了一下日常使用的命令

现在关注微信公招:`灰色Code`

回复关键字:`git`

就可以获取思维导图高清图片及导图源地址

![图片](http://xhh.dengzii.com/blog/20200605002904.jpg)