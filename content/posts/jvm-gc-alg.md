---
title: JVM4种垃圾收集算法
top: false
cover: false
toc: true
mathjax: true
date: 2020-05-29 10:31:30
password:
summary:
keywords:
description:
tags:
- JVM
categories:
- JVM
---

## 简介

垃圾收集算法可以划分为“引用计数式垃圾收集”（Reference Counting GC）和“追踪式垃圾收集”（Tracing GC）两大类，这两类也常被称作“直接垃圾收集”和“间接垃圾收集”。



##  标记-清除算法

- **标记过程**就是对象是否属于垃圾的判定过程(**采用可达分析算法GC Roots**)
- 算法分为**“标记”**和**“清除”**两个阶段：首先标记出所有需要回收的对象，在标记完成后，统一回收掉所有被标记的对象，**也可以反过来**，标记存活的对象，统一回收所有未被标记的对象。

### 缺点

- 执行效率不稳定，如果Java堆中包含大量对象，而且**其中大部分是需要被回收的**，这时必须进行大量标记和清除的动作，导致标记和清除两个过程的**执行效率都随对象数量增长而降低**；
- 第二个是内存空间的碎片化问题，标记、清除之后会**产生大量不连续的内存碎片**，空间碎片太多可能会导致当以后在程序运行过程中需要分配较大对象时**无法找到足够的连续内存**而不得不**提前触发另一次垃圾收集动作**。
- ![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20200529100358.png)

![标记清除算法](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20200528203926.jpeg)

##  标记-复制算法

- **标记过程**就是对象是否属于垃圾的判定过程(**采用可达分析算法GC Roots**)

- 它将可用内存按容量划分为**大小相等的两块**，每次只使用其中的一块。
- 当这一块的内存用完了，就将还**存活着的对象复制到另外一块上面**，然后再把**已使用过的内存空间一次清理掉**。

### 缺点

- 如果内存中**多数对象都是存活的**，这种算法将会**产生大量的内存间复制的开销**
- 代价是将可用内存缩小为了**原来的一半**,空间浪费未免太多了一点.
- ![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20200529100420.jpg)

![标记复制算法](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20200528203952.jpeg)

##  标记-整理算法

- **标记过程**就是对象是否属于垃圾的判定过程(**采用可达分析算法GC Roots**)
- 在**标记-清除**的算法基础上改进,后续步骤不是直接对可回收对象进行清理，而是让**所有存活的对象都向内存空间一端移动**，然后直接**清理掉边界以外的内存**，

### 缺点

- 在有大量存活对象的老年代区域,**移动存活对象**并**更新所有引用**这些对象的地方将会是一种**极为负重**的操作,而且这种对象移动操作**必须全程暂停用户应用程序**才能进行,比**标记-清除**算法停顿时间长.
- ![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20200529100506.jpg)

![标记整理算法](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20200528204014.jpeg)



## 分代收集算法

现代商用虚拟机基于以上算法的优缺点,根据**分代收集理论**,在不同的区域采用了不同的收集算法.

> <font color=red>老年代:新生代=2:1</font>

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20200529101100.png)

### 新生代

> 堆大小默认比例:<font color=red>Eden:S0:S1=8:1:1</font>
>
> 采用标记-复制算法

新生代分为**Eden区**和**Survior区**,而Survior区又分为**From Survior区(S0)**和**To Survior区(S1)**.此区域采用标记-复制算法.每次Minor GC/Young GC时,会把**Eden区**存活的对象复制到**S0区**,然后清空Eden区,当S0区满时,Eden区和S0区存活的对象会复制到**S1区**,然后S0和S0进行交换,永远保持S1为空状态,当新生代的对象经过一定次数的Minor GC还未被回收时,就会把这个对象移到老年代.

### 老年代

> 采用标记-整理法或标记-清理法

当老年代Old区域满时,会触发**Full GC**,同时回收新生代和老生代的所有区域.回收后诺内存还是不足时,会引发**OOM异常**;