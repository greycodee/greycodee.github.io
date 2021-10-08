---
title: 设计模式之建造者模式【用好玩的故事讲清楚设计模式】
top: false
cover: false
toc: true
mathjax: true
date: 2019-12-27 06:50:31
password:
summary:
keywords:
description:
tags:
- 设计模式
- 建造者模式
categories:
- GOF
---



![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/6aL0UN5-20211008161857935.jpg)

> 积千里跬步,汇万里江河;每天进步一点点,终有一天将成大佬
>
> 所有源代码都在这:[https://github.com/z573419235/GofDemo](https://github.com/z573419235/GofDemo)
>
> 各位大佬记得点个星星哦

## 前言

建造者模式用于实例化一个比较复杂的实体类,<font color=orange>当你实例化一个类时,它的构造参数比较多时,就可以用建造者模式来简化实例化过程</font>;前几篇工厂模式的文章我们说道买车,那只是简单的区工厂买车,我们不关系工厂是怎么造出来的.可是实际工厂造一辆车需要有方向盘、发动机、车架、轮胎等部件,而且不同品牌的车的部件都是不同的,<font color=orange>部件虽然不同,但是造车的方式基本都是差不多的步骤</font>,这时候就可以用建造者模式来造一辆车了;

建造者（Builder）模式由产品、抽象建造者、具体建造者、指挥者等 4 个要素构成

## 土豪朋友开车厂

        土豪朋友上次买了车之后,发现造车卖还挺赚钱,于是决定涉足汽车领域,真是很有商业头脑啊,不愧是我的玉树临风,疯言疯语,语速惊人,人模狗样的土豪朋友啊.

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/uLylNOc.jpg)

一天,前去向他讨教汽车的知识,他给我讲了汽车的大致构成:

```java
/**
 * 汽车 产品类 定义汽车的构成
 * */
@Data
public class Car {
    /**
     * 方向盘
     * */
    private String steering;
    /**
     * 发动机
     * */
    private String engine;
    /**
     * 车架
     * */
    private String frame;
    /**
     * 轮胎
     * */
    private String tire;
    /**
     * 展示一下汽车配置
     * */
    public String show() {
        return "{" +
                "steering='" + steering + '\'' +
                ", engine='" + engine + '\'' +
                ", frame='" + frame + '\'' +
                ", tire='" + tire + '\'' +
                '}';
    }
}
```

果真是大致啊,忽悠我不懂车是吧,就给我讲4个东西,这谁不知道啊,哼!土豪朋友忙解释到:这不是为了通俗易懂嘛!!哈哈哈---土豪朋友尴尬而不失礼貌的笑着!

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/nG187Zz.jpg)

算了算了,不和你计较了,你再和我讲下你们车厂的造车模式吧!!他说,一开始他造车自己累的半死,什么都要亲力亲为,后来招了两个专家,<font color=orange>一个负责宝马的制造,一个负责奔驰的制造</font>,我现在要什么车,只要指挥谁造车就好了.轻松的很;

他给我介绍了一下他的两个专家:

```java
/**
 * 宝马车建造者
 * */
public class BMWBuilder extends AbstractBuild {
    @Override
    void buildEngine() {
        car.setEngine("宝马的发动机");
    }

    @Override
    void buildSteering() {
        car.setSteering("宝马的方向盘");
    }

    @Override
    void buildFrame() {
        car.setFrame("宝马的车架");
    }

    @Override
    void buildTire() {
        car.setTire("宝马的轮胎");
    }
}
```

```java
/**
 * 奔驰车建造者
 * */
public class BenzBuilder extends AbstractBuild {
    @Override
    void buildEngine() {
        car.setEngine("奔驰的发动机");
    }

    @Override
    void buildSteering() {
        car.setSteering("奔驰的方向盘");
    }

    @Override
    void buildFrame() {
        car.setFrame("奔驰的车架");
    }

    @Override
    void buildTire() {
        car.setTire("奔驰的轮胎");
    }
}
```

<font color=orange>他们两个都遵循下面这个`AbstractBuild`汽车的建造规则:</font>

```java
/**
 * 抽象建造者 定义造车的方法
 * */
abstract class AbstractBuild {
    /**
     * 造的产品是车
     * */
    protected Car car=new Car();
    /**
     * 造发动机
     * */
    abstract void buildEngine();
    /**
     * 造轮胎
     * */
    abstract void buildSteering();
    /**
     * 造车架
     * */
    abstract void buildFrame();
    /**
     * 造轮胎
     * */
    abstract void buildTire();
    /**
     * 得到造好的车
     * */
    public Car getCar(){
        return this.car;
    }
}
```

土豪朋友还跟我讲了是怎么指挥他们造车的:

```java
/**
 * 所有的建造者要听这个包工头的话,叫你造什么就造什么
 * */
public class Boss {

    public static Car builderCar(AbstractBuild build){
        build.buildEngine();
        build.buildFrame();
        build.buildSteering();
        build.buildTire();
        return build.getCar();
    }
}
```

经过他这一翻显摆之后,感觉虽然长的人摸狗样的,干起事来还真是一套一套的,哈哈哈哈!!

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/hbg0zDY.jpg)

说完,还向我展示了汽车是怎样造成的...........

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/JDX2qIc.png)

## 总结

其实建造者模式和<font color=orange>工厂模式</font>还是挺像的,<font color=orange>建造者模式里的建造者就相当于工厂模式里的工厂</font>,不过建造者的核心是可以<font color=orange>控制顺序</font>,比如上面的土豪老板可以控制建造工人的建造顺序,可以控制他们是先造轮胎还是先造发动机,这才是建造者模式意义;

> 建造者模式如果和<font color=orange>模板方法模式</font>搭配起来,<font color=orange>建造工人那个类封装一个模板方法</font>开放给老板,老板就可以直接控制这个类就可以了,那这就和工厂模式没什么两样了