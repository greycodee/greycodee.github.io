---
title: JVM逃逸分析技术
top: false
cover: false
toc: true
mathjax: true
date: 2020-05-26 16:02:00
password:
summary:
keywords:
description:
tags:
- JVM
categories:
- JVM
---



逃逸分析技术的日渐成熟,促使所有的Java对象实例不一定都在Java堆上分配内存

简单来讲就是，Java Hotspot 虚拟机可以分析**新创建对象**的使用范围，并决定是否在 Java 堆上分配内存的一项技术。

## 使用

- 开启逃逸分析：-XX:+DoEscapeAnalysis
- 关闭逃逸分析：-XX:-DoEscapeAnalysis
- 显示分析结果：-XX:+PrintEscapeAnalysis
- 逃逸分析技术在 Java SE 6u23+ 开始支持,并默认设置为启用状态

## 逃逸程度

逸分析的基本行为就是分析对象动态作用域,从**不逃逸**、**方法逃逸**到**线程逃逸**，称为对象**由低到高的不同逃逸程度**。

### 方法逃逸

当一个对象在**方法中**被定义后，它可能被**外部方法**所引用，例如作为调用参数传递到其他地方中，称为**方法逃逸**。

 ```java
 /*StringBuffer sb是一个方法内部变量，上述代码中直接将sb返回，这样这个StringBuffer有可能被其他方法所
 *改变，这样它的作用域就不只是在方法内部，虽然它是一个局部变量，称其逃逸到了方法外部。甚至还有可能被外部线
 *程访问到，譬如赋值给类变量或可以在其他线程中访问的实例变量，称为线程逃逸。
 */
  public static StringBuffer craeteStringBuffer(String s1, String s2) {
      StringBuffer sb = new StringBuffer();
      sb.append(s1);
      sb.append(s2);
      return sb;
  }
  
  //上述代码如果想要StringBuffer sb不逃出方法，可以这样写：
  public static String createStringBuffer(String s1, String s2) {
      StringBuffer sb = new StringBuffer();
      sb.append(s1);
      sb.append(s2);
      return sb.toString();
  }
 ```



### 线程逃逸

- 当一个对象在**方法中**被定义后，它可能被**外部线程**访问到，譬如赋值给可以在其他线程中访问的实例变量，这种称为**线程逃逸**。





## 逃逸分析优化

如果能**证明一个对象不会逃逸到方法或线程之外**（换句话说是别的方法或线程无法通过任何途径访问到这个对象），或者**逃逸程度比较低**（只逃逸出方法而不会逃逸出线程），则可能为这个对象实例**采取不同程度的优化**

### 栈上分配（Stack Allocations）

- 如果确定一个对象**不会逃逸出线程之外**，那让这个对象在**栈上分配内存**将会是一个很不错的主意，对象所占用的内存空间就可以**随栈帧出栈而销毁**。
- 由于复杂度等原因，HotSpot中目前暂时还没有做这项优化，但一些其他的虚拟机（如Excelsior JET）使用了这项优化。
- 栈上分配可以支持方法逃逸，但不能支持线程逃逸。

### 标量替换（Scalar Replacement）

- 若一个数据已经无法再分解成更小的数据来表示了，Java虚拟机中的原始数据类型（int、long等数值类型及reference类型等）都不能再进一步分解了，那么这些数据就可以被称为**标量**。相对的，如果一个数据可以继续分解，那它就被称为**聚合量（Aggregate）**，Java中的对象就是典型的聚合量。
- -XX:+EliminateAllocations	开启标量替换(jdk8默认开启)
- -XX:+PrintEliminateAllocations    查看标量的替换情况
- 如果把一个Java对象拆散，根据程序访问的情况，将其用到的成员变量恢复为原始类型来访问，这个过程就称为**标量替换**
- 假如逃逸分析能够证明一个对象**不会被方法外部访问**，并且这个对象可以被拆散，那么程序真正执行的时候将**可能不去创建这个对象**，而改为直接创建它的若干个被这个方法使用的**成员变量**来代替。
- 标量替换可以视作**栈上分配的一种特例**，实现更简单（不用考虑整个对象完整结构的分配），但对逃逸程度的要求更高，它**不允许对象逃逸出方法范围内**。

### 同步消除（Synchronization Elimination）

> 也叫锁消除

- +XX:+EliminateLocks	开启同步消除(jdk8默认开启)
- 线程同步本身是一个相对耗时的过程，如果逃逸分析能够确定一个变量**不会逃逸出线程**，无法被其他线程访问，那么这个变量的读写肯定就不会有竞争，对这个变量实施的**同步措施**也就可以**安全地消除掉**。
- 比如常用的线程安全类:`StringBuffer`,`HashTable`,`Vector`等.