---
title: JVM中的双亲委派机制
top: false
cover: false
toc: true
mathjax: true
date: 2020-09-16 15:02:34
password:
summary:
keywords:
description:
tags:
- JVM
- Java
categories:
- JVM
---



## 四种类加载器

- 启动类加载器(Bootstrap Class Loader )：加载`$JAVA_HOME/jre/lib`目录下的jar包
- 拓展类加载器(Extension Class Loader)：加载`$JAVA_HOME/jre/lib/ext`目录下的jar包
- 应用程序类加载器(Application Class Loader)：加载`ClassPath`目录下的jar包
- 自定义类加载器(User Class Loader)：加载自定义指定目录下的jar包

## 双亲委派机制

>  如果一个类加载器收到了类加载的请求，它首先不会自己去尝试加载这个类，而是把这个请求委派给父类加载器去完成，每一个层次的类加载器都是如此，因此所有的加载请求最终都应该传送到最顶层的启动类加载器中，只有当父加载器反馈自己无法完成这个加载请求（它的搜索范围中没有找到所需的类）时，子加载器才会尝试自己去完成加载。

![图片](http://cdn.mjava.top/blog/20200726204658.jpg)

## 代码示例

> 当获取`Bootstrap class loader`的时候，输出了`null`，说明**开发者无法通过引用操作启动类加载器**

![图片](http://cdn.mjava.top/blog/20200726210142.png)



## 双亲委派机制的作用

每个加载器都只需要固定的加载自己管理范围内的类，这样的好处就是`保证了Java体系的稳定`，不然的话你自己定义一个`String`类的话，这样系统中就会有两个`String`类，如果没有双亲委派机制的话，系统就不知道到底该加载哪一个，这样系统就变得一片混乱了。

## 破坏双亲委派机制

双亲委派机制是Java设计者推荐给开发者们的类加载实现方式，并不是一个强制性约束的模型，所以也可以人为的破坏这个机制。

- 源码

> 源码在`java.lang.ClassLoader`有兴趣的可以去看下

![图片](http://cdn.mjava.top/blog/20200726212038.png)

可以看到，就这短短的几行代码，就实现了听起来很高大上的`双亲委派机制`，所以破坏双亲委派机制的话，就直接重写`loadClass`方法就可以了。