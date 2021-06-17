---
title: 设计模式系列-工厂模式
top: false
cover: false
toc: true
mathjax: true
date: 2019-12-15 17:25:00
password:
summary:
keywords:
description:
tags:
- 设计模式
- 工厂方法模式
categories:
- GOF
---

![图片](http://cdn.mjava.top/gof-factory-method.jpg)


> 积千里跬步，汇万里江河．每天进步一点点，终有一天将成大佬

## 前言

工厂模式有一下三种

- 简单工厂模式
- 工厂方法模式
- 抽象工厂模式

其中简单工厂模式不在23中模式之中，更多的是一种编程习惯，而我们平常所说的工厂模式一般指的是工厂方法模式，抽象工厂在实际的业务开发中也用的比较少，因为它有时候违背了开闭原则．由于篇幅有限，抽象工厂本文就不讲了，以后单独讲；

## 简单工厂模式

简单工厂到底有多简单呢？简单到只有一个工厂，这个工厂相当于是万能工厂，你想要什么，只要和它说一声，它就会想方设法的去抱你创建，然后给你；举个买车的简单的例子：

当我要买车的时候，我选了这两种车．

```java
/**
 * 创建一个汽车接口
 * */
public interface Car {
    /**
     * 汽车能动
     * */
    void run();
}
```

```java
/**
 * 奔驰车
 * */
public class Benz implements Car {
    @Override
    public void run() {
        System.out.println("大奔开动了");
    }
}
```

```java
/**
 * 五菱神车
 * */
public class Wuling implements Car {
    @Override
    public void run() {
        System.out.println("五菱神车开动了");
    }
}

```

选是选好了，可是要怎么得到呢？是不是下意识的<font color=orange>new</font>一个出来？

```java
//我要奔驰车
Benz　myCar=new Benz();
```

如果是这样的话，就相当于自己亲手造了一辆奔驰车出来，因为是你自己<font color=orange>new</font>出来的嘛！！！！！

![图片](http://cdn.mjava.top/20191215162632.gif)

这种事情当然是交给工厂去做嘛，叫工厂去<font color=orange>new</font>就可以了，我只要交钱给工厂就可以了．诶，有钱真好！

```java
/**
 * 汽车工厂
 *
 * 静态工厂
 *
 * 简单工厂
 * */
public class CarFactory {
    public static Car getCar(String type){
        if("我要五菱神车".equals(type)){
            return new Wuling();
        }
        if ("我要大奔驰".equals(type)){
            return new Benz();
        }
        return null;
    }
}
```

找到了这个工厂之后，我只要直接告诉它我要什么车就可以了，工厂就会帮我造好给我；

```java
/**
 * 买车
 * */
public class CostumerMain {
    public static void main(String[] args) {
        //跟车厂说一声我要五菱神车
        Car wuling=CarFactory.getCar("我要五菱神车");
        //跟车厂说一声我要大奔驰
        Car Benz=CarFactory.getCar("我要大奔驰");

        //开着五菱神车去兜兜风
        wuling.run();
        //开着大奔去兜兜风
        Benz.run();
    }
}

//五菱神车开动了
//大奔开动了
```

这样子，买车就结束了，果然钱可以解决一切，哈哈，开个玩笑～

![图片](http://cdn.mjava.top/20191215163319.jpg)

## 工厂方法模式

上次买了两辆车之后，白天开着大奔去街上撩妹，晚上开着五菱神车去秋名山飙车，从此走向了人生巅峰．可是好景不长，大奔开着开着就漏油了，五菱神车终于也翻车了．

![图片](http://cdn.mjava.top/20191215163907.gif)

找到了上次买车的工厂，准备换个低调点的劳斯莱斯．可是那家工厂竟然告诉我说他们那边还没有造过劳斯莱斯，需要改造一下工厂，然后才能生产劳斯莱斯，叫我等他们改造好之后再来买．听他们这麽说后，我心想，我这分分钟几百万上下的人，时间就是金钱．我可等不了．



于是几番寻找之后，发现英国有个劳斯莱斯车场，专门来生产劳斯莱斯．于是和接待我的中介小姐姐聊了一下，发现他们的生产模式是这样的：

```java
/**
 * 他们有个汽车工厂总部，用来定义车厂该干什么
 * */
public interface AllCarFactory {
    /**
    * 生产汽车
    */
    Car getCar();
}
```

```java
/**
*　有个汽车规则，用来定义汽车能干什么
*/
public interface Car {
    /**
    *　汽车能跑
    */
    void run();
}
```

```java
/**
 * 劳斯莱斯汽车
 * */
public class RollsRoyce implements Car {
    /**
    * 劳斯莱斯能跑起来
    */
    @Override
    public void run() {
        System.out.println("劳斯莱斯开起来了！！");
    }
}

```

```java
/**
 * 劳斯莱斯汽车工厂
 * */
public class RollsRoyceFactory implements AllCarFactory {
    /**
    * 生产一辆劳斯莱斯
    */
    @Override
    public Car getCar() {
        return new RollsRoyce();
    }
}
```

找到车厂后，我毫不犹豫和接待我的小姐姐说给我来一辆，小姐姐见我这么豪爽，准备再忽悠我买几辆车，不推荐我几辆车．．．．她知道我之前买了奔驰和五菱神车,和我说他们这边还有还有五菱车厂和奔驰车厂，都是专门用来造同一种车的．于是我就去参观了一下：

```java
/**
* 五菱神车
*/
public class Wuling implements Car {
    /**
    * 五菱神车能飙车
    */
    @Override
    public void run() {
        System.out.println("五菱神车开动了");
    }
}
```

```java
/**
 * 五菱神车工厂
 * */
public class WulingFactory implements AllCarFactory {
    /**
    * 生产一辆五菱神车
    */
    @Override
    public Car getCar() {
        return new Wuling();
    }
}
```

再区看看奔驰车厂：

```java
/**
* 奔驰汽车
*/
public class Benz implements Car {
    /**
    * 奔驰汽车能跑
    */
    @Override
    public void run() {
        System.out.println("大奔开动了");
    }
}
```

```java
/**
 * 奔驰汽车工厂
 * */
public class BenzFactory implements AllCarFactory {
    /**
    * 生产一辆奔驰汽车
    */
    @Override
    public Car getCar() {
        return new Benz();
    }
}
```

看完之后，感觉还可以，于是分别到三个工厂买了三辆车，然后高高兴兴的回家了：

![图片](http://cdn.mjava.top/20191215170620.jpg)

看看我买车的过程：

```java
/**
 * 土豪买车记
 * */
public class CostumerMain {
    public static void main(String[] args) {
        //去五菱车厂买车
        Car wuling=new WulingFactory().getCar();
        //去奔驰车厂买车
        Car benz=new BenzFactory().getCar();
        //去劳斯莱斯车厂买车
        Car rollsRoyce=new RollsRoyceFactory().getCar();
        
        //开着三辆车去兜兜风
        wuling.run();
        benz.run();
        rollsRoyce.run();
    }
}


//五菱神车开动了
//大奔开动了
//劳斯莱斯开起来了！！
```



## 总结

​	买完车后，小姐姐还和我说他们这样的模式生产车的话有好多好处，比如一个车厂只要负责一种车的生产和售后，这样的话，生产效率就会比较高，赚的钱自然也多，同时每个车厂还可以举行不同活动，来吸引消费者，同时，你如果哪个品牌的车出现了问题了，直接去那辆车的工厂，基本上都能帮你解决问题，毕竟<font color=orange>术业有专攻</font>，对比前一个工厂什么都造的万金油来说，深入一项技术比什么技术都懂好；

​	不过有时候，万金油工厂也挺好的，就是一站式服务，你要什么它都有，不用到处乱跑，省心省力．所以还是要根据什么行业来执行什么模式，这样才能利益最大化；