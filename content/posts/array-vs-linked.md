---
title: 恍然大悟，数组和链表的区别
top: false
cover: false
toc: true
mathjax: true
date: 2019-12-18 13:50:52
password:
summary:
keywords:
description:
tags:
- 数据结构
categories:
- Algorithm
---



![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/hlwzTv8.jpg)

> 积千里跬步，汇万里江河．每天进步一点点，终有一天将成大佬

## 文前发言

　　在Java中，很多地方都使用了数组和链表，还有两种组合的叫<font color=orange>数组链表</font>结构，就是常说的<font color=orange>哈希表</font>，HashMap底层的数据结构就是哈希表．远了，远了，这里不讲HashMap,这里讲数组和链表；

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/WgIKkpg.jpg)

## 数组

> 数组是我们平时用的最多的数据结构，它的特点是<font color=orange>查询数据快，插入数据慢</font>，查询的时间复杂度是<font color=orange>O(1)</font>,插入的时间复杂度是<font color=orange>O(n)</font>.



牛＊一族去学校读书，学校有四人寝和五人寝，大牛，二牛，三牛，四牛一同住进了四人寝里，每天都五缺一；有一天，他们在游戏里认识了小牛，得知小牛也是他们学校的，于是邀请小牛和他们一起住，可是他们们寝室只能住四个人，这个怎么办呢？于是他们向学校(<font color=orange>系统</font>)申请，要求学校给他们一个新的六人寝(<font color=orange>新的内存空间</font>)，于是学校就给了他们新的六人寝，于是他们全部都搬去了六人寝里，小牛也办了进去，之后每天五黑，好不快活；

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/HZUC84m.png)

> 之后有其他学生看到牛＊他们的做法，于是也通通向学校申请；最后学校发现了一个问题：就是学生们为了住进新寝室，花费了大量的时间在从旧寝室到新寝室的路上(<font color=orange>插入数据慢</font>)

 

有的人会说，那一开始就安排大牛，二牛，三牛，四牛住５人寝不就好了吗？这样他们就不用搬了(这就相当于我们初始化数组时，给数组指定了一个大小)；这样的想法是好的，但是如果他们没有没有认识小牛，小牛也不会搬进去，这样他们四个人就一直住着５人寝，就造成了空间资源浪费；



有一天，老师去找进入新寝室的小牛谈话，一看得知小牛在４号床，一下就找到了小牛（<font color=orange>查询数据快</font>），问他在这个寝室住的习不习惯，小牛心想，每天都五黑，你说我习不习惯！！

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/WxdNOVF.gif)

## 链表

> 链表我们平时用的比较少，它的特点是:<font color=orange>插入数据快，查询数据慢</font>，查询的时间复杂度是：<font color=orange>O(n)</font>，插入的时间复杂度是：<font color=orange>O(1)</font>，它的特点是和数组相反的；



　　经过无数日夜的奋战，牛＊一寝人觉得是时候该出去玩玩了，自从小牛搬过来后，就一直没日没夜的五黑，都快不知道外面的世界长什么样子了；他们一行人准备去游乐园转转．

　　来到游乐园后，一群人像刚放出来的一样，对一切都充满了新鲜感，到处转悠．就在转悠的时候，细心的大牛发现了地上有一张纸条，打开一看，上面写着：<font color=orange>＂少年，你渴望力量吗？想获得力量就来海盗船找我！＂</font>，大牛赶紧找来其他小伙伴，一同前往；到了海盗船的地方，发现船上写着：<font color=orange>＂力量源自摩天轮，请前往摩天轮＂</font>，于是一群人就又前往摩天轮，在那里，终于过得了神秘力量－－－<font color=orange>毒鸡汤：你的内心有多强大，你的力量就有多强大</font>；小牛他们为了寻找这个力量，可谓费尽九牛二虎之力啊（<font color=orange>查询数据慢</font>）；

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/Hwi1Car.png)

> 可以发现，<font color=orange>每个元素存着下个元素的地址</font>，所以如果要查找其中某个元素，就必须要从头开始，才能找到．这就比较慢了．但是，他们<font color=orange>添加元素很快</font>,元素可以随机出现在游乐园的某个地方，只要在新添加元素的前一个元素指明新元素的地址在哪里就可以了；



## 发个对比表格吧

### 时间复杂度对比表

|      |  数组   | 链表    |
| :--: | :-----: | ------- |
| 插入 | O(n) 慢 | O(1) 快 |
| 删除 | O(n) 慢 | O(1) 快 |
| 查询 | O(1) 快 | O(n) 慢 |