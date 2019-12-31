---
title: 【图】用图片告诉你Java中的位运算
top: false
cover: false
toc: true
mathjax: true
date: 2019-12-30 22:17:30
password:
summary:
keywords:
description:
tags:
- Java
categories:
- Java
---

![](http://cdn.mjava.top/20191230221924.jpg)

## 前言

​        虽然位运算在实际开发中并不常用,但是在各种算法中却常常见到它们的身影.因为是直接操作二进制的,所以机器执行起来就快很多,所以尽管实际业务中不常用,但如果你不想只做个码农,这个基础还是要掌握的;

讲位操作之前,就必须要知道<font color=orange>原码、反码、补码</font>

> 其中正数的<font color=orange>原码=反码=补码</font>

## 原码、反码、补码

> 在机器的内存中,一个负数的表示是<font color=orange>这个负数的绝对值取原码,再取反码,再加一</font>,最后出现的就是这个负数在内存中的表示的二进制数值

比如说-9在内存中的二进制码,这里用8位表示:

![](http://cdn.mjava.top/20191230212102.png)

最后<font color=orange>-9在内存中的二进制值为11110111</font>

> 在二进制中,最高位为符号位,<font color=red>0代表正,1代表负</font>

## 位运算

### 左移和右移

在`Java`中的`int`类型有<font color=orange>4字节</font>,一个字节有<font color=orange>8位</font>,所以这边用32位表示一个数

#### 负数的左移和右移

> <font color=orange>这边负数表示是在内存中表示的二进制值</font>
>
> 右移时:最高位<font color=orange>补符号位1</font>
>
> 左移时:末尾补0

![](http://cdn.mjava.top/20191230212836.png)

#### 正数的左移和右移

> 右移时:最高位<font color=orange>补符号位0</font>
>
> 左移时:末尾补0

![](http://cdn.mjava.top/20191230212951.png)

### 无符号右移

>无论是正数还是负数,右移<font color=orange>最高位一律补0</font>

![](http://cdn.mjava.top/20191230213359.png)

### &(位与)

> 当相对应的位都为1时,等于1,否则等于0

为了方便表示,接下来全部都用8位表示一个数

![](http://cdn.mjava.top/20191230215214.png)

### |(位或)

> 当相对应的位有一个为1时,等于1,否则等于0

![](http://cdn.mjava.top/20191230215609.png)

### ^(异或)

> 当相对应的位不同时,等于1,相同时等于0

![](http://cdn.mjava.top/20191230220948.png)

### ~(取反)

> 1等于0,0等于1

![](http://cdn.mjava.top/20191230220449.png)

## 总结

| 含义       | 运算符 | 说明                                                         |
| ---------- | ------ | ------------------------------------------------------------ |
| 左移       | <<     | 末尾补0                                                      |
| 右移       | \>>    | 负数:最高位<font color=orange>补符号位1</font>      正数:最高位<font color=orange>补符号位0</font> |
| 无符号右移 | \>>>   | 无论是正数还是负数,右移<font color=orange>最高位一律补0</font> |
| &(位与)    | &      | 当相对应的位都为1时,等于1,否则等于0                          |
| \|(位或)   | \|     | 当相对应的位有一个为1时,等于1,否则等于0                      |
| ^(异或)    | ^      | 当相对应的位 不同时,等于1  相同时,等于0                      |
| ~(取反)    | ~      | 1等于0,0等于1                                                |

> 最后有个小技巧,<font color=orange>向左位移几位就是乘以2的几次方,比如9向左移n位,就是</font>

$$
9向左移n位=9*2^n
$$

> <font color=orange>向右移几位就是除以2的几次方然后向下取整,比如9向右移动n位,就是</font>

$$
9向右移n位=⌊9/2^n⌋
$$

<font color=red>注:⌊⌋是数学符号向下取整,例如:2.25向下取整是2;   -2.25向下取整是-3; 具体的话可以看看这篇文章[向上取整与向下取整函数](https://www.shuxuele.com/sets/function-floor-ceiling.html);该技巧不适用无符号右移</font>

