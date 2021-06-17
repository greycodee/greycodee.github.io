---
title: 浅谈MDC
top: false
cover: false
toc: true
mathjax: true
date: 2020-09-16 15:10:47
password:
summary:
keywords:
description:
tags:
- Logback
- MDC
categories:
- Java
---



## MDC是什么？

`MDC` 全拼 `Mapped Diagnostic Contexts`，是`SLF4J`类日志系统中实现分布式多线程日志数据传递的重要工具；可利用`MDC`将一些运行时的上下文数据打印出来。目前只有`log4j`和`logback`提供原生的`MDC`支持；

## 简单使用

`MDC`里面提供的都是静态方法，所以可以直接调用

```java
// 设置一个key
MDC.put("name","灰色Code");

// 获取一个key的值
MDC.get("name");
    
// 删除一个key
MDC.remove("name");
    
// 清空MDC里的内容
MDC.clear();

// 获取上下文中的map
Map<String,String> map = MDC.getCopyOfContextMap();

// 设置MDC的map
MDC.setContextMap(map);
```



## 源码解析

### MDC

通过阅读`MDC`的源码可以发现，它其实是调用了`MDCAdapter`的接口来实现的

![图片](http://cdn.mjava.top/blog/20200729200214.png)



### MDCAdapter

`MDCAdapter`接口有三个实现类，而`MDC`是调用了`LogbackMDCAdapter`里的方法(在MDC里有一个静态代码块，实例化了这个对象)

![图片](http://cdn.mjava.top/blog/20200729201118.png)

### LogbackMDCAdapter

**而**`LogbackMDCAdapter`主要是用`ThreadLocal`在线程上下文中维护一个`HashMap`来实现的

![图片](http://cdn.mjava.top/blog/20200729201650.png)

## 总结

怎么样,实现原理是不是很简单，就这么短短几行代码，就实现了听起来很高大上的`MDC`。

所以简单来说，`MDC`就是利用`ThreadLocal`在线程中维护了一个`HashMap`，利用`HashMap`来存放数据