---
title: 创建线程的3种方式
top: false
cover: false
toc: true
mathjax: true
date: 2020-06-22 16:29:38
password:
summary:
keywords:
description:
tags:
- 多线程
categories:
- Java
---



## Java线程状态变迁图

![Java线程状态变迁图](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20200602150941.jpeg)



## 构造一个线程

在线程执行`start()`方法之前,首先需要初始化(NEW)一个线程,初始化的时候,可以设置线程名称,线程所属的线程组、线程优先级、是否是Daemon线程等信息。

**Thread常见参数及设置方法:**

- ```java
  //线程是否是守护线程  默认false
  private boolean     daemon = false;
  //设置方法
  Thread thread=new Thread();
  thread.setDaemon(true);
  ```

- ```java
  //线程名字	默认"Thread-" + nextThreadNum()
  private volatile String name;
  //设置方法
  Thread thread=new Thread();
  thread.setName("myThread"); //不能设置为null,会报异常
  ```

- ```java
  //线程优先级  是否起作用和操作系统及虚拟机版本相关
  private int priority;																
  //设置方法  范围:1-10  默认5
  myThread.setPriority(1);
  ```

  

### Thread源码构造方法

在Thread源码中,一共提供了`9种`构造方法.

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20200602151437.png)

从这些构造方法中,大致可以分为`有Runnable构造参数`的,和`无Runnable构造参数`两大类,无Runnable构造参数的就需要去继承`Thread`来重写`run()`方法<font color=grey>(注:`Thread`也实现了Runnable接口)</font>,有Runnable构造参数的,就实现Runnable接口的run方法,然后通过构造参数,把实现Runnable接口的实例传入Thread.



### 无返回值的线程

可以看到,通过集成`Thread`类和实现`Runnable`接口的`run()`方法返回值都是`void`.这类是没有返回值的

#### 方法一:继承Thread类创建一个线程

```java
//继承Thread类,重写run方法
class MyThread extends Thread{
    @Override
    public void run() {
        System.out.println("继承Thread,重写run方法");
    }
}

public class ThreadTest{
    public static void main(String[] args){
        MyThread myThread=new MyThread();
        myThread.start();
    }
}
```



#### 方法二:实现Runnable接口创建线程

```java
//实现Runnable接口的run方法,然后以构造参数的形式设置Thread的target
class MyRun implements Runnable{
    @Override
    public void run() {
        System.out.println("实现Runnable方法");
    }
}

public class ThreadTest{
    public static void main(String[] args){
        MyRun myRun=new MyRun();
        Thread thread=new Thread(myRun);
        thread.start();
    }
}
```



### 有返回值的线程	

上面两个方法,都有一个共同缺点,就是**没有返回值**,当有一些特殊需求时,比如开启一个线程,用来计算一些东西,或者是处理另外一些需要返回数据的业务,这时就需要借助`FutureTask`来完成了

#### 方法三:通过FutureTask创建一个线程

```java
//实现Callable接口的call方法   类似实现Runnable的run方法
class MyCall implements Callable<Integer>{
    @Override
    public Integer call() throws Exception {
        //计算1+1
        return 1+1;
    }
}

public class ThreadTest{
    public static void main(String[] args){
        MyCall myCall=new MyCall();
        //创建异步任务
        FutureTask<Integer> futureTask=new FutureTask<>(myCall);
        Thread thread2=new Thread(futureTask);
        thread2.start();
        //获取线程执行结果
        Integer res=futureTask.get();
        System.out.println(res); //输出2
    }
}
```



## 总结

使用继承方式的好处是方便传参，你可以在子类里面添加成员变量，通过set方法设置参数或者通过构造函数进行传递，而如果使用Runnable方式，则只能使用主线程里面被声明为final的变量。不好的地方是Java不支持多继承，如果继承了Thread类，那么子类不能再继承其他类，而Runable则没有这个限制。前两种方式都没办法拿到任务的返回结果，但是Futuretask方式可以。