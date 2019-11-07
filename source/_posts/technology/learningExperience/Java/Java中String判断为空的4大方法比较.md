---
title: Java中String判断为空的4大方法比较
top: false
cover: false
toc: true
mathjax: true
tags:
  - Java
categories:
  - technology
  - learningExperience
  - Java
date: 2019-08-20 18:59:15
password:
summary:
---

## 一.四大方法
```java
public class demo1 {
   public static void main(String[] args) {
       String a="";
       String a2=new String();

       System.out.println(a=="");
       System.out.println(a2=="");
       System.out.println("------------------------------");
       System.out.println(a==null);
       System.out.println(a2==null);
       System.out.println("------------------------------");
       System.out.println(a.length()<=0);
       System.out.println(a2.length()<=0);
       System.out.println("------------------------------");
       System.out.println(a.isEmpty());
       System.out.println(a2.isEmpty());
       System.out.println("------------------------------");
       
   }
}
```
## 二.输出结果
![控制台输出](https://mjava.top/img/javaands1.png)

>可以看到用"=="判断的那组出现了不一致的情况
