---
title: 更新驱动到mysql-connector-java-8遇到的一些问题
top: false
cover: false
toc: true
mathjax: true
date: 2019-12-25 17:07:12
password:
summary:
keywords:
description:
tags:
- Pit
- MySQL
categories:
- MySQL
---

# 更新驱动到mysql-connector-java-8遇到的一些问题



## 问题

### POM

```java
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.16</version>
</dependency>
```

## application.properties

```properties
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
```



项目是`SpringBoot`构建的,数据库版本是:`MySQL5.7`,用了`mysql-connector-java-8`来链接数据库,`application.properties`也配置成`spring.datasource.driver-class-name=com.mysql.jdbc.Driver`,中间遇到了几个问题;

### 问题一

#### 描述

如上配置后,控制台报了一下错误:

```shell
Loading class `com.mysql.jdbc.Driver'. This is deprecated. The new driver class is `com.mysql.cj.jdbc.Driver'. The driver is automatically registered via the SPI and manual loading of the driver class is generally unnecessary.
```

翻译过来后就是:

加载类` com.mysql.jdbc.Driver`。 不推荐使用。 新的驱动程序类为` com.mysql.cj.jdbc.Driver`。 通过SPI自动注册驱动程序，通常不需要手动加载驱动程序类。

#### 解决

根据提示,解决方法有<font color=orange>两种</font>:

- 更改`application.properties`文件

```properties
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
//改成下面这样
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

- 去掉`application.properties`文件中的`spring.datasource.driver-class-name`,因为它说会通过SPI自动注册的;

### 问题二

#### 描述

数据库的数据时间总是和实际时间差8个小时

#### 解决

在数据库url添加`serverTimezone=GMT%2B8`

```properties
spring.datasource.url=jdbc:mysql://10.25.0.01:3307/db?useUnicode=true&autoReconnect=true&characterEncoding=UTF-8&serverTimezone=GMT%2B8
```

## 总结

`mysql-connector-java`5.X的版本驱动名是:`com.mysql.jdbc.Driver`; 6.X及以上版本的驱动名是:`com.mysql.cj.jdbc.Driver`