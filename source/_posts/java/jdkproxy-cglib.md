---
title: JDKproxy和Cglib初探
top: false
cover: false
toc: true
mathjax: true
date: 2020-09-16 15:09:47
password:
summary:
keywords:
description:
tags:
- Java
categories:
- Java
---

# JDKproxy和Cglib初探



## 简介

在Java中，动态代理机制的出现，使得Java开发人员不用手工编写代理类，只要简单地制定一组接口及委托类对象，便能动态地获得代理类。动态代理在Java中有着广泛的应用，比如Spring AOP，Hibernate数据查询、测试框架的后端mock、RPC，Java注解对象获取等。

## JDK原生动态代理(JDKProxy)

`JDKProxy`只能对`实现了接口的类`生成代理，而不能针对`普通类` 。`JDKProxy`原生的`反射API`进行操作，在生成类上比较高效。

### 使用

[](http://xhh.dengzii.com/blog/20200729000830.png)

```java
interface TestInterface{
    void test();
}
class TestClass implements TestInterface{
    @Override
    public void test(){
        System.out.println("JDK动态代理");
    }
}

//主方法
public class JDKProxy {
    public static void main(String[] args) {
        TestClass testClass=new TestClass();
        ProxyHandle proxyHandle=new ProxyHandle(testClass);
        //使用接口
        TestInterface testClass1= (TestInterface) Proxy.newProxyInstance(
                testClass.getClass().getClassLoader(),
                testClass.getClass().getInterfaces(),proxyHandle);
        testClass1.test();
        System.out.println("代理类名称："+testClass1.getClass());
    }
}

//代理
class ProxyHandle implements InvocationHandler{

    private Object originaObj;
    public ProxyHandle(Object o){
        this.originaObj=o;
    }
    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        System.out.println("前置");
        Object object=method.invoke(originaObj,args);
        System.out.println("后置");
        return object;
    }
}
```

```
输出结果：
	前置
    JDK动态代理
    后置
    代理类名称：class com.example.demo.aop.$Proxy0
```



## Cglib

`Cglib`代理是针对`所有类`（包括实现接口的类和普通的类）实现代理，主要是对指定的类**生成一个子类**，覆盖其中的方法(**所以该类或方法不能声明称final的**) 。`Cglib`使用`ASM框架`直接对字节码进行操作，在类的执行过程中比较高效

### 使用

[](http://xhh.dengzii.com/blog/20200729001250.png)

```java
interface InterTest{
    void t1();
}

class InterClass implements InterTest{
    @Override
    public void t1() {
        System.out.println("我是接口测试方法");
    }
}

public class CglibTest {

    public static void main(String[] args) {
        /**
         * 普通类
         * */
        Enhancer enhancer=new Enhancer();
        enhancer.setSuperclass(CG.class);
        enhancer.setCallback(new MethodInterceptor() {
            @Override
            public Object intercept(Object o, Method method,
                                    Object[] objects,
                                    MethodProxy methodProxy) throws Throwable {
                System.out.println("前置");
                Object object=methodProxy.invokeSuper(o,objects);
                System.out.println("后置");
                return object;
            }
        });
        CG cglibTest= (CG) enhancer.create();
        cglibTest.test();
        System.out.println("代理类名称1："+cglibTest.getClass());

        /*
         * 实现了接口的类
         * */
        Enhancer enhancer2=new Enhancer();
        enhancer2.setSuperclass(InterClass.class);
        enhancer2.setCallback(new MethodInterceptor() {
            @Override
            public Object intercept(Object o, Method method,
                                    Object[] objects,
                                    MethodProxy methodProxy) throws Throwable {
                System.out.println("接口类前置");
                Object object=methodProxy.invokeSuper(o,objects);
                System.out.println("接口类后置");
                return object;
            }
        });
        InterClass interClass= (InterClass) enhancer2.create();
        interClass.t1();
        System.out.println("代理类名称2："+interClass.getClass());
    }
}

class CG{
    public void test(){
        System.out.println("代理类测试");
    }
}
```

```
输出结果：
	前置
    代理类测试
    后置
    代理类名称1：class com.example.demo.aop.CG$$EnhancerByCGLIB$$5c6cbf31
    
    接口类前置
    我是接口测试方法
    接口类后置
    代理类名称2：class com.example.demo.aop.InterClass$$EnhancerByCGLIB$$80c75859

```