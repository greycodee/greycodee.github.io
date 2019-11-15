---
title: Base64影响泰文字段取值问题
top: false
cover: false
toc: true
mathjax: true
tags:
  - Java
  - Base64
  - Pit
categories:
  - Java
date: 2019-08-14 10:39:23
password:
summary:
---

## 今天在工作中，图片要用base64上传，上传数据中还有泰文，然后和前端app联调时发现他们传的泰文这边竟然没存到库里，怀疑是app没有传值过来，于是一番操作

#### 查看日志

>what,日志里面竟然有他们传过来的泰文的值

#### 对比ios和android的数据

>发现日志里的数据都是一样的，但是android上传的数据全部传入了mysql数据库，ios的除了泰文，其他的也都传到了库里

#### 确定问题

>最后对比发现，android的泰文字段三放在base64字段前面的然后传上来的，ios是放在base64字段后面传上来的，怀疑问题在此处

#### 修复bug

>于是叫ios也和android一样，把上传字段的顺序调整了以下，把泰文的字段放在base64字段前面，然后上传。改了之后试了以下，，竟然解决了，2222333333

总结：暂时不知道具体什么原因，有可能是因为base64数据太长了，影响到泰文的字段存储了。
