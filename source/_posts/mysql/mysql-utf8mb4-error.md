---
title: 插入emoji到mysql时提示了一个表里不存在的字段的错误
top: false
cover: false
toc: true
mathjax: true
date: 2020-04-29 17:16:27
password:
summary:
keywords:
description:
tags:
- Pit
- MySQL
categories:
- MySQL
---

## 1.问题描述

由于公司前端有需求，需要在`tiny_user_info`表的`nickname`这个字段里存入emoji表情，于是我熟练地将这个字段修改为`utf8mb4`，改好后测试插入一条带emoji数据。于是报了这个错误：

```shell
[2020-04-29 15:57:25] [HY000][1366] Incorrect string value: '\xF0\x9F\x98\x98' for column 'user_name' at row 14
```

当时我就傻了，我这个表里也没有`user_name`这个字段啊，怎么会报这个字段错误,我明明修改的是`nickname`这个字段啊。于是google和百度搜了一圈，无解。

## ２.解决方案

试了好几种方法，删字段，重新建。删表，重新建。都不行。。。。。静下心来，于是打算从mysql服务器入手。进入到mysql对应库的文件夹，发现`tiny_user_info`这个表有三个文件

![图片](https://i.imgur.com/OY1KhKo.png)

和常见的多了一个`TRG`文件。这是一个触发器文件，打开一看，发现了`user_name`字段。。。。。。



原来是同事在这个表里加了个触发器，当`tiny_user_info`里新增数据时，会触发新增到另一张表里，`nickname`的值同时会插入到另一张表的`user_name`字段，而他那张表的字段没有设置`utf8mb4编码`,所以导致插入失败。于是叫同事把他那张表设置一下`utf8mb4`编码后，就可以正常插入了。