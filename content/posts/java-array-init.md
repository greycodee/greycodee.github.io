---
title: Java数组的几种初始化方式
top: false
cover: false
toc: true
mathjax: true
date: 2019-12-09 10:22:12
password:
summary:
keywords:
description:
tags:
- Java
categories:
- Java
---



## 一维数组

### 初始化容量

```java
/**
* 定义容量为5,初始值为0的int一维数组
*/
int array[]=new int[5];
int[] array2=new int[5];
```

### 初始化值

```java
/**
* 初始化一维容量为5的一维数组的值
*/
int[] array10={1,2,3,4,5};
int aray12[]={1,2,3,4,5};
```





## 二维数组

> 二维数组初始化时必须要声明行数,列数可随意 


### 初始化容量
- 声明了列数的



```java
/**
* 初始化一个5行5列的二维数组
*/
int[][] array3=new int[5][5];
int []array4[]=new int[5][5];
int array5[][]=new int[5][5];
```


-  未声明列数的



> 此种方法初始化后如果要赋值的话要new一个数组,如果按照常规的方法赋值然后取值会报空指针异常
```java
/**
* 初始化一个5行空列的二维数组
*/
int[][] array6=new int[5][];
int []arra7[]=new int[5][];
int array8[][]=new int[5][];
```
 ```java
/**
* 赋值方法
*/
int[][] array6=new int[5][];
array6[0]=new int[]{1,2,3};
System.out.println(array6[0][0]);

//输出:1
 ```


#### 初始化值

```java
/**
* 初始化并赋值一个2行3列的二维数组
*/
int[][] array13={{1,2,3},{4,5,6}};
int []array14[]={{1,2,3},{4,5,6}};
int array15[][]={{1,2,3},{4,5,6}};
```



## 总结

​    其他像什么三维数组,多维数组初始化的方式都差不多,可以自己在IDE工具中试一下;