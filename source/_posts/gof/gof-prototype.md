---
title: 一个故事一个模式-原型模式
top: false
cover: false
toc: true
mathjax: true
date: 2019-12-25 23:34:48
password:
summary:
keywords:
description:
tags:
- 设计模式
- 原型模式
categories:
- GOF
---


![图片](http://cdn.mjava.top/20191226084321.jpg)

> 积千里跬步,汇万里江河;每天进步一点点,终有一天将成大佬
>
> 所有源代码都在这:https://github.com/z573419235/GofDemo
>
> 各位大佬记得点个星星哦

## 前言

​        前几天生病了,每天头昏脑胀的,诶,生病的时候才知道身体健康的重要性,以后还是要加强锻炼,身体是革命的本钱;

​        隔了差不多有五六天没写日志了,罪过罪过;好了,今天要说的是原型模式,原型模式在`Java`中核心秘密就是`clone`这个方法,通过重新`Object`中的`clone`方法.来达到原型模式;而要重新`clone`方法就必须要实现`Cloneable`这个接口,不实现这个接口的话就会报`java.lang.CloneNotSupportedException`异常;





## 我是鸣人

​        鸣人最喜欢的就是吃拉面,就算是上课的时候也是心心念念的想着一乐大叔的拉面

![图片](http://cdn.mjava.top/20191225222050.gif)

先来看看鸣人的原型实体类:

```java
/**
 * @author zheng
 *
 * 我是鸣人实体类
 */
@Data
public class Naruto implements Cloneable{
    /**
     * 姓名
     * */
    private String name="鸣人";
    /**
     * 年龄
     * */
    private int age=13;
    /**
     * 任务
     * */
    private String task;
    /**
     *爱好
     * */
    private ArrayList<String> hobby=new ArrayList<>();
    /**
     * 构造方法
     * */
    public Naruto(){
        this.hobby.add("吃拉面");
        this.hobby.add("泡温泉");
    }

    /**
     * 重写Object类的clone方法
     * */
    @Override
    public Naruto clone(){
        Naruto naruto=null;
        try {
            naruto=(Naruto)super.clone();
        } catch (CloneNotSupportedException e) {
            e.printStackTrace();
        }
        return naruto;
    }

    @Override
    public String toString() {
        return "Naruto{" +
                "name='" + name + '\'' +
                ", age='" + age + '\'' +
                ", task='" + task + '\'' +
                ", hobby=" + hobby +
                '}';
    }
}
```

> 为了代码整洁,我安装了lombok插件,所以不用写get/set方法,直接加个`@Data`注解就可以了;



一天,鸣人上着伊鲁卡老师的课,可是心里还是念念不忘一乐大叔的拉面,想着前几天刚学了影分身之术,想着用分身术逃出去吃拉面.于是他就有变了一个分身留着这上课,自己却跑去吃拉面了;

```java
/**
 * 原型模式
 * @author zheng
 * */
public class Main {
    public static void main(String[] args) {
        //我是鸣人本人
        Naruto naruto=new Naruto();
        //我是影分身
        Naruto narutoYin=naruto.clone();

        narutoYin.setTask("上课");
        naruto.setTask("吃拉面");

        System.out.println("鸣人本人:"+naruto.toString());
        System.out.println("影分身:"+narutoYin.toString());

    }
}

//控制台输出
鸣人本人:Naruto{name='鸣人', age='13', task='吃拉面', hobby=[吃拉面, 泡温泉]}
影分身:Naruto{name='鸣人', age='13', task='上课', hobby=[吃拉面, 泡温泉]}
```

可以看到,鸣人本人的任务是去<font color=orange>吃拉面</font>,他的影分身的任务是留着教室<font color=orange>上课</font>;当然鸣人可以通过他本人创建无数个影分身,同时执行多个任务;这就是<font color=orange>原型模式</font>;

![图片](http://cdn.mjava.top/20191225222314.gif)

## 浅拷贝和深拷贝

原型模式就是通过一个原型clone出多个和原型一样的类,但是拷贝也分<font color=orange>浅拷贝</font>和<font color=orange>深拷贝</font>;

### 浅拷贝

> 浅拷贝有多浅,浅到就相当于没有给你拷贝,他就是让你<font color=orange>和原型共用一个空间,没有给你分配新的内存</font>;

比如上面的鸣人本人有爱好,但是隐分身一般是没有爱好的,所以创建隐分身要吧爱好给清除调:

```java
/**
 * 原型模式
 * @author zheng
 * */
public class Main {
    public static void main(String[] args) {
        //我是鸣人本人
        Naruto naruto=new Naruto();
        //我是影分身
        Naruto narutoYin=naruto.clone();

        narutoYin.setTask("上课");
        //影分身不配有爱好
        narutoYin.getHobby().clear();
        naruto.setTask("吃拉面");

        System.out.println("鸣人本人:"+naruto.toString());
        System.out.println("影分身:"+narutoYin.toString());

    }
}
//控制台输出
鸣人本人:Naruto{name='鸣人', age='13', task='吃拉面', hobby=[]}
影分身:Naruto{name='鸣人', age='13', task='上课', hobby=[]}
```

WTF,竟然把本人的爱好也清除调了,那还去吃啥拉面啊,算了算了,安安心心上课吧,诶;叫你上影分身课是时候不认真,失败了吧!!!

### 深拷贝

> 深拷贝就是在`clone`方法里除了克隆类之外,还要克隆引用对象,这样才会重新给引用对象<font color=orange>分配新的内存空间</font>

进过上次的教训,鸣人苦练影分身之术,终于学得核心所在,看看他新的影分身技能吧:

![图片](http://cdn.mjava.top/20191225220944.png)

在变一个看看:

```java
/**
 * 原型模式
 * @author zheng
 * */
public class Main {
    public static void main(String[] args) {
        //我是鸣人本人
        Naruto naruto=new Naruto();
        //我是影分身
        Naruto narutoYin=naruto.clone();

        narutoYin.setTask("上课");
        //影分身不配有爱好
        narutoYin.getHobby().clear();
        naruto.setTask("吃拉面");

        System.out.println("鸣人本人:"+naruto.toString());
        System.out.println("影分身:"+narutoYin.toString());

    }
}
//控制台输出
鸣人本人:Naruto{name='鸣人', age='13', task='吃拉面', hobby=[吃拉面, 泡温泉]}
影分身:Naruto{name='鸣人', age='13', task='上课', hobby=[]}
```

哈哈,成功了,这下可以安安心心的区吃拉面了吧;

![图片](http://cdn.mjava.top/20191225222402.gif)

## 总结

​        引用设计模式之禅的一句话:内部的数组和引用对象才不拷贝，其他的原始类型比如`int`、`long`、`char`等都会被拷贝，但是对于`String`类型，`Java`就希望你把它认为是基本类型，它是没有clone方法的，处理机制也比较特殊，通过字符串池（stringpool）在需要的时候才在内存中创建新的字符串，在使用的时候就把`String`当做基本类使用即可。注意:<font color=orange>使用clone方法，在类的成员变量上就不要增加final关键字,否则当你重新设置这个成员变量的值时是不能设置的,因为final的不可变的,只能引用原来的值</font>