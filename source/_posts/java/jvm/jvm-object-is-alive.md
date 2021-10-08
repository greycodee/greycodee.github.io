---
title: JVM判断对象是否还活着的两种方法
top: false
cover: false
toc: true
mathjax: true
date: 2020-05-29 10:18:30
password:
summary:
keywords:
description:
tags:
- JVM
categories:
- JVM
---



## 引用计数法

> Java虚拟机**并不是**通过引用计数算法来判断对象是否存活的。

在对象中添加一个引用计数器，每当有一个地方引用它时，计数器值就加一；当引用失效时，计数器值就减一；任何时刻计数器为零的对象就是不可能再被使用的。

### 优点

- 原理简单,判定效率高

### 缺点

- 不能用于复杂的环境中,比如对象的互相引用问题



##  可达性分析算法

> Java虚拟机使用此算法来判断对象是否存活

这个算法的基本思路就是通过一系列称为“`GC Roots`”的根对象作为起始节点集，从这些节点开始，根据引用关系向下搜索，**搜索过程所走过的路径称为“引用链”（Reference Chain）**，如果某个对象到GCRoots间**没有任何引用链相连**，或者用图论的话来说就是**从GC Roots到这个对象不可达时**，则证明**此对象是不可能再被使用的**。

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20200526224246.jpeg)



Java中作为GC Roots的对象:

- 在虚拟机栈（**栈帧中的本地变量表**）中引用的对象，譬如各个线程被调用的方法堆栈中使用到的参数、局部变量、临时变量等。
- 在方法区中类静态属性引用的对象，譬如Java类的引用类型静态变量。
- 在方法区中常量引用的对象，譬如字符串常量池（String Table）里的引用。
- 在本地方法栈中JNI（即通常所说的Native方法）引用的对象。
- Java虚拟机内部的引用，如基本数据类型对应的Class对象，一些常驻的异常对象（比如NullPointExcepiton、OutOfMemoryError）等，还有系统类加载器。
- 所有被同步锁（synchronized关键字）持有的对象。

- 反映Java虚拟机内部情况的JMXBean、JVMTI中注册的回调、本地代码缓存等。
- **其他对象临时性地加入,共同构成GC Roots**