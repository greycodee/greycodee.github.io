---
title: 设计模式系例-单例模式
top: true
cover: false
toc: true
mathjax: true
tags:
  - GOF
  - Singleton
categories:
  - GOF
date: 2019-10-22 21:16:37
password:
summary:
---

   

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/gof-singleton.jpg)

> 积千里跬步，汇万里江河．每天进步一点点，终有一天将成大佬 



## 前言

网上说单例模式是所有模式中最简单的一种模式，巧的是我也这么认为。不过越简单的东西，往往坑就隐藏的越深，这边文章我会把我知道的几个坑所出来。



## 一.什么是单例模式

​    就如同他的名字一样，'单例'-就是只有一个实例。也就是说一个类在全局中最多只有一个实例存在，不能在多了，在多就不叫单例模式了。



### 1.白话小故事

​    程序员小H单身已久，每天不是对着电脑，就是抱着手机这样来维持生活。某日，坐在电脑前，突然感觉一切都索然无味。谋生想找一个对象来一起度过人生美好的每一天。

​    于是精心打扮出门找对象，由于小H很帅，很快就找到了心仪的另一半--小K。小H的心中永远只有小K一个人，而且发誓永远不会在找新对象。

> 小H和小K的关系就是单例模式，在小H的全局中只有一个小K对象，且无第二个，如果有第二个的话，他们之间的关系就出问题了。哈哈



## 2.用在哪里

​    单例模式一般用在对实例数量有严格要求的地方，比如数据池，线程池，缓存，session回话等等。



## 3.在Java中构成的条件

- 静态变量
- 静态方法
- 私有构造器

## 二.单例模式的两种形态

### 1.懒汉模式

> 线程不安全

```java
public class Singleton {

    private static Singleton unsingleton;

    private Singleton(){}

    public static Singleton getInstance(){
        if(unsingleton==null){
            unsingleton=new Singleton();
        }
        return unsingleton;
    }
}
```



### 2.饿汉模式

> 线程安全

```java
public class Singleton {

    private static Singleton unsingleton=new Singleton();

    private Singleton(){}

    public static Singleton getInstance(){
        return unsingleton;
    }
}
```



#### 调用

```java
public class Test {
    public static void main(String[] args) {
        Singleton singleton1=Singleton.getInstance();
    }
}
```

## 三.懒汉模式优化成线程安全

  懒汉模式要变成线程安全的除了用饿汉模式之外，还有两种方法。

### 1.加synchronized关键字

> 此方法是最简单又有效的方法，不过对性能上会有所损失。比如两个线程同时调用这个实例，其中一个线程要等另一个线程调用完才可以继续调用。而线程不安全往往发生在这个实例在第一次调用的时候发生，当实例被调用一次后，线程是安全的，所以加synchronized就显得有些浪费性能。

```java
public class Singleton {

    private static Singleton unsingleton;

    private Singleton(){}

    public static synchronized Singleton getInstance(){
        if(unsingleton==null){
            unsingleton=new Singleton();
        }
        return unsingleton;
    }
}
```

### 2.用"双重检查加锁"

> 上个方法说到，线程不安全往往发生在这个实例在第一次调用的时候发生，当实例被调用一次后，线程是安全的。那有没有方法只有在第一次调用的时候才用synchronized关键字，而第一次后就不用synchronized关键字呢？答案是当然有的，就是用volatile来修饰静态变量，保持其可见性。

```java
public class Singleton {

    private static volatile Singleton unsingleton;

    private Singleton(){}

    public static Singleton getInstance(){
        if(unsingleton==null){
            //只有当第一次访问的时候才会使用synchronized关键字
            synchronized (Singleton.class){
                unsingleton=new Singleton();
            }
        }
        return unsingleton;
    }
}
```



## 三种线程安全的单例模式比较

- 饿汉模式：性能好，写法简单，个人比较推荐用这个

- 加synchronized关键字：性能差，不过对懒汉模式的盖章比较直接有效。

- volatile-双重验证加锁：性能好，对Java版本有要求，要求Java5以上版本

  