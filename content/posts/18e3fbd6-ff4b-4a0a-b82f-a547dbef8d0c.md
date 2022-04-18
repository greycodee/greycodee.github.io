---
title: Disruptor-缓存行填充
top: false
cover: false
toc: true
mathjax: true
date: 2021-03-01 10:02:08
password:
summary:
keywords:
description:
tags:
- Disruptor
- Java
categories:
- Java
---

## 伪共享概念

### CPU架构

常见的CPU架构如下图：

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20201116145239.jpg)

在某个CPU核心上运行一个线程时，他获取数据是先从**L1缓存**上面找，没有命中数据时，再从**L2缓存**上面找、还是没有命中时再从**L3缓存**上找，如果还没有的话就再从主内存里面找。**找到后再一层一层的传递数据**。

所以查找数据的顺序为：

` L1 》L2 》 L3 》主内存`

刷新缓存的顺序为：

`主内存 》L3 》L2 》L1`

### 缓存存储结构

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20201116150451.jpg)

在计算机缓存中，**存储数据是以缓存行为单位的**，不同的系统缓存行的大小也不一样，现在常见的64位操作系统，他每行可以存储64字节数据。比如Java中`Long`类型的数据占8个字节，所以**一行可以存8个Long数据类型的数据**。

**所以当加载缓存行中任意一个数据时，其他在当前缓存行里的数据也会一起加载**

### 线程数据共享

当线程共享一个变量时，每个线程的更改都会把最新数据刷新回主内存，如果处理器发现自己缓存行对应的内存地址呗修改，就会将当前处理器的缓存行设置无效状态，当处理器对这个数据进行修改操作的时候，会重新从系统内存中把数据库读到处理器缓存中（**嗅探机制**）。

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20201116153352.jpg)

### 伪共享

上面说的是**共享一个缓存行的一个数据，这样是完全没问题的**。可是**当不同线程要使用一个缓存行里的不同数据时**，这样就会出现一种**伪共享**的情况:

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20201116155013.jpg)

尽管`变量a`没有被其他线程更改，可以由于他和`变量d`在同一缓存行里，所以每次都会**受变量d的影响**,缓存都会被设置为无效状态，所以每次使用时都会从主内存里重新拉取。这样速度就会大大的打折扣。

### RingBuffer的解决方法

在`RingBuffer`解决伪共享的方法就是**缓存行填充**

```java
abstract class RingBufferPad
{
    protected long p1, p2, p3, p4, p5, p6, p7;
}
```