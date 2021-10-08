---
title: 设计模式系列-模板方法模式
top: false
cover: false
toc: true
mathjax: true
date: 2019-12-20 00:04:28
password:
summary:
keywords:
description:
tags:
- 设计模式
- 模板方法模式
categories:
- GOF
---

![图片](http://xhh.dengzii.com/20191220000613.jpg)

> 积千里跬步，汇万里江河．每天进步一点点，终有一天将成大佬



## 文前常规发言

　　模板方法的设计<font color=orange>符合迪米特法则</font>，也就是最少知道原则，他通过对一些重复方法的封装，减少类之间的耦合，让调用者也更省心，原来要调两三个方法才能实现的功能，现在调一个就可以了；就像我们伟大的祖国，现在也在推行这种模式呢．以前区办一些证明什么的，要跑三四个地方，还要保证这三四个地方都正常帮你办理，如果其中一个地方没办理，那么整个流程就都作废了．现在好了，提倡最多跑一次，只要去一个地方办<font color=orange>一次</font>手续就可以了，你只要知道这个地方能办好就行，其他的就不用烦心了；

![图片](http://xhh.dengzii.com/20191219215431.gif)

## 阿狗卖电脑

　　阿狗是一个三十五岁没了头发的年轻小伙，当问及为什么没了头发，阿狗摸摸头，眼里充满了悔恨的泪水；要不是小时候没听大人的话，长大了也不至于做程序员啊－－－阿狗唉声叹气的说道．听到这里，我仿佛已经知道了答案．当我问他为什么现在改行卖电脑了，他说外面的世界很大，想趁年轻，多闯闯（<font color=orange>实则是被公司裁员，被迫来卖电脑了</font>）；

![图片](http://xhh.dengzii.com/20191219220453.gif)

看看他的电脑店里都有什么

```java
/**
 * 阿狗电脑店
 * */
abstract class AGouShop {
    /**
     *显卡
     * */
    abstract void xianKa();
    /**
     *cpu
     * */
    abstract void cpu();
    /**
     *电源
     * */
    abstract void dianYuan();
    /**
     *主板
     * */
    abstract void zhuBan();
    /**
     *硬盘
     * */
    abstract void yingPan();
    /**
     *内存条
     * */
    abstract void neiCun();
    /**
     *机箱
     * */
    abstract void jiXiang();
}
```

还不错，该有的都有了．当我们正在店里逛着时，来了两个顾客，<font color=orange>阿猫</font>和<font color=orange>大牛</font>，他们都来到阿狗店电脑店，挑选的电脑配件，准备组装电脑．



看看阿猫：

![图片](http://xhh.dengzii.com/20191219222853.png)



在看看大牛的：

![图片](http://xhh.dengzii.com/20191219222925.png)



再看看他们怎么组装的吧：

![图片](http://xhh.dengzii.com/20191219223122.png)

## 有想法的阿狗

　　阿狗自从卖电脑后，发现头上的头发也慢慢的长了出来了，每天也更加自信了．一天，他发现客户有个痛点，就是买电脑要分别买好配件，然后再自己组装，有时候买的配件有问题，又要拿去换，导致费时费力．这时，阿狗头脑灵光一闪，想到了当年做程序员时的<font color=orange>模板方法模式</font>；何不把客户组装电脑的步骤自己承包，这样客户只要来买电脑时选下<font color=orange>配件</font>，我就帮他组装好给他．客户省心省力，到时候生意肯定好；于是他改造了他的电脑店：

```java
/**
 * 阿狗电脑店
 * */
abstract class AGouShop {
    /**
     *显卡
     * */
    abstract void xianKa();
    /**
     *cpu
     * */
    abstract void cpu();
    /**
     *电源
     * */
    abstract void dianYuan();
    /**
     *主板
     * */
    abstract void zhuBan();
    /**
     *硬盘
     * */
    abstract void yingPan();
    /**
     *内存条
     * */
    abstract void neiCun();
    /**
     *机箱
     * */
    abstract void jiXiang();

    /**
     * 阿狗帮客户装电脑
     * 模板方法
     * */
    public void zhuZHuang(){
        System.out.println("阿狗开始组装电脑＝＝＝＝＝＝");
        this.cpu();
        this.dianYuan();
        this.neiCun();
        this.xianKa();
        this.yingPan();
        this.zhuBan();
        this.jiXiang();
        System.out.println("阿狗电脑组装完成＝＝＝＝＝＝");
    }
}
```

上次的阿猫又来买电脑了：

![图片](http://xhh.dengzii.com/20191219232821.png)

看看结果：

![图片](http://xhh.dengzii.com/20191219232931.png)



## 客户反馈

　　阿狗按照上面的模式运行后，缺少增加了不少客户，可是有的顾客却反应说，为什么一定要我选显卡啊，我又不玩游戏，而且我买的cpu有核显，可以不要我选显卡嘛？阿狗一听，这是个问题啊，遵照客户就是上帝的原则(<font color=orange>有钱就赚原则</font>)，于是他又改了他店铺的模式：

```java
/**
 * 阿狗电脑店
 * */
abstract class AGouShop {
    /**
     *　显卡
     * ＂具体方法＂
     * */
    protected void xianKa(){
        System.out.println("客户选了显卡");
    }
    /**
     * 是否要显卡　　默认是要显卡的
     * ＂钩子方法＂
     * */
    public boolean isTrue(){
        return true;
    }
    /**
     *cpu
     * */
    abstract void cpu();
    /**
     *电源
     * */
    abstract void dianYuan();
    /**
     *主板
     * */
    abstract void zhuBan();
    /**
     *硬盘
     * */
    abstract void yingPan();
    /**
     *内存条
     * */
    abstract void neiCun();
    /**
     *机箱
     * */
    abstract void jiXiang();

    /**
     * 阿狗帮客户装电脑
     * 模板方法
     * */
    public void zhuZHuang(){
        System.out.println("阿狗开始组装电脑＝＝＝＝＝＝");
        this.cpu();
        this.dianYuan();
        this.neiCun();
        //判断要不要显卡
        if(this.isTrue()) {
            this.xianKa();
        }
        this.yingPan();
        this.zhuBan();
        this.jiXiang();
        System.out.println("阿狗电脑组装完成＝＝＝＝＝＝");
    }
}
```

> 可以看到上加了<font color=orange>具体方法</font>和<font color=orange>钩子方法</font>

上上次的阿猫和大牛，又双来买电脑了－－－－－有钱真好：

阿猫默认要显卡：

![图片](http://xhh.dengzii.com/20191219234521.png)

大牛不要显卡：![图片](http://xhh.dengzii.com/20191219234630.png)

看看他们的电脑吧：

![图片](http://xhh.dengzii.com/20191219234803.png)



## 总结一下下

  上面对比了阿牛的三种买电脑模式

- 普通模式：自己只提供最基础的东西，所有的由客户自己去完成
- 自己帮客户完成组装电脑：这里就用到了<font color=orange>模板方法模式</font>，通过对自身方法的封装，使客户买电脑更轻松了
- 客户有选择显卡的权利：这里用到了<font color=orange>模板方法模式</font>中的<font color=orange>钩子方法</font>，通过客户暴露钩子方法，使其可以控制阿狗在装电脑是要不要装显卡这个步骤方法，<font color=orange>钩子方法</font>是<font color=orange>模板方法模式</font>的灵魂，有了它，这个模式才有更大的意义；