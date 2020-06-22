---
title: 创建一个自定义注解
top: false
cover: false
toc: true
mathjax: true
date: 2020-06-22 16:23:56
password:
summary:
keywords:
description:
tags:
- Spring AOP
- 注解
categories:
- Spring
---

## 前言

平时在用springBoot的使用，常常会用到`@Service`，`@Compent`等等注解，简化了我们的开发流程，提升了开发效率.那如何自己来写一个注解呢？下面就来介绍一下。



## 写一个注解

创建一个注解主要分两部分，一部分是创建**注解类**，一部分是创建一个**切面类**。

### 创建注解类

```java
@Target({ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
public @interface MyAnn {
    String value() default "d";
}
```

创建注解类的关键字就是`@interface`，这个注解类设置了一个`value`变量，默认值为d；

在注解类上面还有`@Target`和`@Retention`注解，下面来说说创建注解类时需要用到的几个注解：

#### `@Target`

用来标记这个注解可以用于哪些地方，与`ElementType`枚举类搭配使用，那这个枚举类里面有什么内容呢？

```java
public enum ElementType {
    /** 类，接口（包括注释类型）或枚举声明*/
    TYPE,

    /** 字段声明（包括枚举常量）*/
    FIELD,

    /** 方法声明*/
    METHOD,

    /** 形式参数（形参-调用方法时传入的参数）声明 */
    PARAMETER,

    /** 构造函数声明 */
    CONSTRUCTOR,

    /** 局部变量声明 */
    LOCAL_VARIABLE,

    /** 注释类型声明 */
    ANNOTATION_TYPE,

    /** 包声明 */
    PACKAGE,

    /**
     * 类型参数声明
     * java8新特性：
     * @since 1.8
     */
    TYPE_PARAMETER,

    /**
     * 任何类型声明 
     * java8新特性：
     * @since 1.8
     */
    TYPE_USE
}
```

#### `@Retention`

该注解表示自定义注解的生命周期

```java
public enum RetentionPolicy {
    /**
     * 注释将被编译器丢弃。
     */
    SOURCE,

    /**
     * 注释由编译器记录在类文件中
     * 但不必在运行时由VM保留。 这是默认值
     */
    CLASS,

    /**
   	 *注释由编译器记录在类文件中，并且
     *在运行时由VM保留，因此可以以反射方式读取它们。
     */
    RUNTIME
}

```

## 写一个切面类

因为用到了切面，所以我们要先导入`Spring AOP`这个依赖包。

```xml
<!--SpringBoot项目导入AOP-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-aop</artifactId>
</dependency>
```

### 创建切面类

```java
@Aspect
@Component
public class MyAnnAop {
    private Logger logger= LoggerFactory.getLogger(MyAnnAop.class);
    @Pointcut("@annotation(com.example.demo.annotation.MyAnn)")
    public void ann(){
    }
    @Before("ann()")
    public void before(JoinPoint joinPoint){
        logger.info("打印：开始前");
    }
    @AfterReturning(value = "ann()",returning = "res")
    public Object dochange(JoinPoint joinPoint,Object res){
        logger.info("AfterReturning通知开始-获取数据:{}",res);
        //获取数据
        Map<String,String> map= (Map<String, String>) res;
        //添加新值
        map.put("s1","我是在AOP中添加的新值");
        return map;
    }
}
```

### Spring AOP说明

> 具体可以查阅Spring AOP相关资料

| 注解              | 说明                                                         |
| ----------------- | ------------------------------------------------------------ |
| `@Before`         | 前置通知，在连接点方法前调用                                 |
| `@Around`         | 环绕通知，它将覆盖原有方法，但是允许你通过反射调用原有方法   |
| `@After`          | 后置通知，在连接点方法后调用                                 |
| `@AfterReturning` | 返回通知，在连接点方法执行并正常返回后调用，要求连接点方法在执行过程中没有发生异常 |
| `@AfterThrowing`  | 异常通知，当连接点方法异常时调用                             |

## 使用自定义的注解

这里使用普通的`SpringBoot`来使用注解，创建一个**Service**,在里面使用注解，然后才控制层调用

```java
//服务层
@Service
public class TestService {
    @MyAnn
    public Map test(){
        Map<String,String>  map=new HashMap<>();
        map.put("t1","我是在Service设置的值");
        return map;
    }
}

//控制层
@RestController
public class Test2 {
    private Logger logger= LoggerFactory.getLogger(Test2.class);

    @Autowired
    private TestService testService;

    @GetMapping("/test")
    public String test(String id){
        Map<String,String> s=testService.test();
        logger.info("控制层输出：{}",s.get("s1"));
        return "sccess";
    }
}
```

#### 输出

```shell
com.example.demo.aop.MyAnnAop : AfterReturning通知开始-获取数据:{t1=我是在Service设置的值}
com.example.demo.web.Test2    : 控制层输出：我是在AOP中添加的新值
```

## 注意事项

上面那样使用注解是没问题的，但是如果是下面这样使用，`AOP`就会**失效**

```java
@RestController
public class Test2 {
    private Logger logger= LoggerFactory.getLogger(Test2.class);

    @Autowired
    private TestService testService;

    @GetMapping("/test")
    public String test(String id){
        Map<String,String> s=this.test2();
        logger.info("控制层输出：{}",s.get("s1"));
        return "sccess";
    }

    @MyAnn
    public Map test2(){
        Map<String,String>  map=new HashMap<>();
        map.put("t1","我是在控制层设置的值");
        return map;
    }
}
```

#### 输出

```shell
com.example.demo.web.Test2       : 控制层输出：null
```

这是应为内部方法调用，调用的是具体方法，并没有调用使用AOP后生成的代理方法

具体参考资料：

- https://blog.csdn.net/Daybreak1209/article/details/82982674
- https://blog.csdn.net/u013151053/article/details/106124048?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.nonecase&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.nonecase
- https://zhewuzhou.github.io/2018/09/01/Spring_AOP_Trap/