---
title: 设计模式系列-抽象工厂模式
top: false
cover: false
toc: true
mathjax: true
date: 2019-12-16 21:17:23
password:
summary:
keywords:
description:
tags:
- 设计模式
- 抽象工厂模式
categories:
- GOF
---

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191216212929-20211008161813876.jpg)

> 积千里跬步，汇万里江河；每天进步一点点，终有一天将成大佬

## 突然开始的正文

紧接着上一章的[工厂方法模式](https://mjava.top/gof/gof-factory-method)，其实抽象工厂的概念和工厂方法的概念都是差不多的，抽象工厂模式是对工厂方法模式的更高级，比如上次我们说的那个汽车工厂总部类<font color=orange>AllCarFactory</font>，本来他只定义了生产汽车这个方法，下面的各个品牌的汽车厂也只能生产这个汽车，现在由于市场需求，需要生产摩托车，然后<font color=orange>AllCarFactory</font>定义了一个生产摩托车的接口，这样这个接口下面的汽车厂就可以生产摩托车了．就在这时他们的生产模式也从<font color=orange>工厂方法模式</font>升级到了<font color=orange>抽象工厂模式</font>；



话不多说，看两个模式的类图你就明白了：

### 原本的工厂方法模式类图：

![工厂方法模式](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191216202720-20211008161813952.png)

### 升级后的抽象工厂模式：

![抽象工厂模式](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191216203329-20211008161814048.png)

可以看到，抽象工厂只是比工厂方法模式多生产了一个产品，当<font color=orange>抽象工厂模式</font>的产品减到<font color=orange>只有一个</font>的时候，他就又回到了<font color=orange>工厂方法模式</font>；

## 好色的朋友买车了

上次我朋友看见我买车之后，得知是个小姐姐带我区买车的，于是他叫我联系了下那个小姐姐，说他也要买车，点名要叫小姐姐带他去，由于资金有限，他只卖了奔驰和五菱系列的产品，没有买莱斯莱斯的；看看他是怎么买的吧：

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191216205803-20211008161814196.png)

可以看到，由于要在一个工厂买两个东西，他是先找到了工厂，然后再一件一件的从工厂买．我们上次是一个工厂买一件东西，所以是直接去工厂买的；

## 措不及防的结束了

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191216205427-20211008161830697.gif)

不是我不想讲，而是抽象工厂就是这样的东西．从上面可以看出，抽象工厂每当增加一个产品时，后面相关的的<font color=orange>品牌工厂</font>也全部要实现他这个产品，这就违背了开闭原则了．所以，在实际设计中，一个<font color=orange>业务场景是稳定的</font>,用抽象工厂是比较好的，因为一次设计,后面就不用改了,这样就不会违反开闭原则了．但是如果一个<font color=orange>业务场景是稳定的</font>是不稳定的，那么就不适合使用这个模式了，因为后期需要多次修改，这就违反了开闭原则，同时也及其难维护，应为你不知道修改了代码，到底会影响哪些功能；