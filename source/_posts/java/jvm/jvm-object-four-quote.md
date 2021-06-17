---
title: Java四种引用方法使用和对比
top: false
cover: false
toc: true
mathjax: true
date: 2020-05-29 10:22:07
password:
summary:
keywords:
description:
tags:
- Jvm
- Java
categories:
- Java
---



![图片](http://cdn.mjava.top/blog/20200526225718)

## 强引用（Strongly Reference）

> 无论任何情况下，只要强引用关系还存在，垃圾收集器就永远不会回收掉被引用的对象。
>
> <font color=red>回收时机:强引用关系不存在时</font>

```java
Object obj=new Object();
```



## 软引用（Soft Reference）

> 软引用是用来描述一些还有用，但非必须的对象。只被软引用关联着的对象，在系统将要发生内存溢出异常前，会把这些对象列进回收范围之中进行第二次回收，如果这次回收还没有足够的内存，才会抛出内存溢出异常。
>
> <font color=red>回收时机:发送内存溢出异常前</font>

```java
//软引用

SoftReference<Object> srf = new SoftReference<Object>(new Object());

//or

Object obj=new Object();
SoftReference<Object> srf = new SoftReference<Object>(obj);
obj=null;  //这种方法一定要设置obj为null,否则这个对象除了软引用可达外,还有原来强引用也可达
```



### 弱引用（Weak Reference）

> 弱引用也是用来描述那些非必须对象，但是它的强度比软引用更弱一些，被弱引用关联的对象**只能生存到下一次垃圾收集发生为止**。当垃圾收集器开始工作，无论当前内存是否足够，都会回收掉只被弱引用关联的对象。
>
> <font color=red>回收时机:下一次垃圾回收时</font>

```java
//弱引用

WeakReference<Object> wrf = new WeakReference<Object>(new Object());

//or
Object obj=new Object();
WeakReference<Object> wrf = new WeakReference<Object>(new Object());
obj=null;
```



### 虚引用（Phantom Reference）

> 虚引用也称为“幽灵引用”或者“幻影引用”，它是最弱的一种引用关系。一个对象是否有虚引用的存在，完全不会对其生存时间构成影响，也无法通过虚引用来取得一个对象实例。
>
> <font color=red>回收时机:随时</font>

```java
//虚引用
PhantomReference<Object> prf = new PhantomReference<Object>(new Object(), new ReferenceQueue<>());

//or

Object obj=new Object();
PhantomReference<Object> prf = new PhantomReference<Object>(obj, new ReferenceQueue<>());
obj=null;
```
