---
title: Java类初始化
top: false
cover: false
toc: true
mathjax: true
date: 2020-09-16 15:01:03
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



## 代码结果？

首先，我们来看看下面的代码的输出的结果，可以先试着想一下

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20200725004926.png)



```java
//结果
Code
公众号
```

这时候有同学就会想，以前不是说类加载时，静态代码块都会加载的嘛！怎么`Test1`里的静态代码块没有加载呢？下面就来看看到底怎么回事

## 类的生命周期

了解类加载前，首先熟悉一下类的生命周期

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20200725003859.png)

这里注意几个点：

- `解析阶段`可以在`初始化阶段`之后，这是为了支持Java语言的运行时绑定特性（也称为`动态绑定`或`晚期绑定`）
- 这些阶段通常都是互相交叉地混合进行的，会在一个阶段执行的过程中调用、激活另一个阶段。

## 初始化和实例化

我相信很多人跟我刚开始一样，搞不清他们两个的区别，搞不清`new`一个对象，到底是对这个对象进行了初始化还是实例化呢？

- `初始化`：是完成程序执行前的准备工作。在这个阶段，静态的（变量，方法，代码块）会被执行。同时在会开辟一块存储空间用来存放静态的数据。初始化只在类加载的时候执行`一次`。

- `实例化`：是指创建一个对象的过程。这个过程中会在堆中开辟内存，将一些非静态的方法，变量存放在里面。在程序执行的过程中，可以创建多个对象，既多次实例化。每次实例化都会开辟一块新的内存。

  ![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20200725183421.png)



## 类的初始化

《Java虚拟机规范》中并没有对`加载`进行强制约束，这点可以交给虚拟机的具体实现来自由把握。但是对于`初始化阶段`，《Java虚拟机规范》则是严格规定了有且只有`六种情况`必须立即对类进行“初始化”（而加载、验证、准备自然需要在此之前开始）：

- 遇到`new`、`getstatic`、`putstatic`或`invokestatic`这四条字节码指令时，如果类型没有进行过初始化，则需要先触发其初始化阶段。那到底什么时候能够生成这些指令呢？其实看下字节码就都明白了

  ![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20200725172134.png)

- 使用`java.lang.reflect`包的方法对类型进行`反射调用`的时候，如果类型没有进行过初始化，则需要先触发其初始化。
- 当初始化类的时候，如果发现其`父类`还没有进行过初始化，则需要先触发其父类的初始化。
- 当虚拟机启动时，用户需要指定一个要执行的`主类`（包含main()方法的那个类），虚拟机会先初始化这个主类。
- 当使用JDK 7新加入的动态语言支持时，如果一个`java.lang.invoke.MethodHandle`实例最后的解析结果为`REF_getStatic`、`REF_putStatic`、`REF_invokeStatic`、`REF_newInvokeSpecial`四种类型的方法句柄，并且这个方法句柄对应的类没有进行过初始化，则需要先触发其初始化。
- 当一个接口中定义了`JDK 8`新加入的默认方法（被`default关键字`修饰的接口方法）时，如果有这个接口的实现类发生了初始化，那该接口要在其之前被初始化。

> `java.lang.invoke.MethodHandle` 是`JDK7`中新加入类似反射功能的一个类



## 被动引用

对于以上这六种会触发类型进行`初始化`的场景，《Java虚拟机规范》中使用了一个非常强烈的限定语——“有且只有”，这六种场景中的行为称为对一个类型进行`主动引用`。除此之外，所有引用类型的方式都不会触发初始化，称为`被动引用。`

像文章一开始的代码，就属于被动引用，对于静态字段，**只有直接定义这个字段的类才会被初始化**，因此通过其子类来引用父类中定义的静态字段，只会触发父类的初始化而不会触发子类的初始化。



### 例子1--对象数组

直接上图

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20200725184328.png)

以上代码执行后并不会输出`灰色`两个字，因为创建对象数组时并没有去初始化`Test1`这个类，而是用`anewarray`字节码指令去初始化了另外一个类，它是一个由虚拟机自动生成的、直接继承于java.lang.Object的子类。



> 拓展：数组越界检查没有封装在数组元素的访问类中，而是封装在数组访问的`xaload`,`xastore`字节码指令中

### 例子2--final修饰的静态字段

- 被`final`修饰的静态字段

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20200725194122.png)

此时运行该代码时，只会输出`灰色Code`字样，`Test1`并没有触发初始化阶段。这是因为在`编译阶段`通过`常量传播优化`，已经将此常量的值`灰色Code`直接存储在`ClassLoadTest`类的常量池中，所以当`ClassLoadTest`类调用`Test1`里的`value`时，都变成了对自身常量池的调用，和`Test1`类没有任何关系。



- 没有`final`修饰的静态字段

  ![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20200725194514.png)

没有使用`final`修饰的静态变量，字节码出现了`getstatic`，所以触发`Test1`的初始化阶段，此时运行结果将会输出`灰色`和`灰色Code`