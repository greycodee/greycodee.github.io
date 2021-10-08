---
title: OOP程序七大原则
top: false
cover: false
toc: true
mathjax: true
date: 2019-12-15 10:45:04
password:
summary:
keywords:
description:
tags:
- GOF
- OOP
categories:
- GOF
---



![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/autumn-4656877_1920.png)



## 开闭原则

开闭原则相当于所有原则的祖先，主张对修改关闭，对拓展开放．



## 里氏替换原则

<font color=orange>当两个类有继承关系时，子类不能修改父类的方法和变量.  </font>里氏替换中的<font color=orange>替换</font>指的是：当有父类出现的地方，这个父类可以<font color=orange>替换</font>成子类，而且对程序没有影响，这就遵循了里氏替换原则；当替换成子类时对程序有影响，说明子类修改了父类的方法，就没有遵循里氏替换原则了；

## 依赖倒置原则

依赖倒置原则是对开闭原则的一个实现，也是主张对拓展开放，对修改关闭．它的核心思想是<font color=orange>面对接口编程，不要面对具体实现编程</font>．

![来自C语言中文网](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/3-1Q113131610L7.gif)

这是一个遵守依赖倒置原则的UML图，原来的话当客户购买商品时,shopping这个方法要传入相应的网店进去，当要更改店铺时，就要修改Cusromer这个类里的shopping方法，而现在，只要定义一个Shop接口，所有的店铺都实现这个接口的方法，顾客类的shopping方法只要传入Shop这个接口类就可以了．然后具体实现的时候，要到哪里买，就传入哪一个网店就可以了，而不用修改Cusromer这个类的方法；

```java
//代码来之＇C语言中文网＇
public class DIPtest
{
    public static void main(String[] args)
    {
        Customer wang=new Customer();
        System.out.println("顾客购买以下商品："); 
        wang.shopping(new ShaoguanShop()); 
        wang.shopping(new WuyuanShop());
    }
}
//商店
interface Shop
{
    public String sell(); //卖
}
//韶关网店
class ShaoguanShop implements Shop
{
    public String sell()
    {
        return "韶关土特产：香菇、木耳……"; 
    } 
}
//婺源网店
class WuyuanShop implements Shop
{
    public String sell()
    {
        return "婺源土特产：绿茶、酒糟鱼……"; 
    }
} 
//顾客
class Customer
{
    public void shopping(Shop shop)
    {
        //购物
        System.out.println(shop.sell()); 
    }
}

//输出
顾客购买以下商品：
韶关土特产：香菇、木耳……
婺源土特产：绿茶、酒糟鱼……
```

## 单一职责

<font color=orange>单一职责要求一个类只负责一项职责.  </font>这个听起来很简单，但是实际应用上却非常的难把握．因为这个职责在中国是非常抽象的概念，中国是一个文化底蕴非常丰富的国家，就像<<设计模式之禅>> 这本书里所说的例子：比如说中国的筷子，他既可以当刀来分割食物，也可以当叉子来叉取食物，而在国外，叉子就是叉子，用来取食物的，刀就是用来分割食物的；所以这个单一职责要求软件开发人员有非常丰富的实践经验．不然很难把握；

## 迪米特法则

<font color=orange>迪米特法则也称最小知道原则，一个类对外暴露的东西越少越好．</font>

1. 从依赖者的角度来说，只依赖应该依赖的对象。
2. 从被依赖者的角度说，只暴露应该暴露的方法。

个人理解：当A类需要调用B类的三个方法才能实现的功能时,B类可以对这三个方法进行一个封装，然后只暴露封装的这个方法给A,这样A就只需要调用B的这个封装的方法就可以了，当B的三个方法中有修改的时候，只要修改B这个对外封装的方法就可以，而Ａ调用者却不用改变，因为Ａ只知道调用这个方法可以实现功能，而不用具体管Ｂ内部是怎么实现的，降低了程序的耦合度；

## 接口隔离原则

这个和单一职责有点类似，不过还是不一样的．

- 单一职责原则注重的是职责，而接口隔离原则注重的是对接口依赖的隔离。
- 单一职责原则主要是约束类，它针对的是程序中的实现和细节；接口隔离原则主要约束接口，主要针对抽象和程序整体框架的构建。

官方定义：<font color=orange>要求程序员尽量将臃肿庞大的接口拆分成更小的和更具体的接口，让接口中只包含客户感兴趣的方法，降低程序耦合度。</font>

这个法则也要根据实际的业务场景来应用，如果粒度控制的太小，就会导致类的急剧增加，明明一个功能只要三四个类，如果粒度小的话，就会变成十几个，甚至几十个，虽然这样程序耦合度低，比较灵活，但是维护难啊．如果粒度大，耦合度就会高，程序不灵活．所以这个原则要求技术人员有足够的实践，经验和领悟；

## 合成复用原则

它要求在软件复用时，要尽量先使用组合或者聚合等关联关系来实现，其次才考虑使用继承关系来实现。如果要使用继承关系，则必须严格遵循<font color=orange>里氏替换原则</font>。合成复用原则同里氏替换原则相辅相成的，两者都是开闭原则的具体实现规范。

如果不了解什么是组合和聚合的话可以看看这个篇文章[<<组合、聚合与继承的爱恨情仇>>](https://blog.csdn.net/qq_31655965/article/details/54645220),讲的挺好的



## 总结

在程序设计中，尽量遵循OOP七大原则．不过有句话说的好，<font color=orange>规则是死的，人是活的</font>．意思是这七大原则有时候也不是万能的，有时候有的业务场景如果遵循了这些原则，反而变得难维护，所以一切都要从实际出发，23种设计模式也是一样，不要按死规则来．