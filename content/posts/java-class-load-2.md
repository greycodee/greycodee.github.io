---
title: JVM类加载过程
top: false
cover: false
toc: true
mathjax: true
date: 2020-09-16 15:04:22
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



## 加载



1. 通过一个类的全限定名(例如：`java.lang.String`)来获取定义此类的二进制字节流。

2. 将这个字节流所代表的静态存储结构转化为方法区的运行时数据结构。

2. 在内存中生成一个代表这个类的`java.lang.Class`对象，作为方法区这个类的各种数据的访问入口。

> 对于数组类而言，情况就有所不同，数组类本身不通过类加载器创建，它是由Java虚拟机直接在内存中动态构造出来的。



- 从ZIP压缩包中读取，这很常见，最终成为日后JAR、EAR、WAR格式的基础。

- 从网络中获取，这种场景最典型的应用就是Web Applet。

- 运行时计算生成，这种场景使用得最多的就是动态代理技术，在java.lang.reflect.Proxy中，就是用了ProxyGenerator.generateProxyClass()来为特定接口生成形式为“*$Proxy”的代理类的二进制字节流。

- 由其他文件生成，典型场景是JSP应用，由JSP文件生成对应的Class文件。

- 从数据库中读取，这种场景相对少见些，例如有些中间件服务器（如SAP Netweaver）可以选择把程序安装到数据库中来完成程序代码在集群间的分发。

- 可以从加密文件中获取，这是典型的防Class文件被反编译的保护措施，通过加载时解密Class文件来保障程序运行逻辑不被窥探。



## 验证

- 文件格式验证
  - 是否以魔数0xCAFEBABE开头。
  - 主、次版本号是否在当前Java虚拟机接受范围之内
  - 常量池的常量中是否有不被支持的常量类型（检查常量tag标志）。
  - 指向常量的各种索引值中是否有指向不存在的常量或不符合类型的常量。
  - CONSTANT_Utf8_info型的常量中是否有不符合UTF-8编码的数据。
  - ·Class文件中各个部分及文件本身是否有被删除的或附加的其他信息
  - ......
- 元数据验证
  - 这个类是否有父类（除了java.lang.Object之外，所有的类都应当有父类）。
  - 这个类的父类是否继承了不允许被继承的类（被final修饰的类）。
  - 如果这个类不是抽象类，是否实现了其父类或接口之中要求实现的所有方法。
  - 类中的字段、方法是否与父类产生矛盾（例如覆盖了父类的final字段，或者出现不符合规则的方法重载，例如方法参数都一致，但返回值类型却不同等）。
  - ......
- 字节码验证
  - 保证任意时刻操作数栈的数据类型与指令代码序列都能配合工作，例如不会出现类似于“在操作栈放置了一个int类型的数据，使用时却按long类型来加载入本地变量表中”这样的情况。
  - 保证任何跳转指令都不会跳转到方法体以外的字节码指令上。
  - 保证方法体中的类型转换总是有效的，例如可以把一个子类对象赋值给父类数据类型，这是安全的，但是把父类对象赋值给子类数据类型，甚至把对象赋值给与它毫无继承关系、完全不相干的一个数据类型，则是危险和不合法的。
  - ......
- 符号引用验证
  - 符号引用中通过字符串描述的全限定名是否能找到对应的类
  - 在指定类中是否存在符合方法的字段描述符及简单名称所描述的方法和字段。
  - 符号引用中的类、字段、方法的可访问性（private、protected、public、<package>）是否可被当前类访问。
  - ......
- 

## 准备

准备阶段是正式为类中定义的变量（即静态变量，被static修饰的变量）分配内存并设置类变量初始值的阶段

例子：

```java
// 变量value在准备阶段过后的初始值为0而不是123
// 因为这时尚未开始执行任何Java方法 value赋值为123的动作要到类的初始化阶段才会被执行
public static int value = 123
```

![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20200726220517.jpeg)

## 解析

解析阶段是Java虚拟机将常量池内的`符号引用`替换为`直接引用`的过程

- **符号引用（Symbolic References）**：符号引用以一组符号来描述所引用的目标，符号可以是任何形式的字面量，只要使用时能无歧义地定位到目标即可。符号引用与虚拟机实现的内存布局无关，引用的目标并不一定是已经加载到虚拟机内存当中的内容。各种虚拟机实现的内存布局可以各不相同，但是它们能接受的符号引用必须都是一致的，因为符号引用的字面量形式明确定义在《Java虚拟机规范》的Class文件格式中。

  > 下面红框中的都属于符号引用

  ![图片](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20200726220833.png)

- **直接引用（Direct References）**：直接引用是可以直接指向目标的指针、相对偏移量或者是一个能间接定位到目标的句柄。直接引用是和虚拟机实现的内存布局直接相关的，同一个符号引用在不同虚拟机实例上翻译出来的直接引用一般不会相同。如果有了直接引用，那引用的目标必定已经在虚拟机的内存中存在。

## 初始化

参考：[jvm类初始化](https://mp.weixin.qq.com/s?__biz=MzAxMTc4NDUyOA==&tempkey=MTA3MV9NS1dJTVFnVDhRQkRid2hBSDB4aUE2X3Nham5Lcm9VMlpXVlIzTGd4dkk0eDNNb29iV3NlaGh0blA3Z25CcmJ6cXBLYzl5Z09zakZSakNTeFdTOUtkbUQzZnNST0pnUUNTOEhkb1J3Ul84MDhPaEw1bGZSVm9TdXNteG5DLUowSDdmUGxYajkxSWFETENkZ0h0NTY1UkJfOC0yV0laXzdyakNfVDdnfn4%3D&chksm=03a1657734d6ec6126a1c6a802506964f632a2dff53f123de74de0f865b83ef11a9b338a187d#rd)